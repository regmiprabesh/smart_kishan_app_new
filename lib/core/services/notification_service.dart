import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

import '../di/injector.dart';

/// All FCM logic. Notification taps simply push the payload's route into
/// go_router — the redirect guard does the rest:
///   logged in       → opens the page (on top of current stack)
///   restoring/out   → held at splash / sign-in with ?from=, then opens
///                     the page automatically after restore/login.
/// No pending queue, no special cold-start handling: the guard IS the queue.
///
/// Server payload convention (route = a literal app path):
///   { "notification": {...}, "data": { "route": "/subsidies/12" } }
///
/// Covers all three app states:
///   TERMINATED  → getInitialMessage (after router exists)
///   BACKGROUND  → onMessageOpenedApp
///   FOREGROUND  → shown via flutter_local_notifications; tap → same path
class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  String? token;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'smart_kishan_default', // must match AndroidManifest meta-data
    'General Notifications',
    importance: Importance.high,
  );

  Future<void> init() async {
    await _fcm.requestPermission(alert: true, badge: true, sound: true);
    await _initLocalNotifications();
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    token = await _fcm.getToken();
    _fcm.onTokenRefresh.listen((t) {
      token = t;
      // TODO(phase2): AuthRepository.syncFcmToken(t) when authenticated.
    });

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _openFromData(m.data));

    final initial = await _fcm.getInitialMessage();
    if (initial != null) _openFromData(initial.data);
  }

  void _openFromData(Map<String, dynamic> data) {
    final route = data['route'] as String?;
    if (route == null || !route.startsWith('/')) return;
    sl<GoRouter>().push(route);
  }

  Future<void> _initLocalNotifications() async {
    await _local.initialize(
      settings: InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == null) return;
        try {
          _openFromData(jsonDecode(response.payload!) as Map<String, dynamic>);
        } catch (e) {
          debugPrint('Notification payload parse error: $e');
        }
      },
    );

    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _local.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }
}
