import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../services/local_storage_service.dart';

// ─────────────────────────────────────────────────────────────────────
// Typed failures — the ONLY error surface repositories/cubits ever see.
// Dio's own exceptions never leak past this file.
// ─────────────────────────────────────────────────────────────────────

sealed class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => '$runtimeType($statusCode): $message';
}

class NoInternetException extends ApiException {
  const NoInternetException() : super('No internet connection');
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message) : super(statusCode: 401);
}

class ValidationException extends ApiException {
  const ValidationException(super.message, {this.errors})
    : super(statusCode: 422);
  final Map<String, dynamic>? errors;
}

class ThrottledException extends ApiException {
  const ThrottledException(super.message, {required this.retryAfterSeconds})
    : super(statusCode: 429);
  final int retryAfterSeconds;
}

class ServerException extends ApiException {
  const ServerException(super.message, {super.statusCode});
}

/// Decoded successful response.
class ApiResponse {
  const ApiResponse({required this.statusCode, required this.body});
  final int statusCode;
  final Map<String, dynamic> body;

  dynamic get data => body['data'];
}

class ApiClient {
  ApiClient({
    required String baseUrl,
    required LocalStorageService storage,
    required void Function() onUnauthorized,
    Dio? dio, // injectable for tests
  }) : _onUnauthorized = onUnauthorized,
       _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl,
               connectTimeout: const Duration(seconds: 15),
               receiveTimeout: const Duration(seconds: 20),
               headers: {'Accept': 'application/json'},
               // We map status codes ourselves in _handle — don't let
               // Dio throw on non-2xx before we see the body.
               validateStatus: (_) => true,
             ),
           ) {
    _dio.interceptors.add(_AuthInterceptor(storage));
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (o) => debugPrint(o.toString()),
        ),
      );
    }
  }

  final Dio _dio;
  final void Function() _onUnauthorized;

  Future<ApiResponse> get(
    String path, {
    Map<String, String>? query,
    bool auth = true,
  }) => _send(
    () => _dio.get(path, queryParameters: query, options: _options(auth)),
  );

  Future<ApiResponse> post(String path, {Object? body, bool auth = true}) =>
      _send(() => _dio.post(path, data: body, options: _options(auth)));

  Future<ApiResponse> put(String path, {Object? body, bool auth = true}) =>
      _send(() => _dio.put(path, data: body, options: _options(auth)));

  Future<ApiResponse> delete(String path, {bool auth = true}) =>
      _send(() => _dio.delete(path, options: _options(auth)));

  /// Multipart upload (images, documents). [files] maps a field name to
  /// a local file path; [fields] are plain form fields.
  ///   await api.postMultipart('/farmlands', fields: {...},
  ///       files: {'image': pickedFile.path});
  Future<ApiResponse> postMultipart(
    String path, {
    Map<String, String> fields = const {},
    Map<String, String> files = const {},
    bool auth = true,
    void Function(int sent, int total)? onSendProgress,
  }) => _send(() async {
    final form = FormData.fromMap({
      ...fields,
      for (final e in files.entries)
        e.key: await MultipartFile.fromFile(e.value),
    });
    return _dio.post(
      path,
      data: form,
      options: _options(auth),
      onSendProgress: onSendProgress,
    );
  });

  // ── Internals ──────────────────────────────────────────────────────

  Options _options(bool auth) =>
      Options(extra: {_AuthInterceptor.authFlag: auth});

  Future<ApiResponse> _send(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      return _handle(await request());
    } on DioException catch (e) {
      // With validateStatus: true, DioException here means the request
      // never produced a response: connectivity, timeout, etc.
      switch (e.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw const NoInternetException();
        default:
          throw ServerException(e.message ?? 'Request failed');
      }
    }
  }

  ApiResponse _handle(Response<dynamic> response) {
    final body = _asMap(response.data);
    final status = response.statusCode ?? 0;

    if (status >= 200 && status < 300) {
      return ApiResponse(statusCode: status, body: body);
    }

    final message = body['message']?.toString() ?? 'Request failed';
    switch (status) {
      case 401:
        _onUnauthorized(); // single session-expiry path (SessionCubit)
        throw UnauthorizedException(message);
      case 422:
        throw ValidationException(
          message,
          errors: body['errors'] as Map<String, dynamic>?,
        );
      case 429:
        throw ThrottledException(
          message,
          retryAfterSeconds: (body['retry_after'] as num?)?.toInt() ?? 60,
        );
      default:
        throw ServerException(message, statusCode: status);
    }
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data == null) return const {};
    if (data is Map<String, dynamic>) return data;
    return {'data': data};
  }
}

/// Attaches `Authorization: Bearer <token>` to every request unless the
/// call opted out (auth: false on login/register/otp).
class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._storage);

  static const String authFlag = 'auth';
  final LocalStorageService _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final needsAuth = options.extra[authFlag] as bool? ?? true;
    if (needsAuth) {
      final token = await _storage.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }
}
