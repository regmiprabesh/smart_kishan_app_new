import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';

/// Full-screen PDF viewer for a network URL **or** a local file path
/// (auto-detected). Reusable across features (subsidy documents, complaints…).
class AppPdfPreview extends StatefulWidget {
  const AppPdfPreview({super.key, required this.source, this.title});

  /// An http(s) URL or a local file path.
  final String source;
  final String? title;

  static Future<void> open(
    BuildContext context,
    String source, {
    String? title,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AppPdfPreview(source: source, title: title),
      ),
    );
  }

  bool get _remote =>
      source.startsWith('http://') || source.startsWith('https://');

  @override
  State<AppPdfPreview> createState() => _AppPdfPreviewState();
}

class _AppPdfPreviewState extends State<AppPdfPreview> {
  int _page = 0;
  int _total = 0;
  bool _ready = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;

    final pdf = PDF(
      enableSwipe: true,
      autoSpacing: true,
      pageFling: true,
      pageSnap: true,
      onError: (e) => setState(() => _error = e.toString()),
      onPageError: (page, e) => setState(() => _error = e.toString()),
      onRender: (pages) => setState(() {
        _ready = true;
        _total = pages ?? 0;
      }),
      onPageChanged: (page, total) => setState(() {
        _page = page ?? 0;
        _total = total ?? 0;
      }),
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title ?? l10n.commonDocument,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            if (_ready && _total > 0)
              Text(
                '${context.ld(_page + 1)} / ${context.ld(_total)}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
      // Remote: fromUrl owns its loading (placeholder) + failure (errorWidget),
      // returned directly so it fills the body with tight constraints.
      // Local: fromPath has no placeholder, so we overlay our own while it
      // renders and swap to the error view if onError fires.
      body: widget._remote
          ? pdf.fromUrl(
              widget.source,
              placeholder: (progress) => _loading(context, progress),
              errorWidget: (_) => _errorView(context),
            )
          : Stack(
              children: [
                if (_error == null) pdf.fromPath(widget.source),
                if (_error == null && !_ready) _loading(context, null),
                if (_error != null) _errorView(context),
              ],
            ),
    );
  }

  Widget _loading(BuildContext context, double? progress) {
    return Center(
      child: CircularProgressIndicator(
        color: context.colors.primary,
        value: progress != null ? progress / 100 : null,
      ),
    );
  }

  Widget _errorView(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: colors.background,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 56, color: colors.error),
          const SizedBox(height: 12),
          Text(
            l10n.commonPdfError,
            style: TextStyle(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
