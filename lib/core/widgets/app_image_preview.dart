import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

/// Full-screen image gallery. The image fills the ENTIRE viewport (so it's
/// truly centered); the close button, top faded strip, and bottom thumbnail
/// selector float ON TOP as overlays (Stack), exactly like the reference.
///
/// Single or multiple images. Reused by farmland (1) and products (many).
/// Broken URLs degrade gracefully.
class AppImagePreview extends StatefulWidget {
  const AppImagePreview({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  final List<String> imageUrls;
  final int initialIndex;

  static Future<void> open(
    BuildContext context, {
    required List<String> imageUrls,
    int initialIndex = 0,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) =>
            AppImagePreview(imageUrls: imageUrls, initialIndex: initialIndex),
      ),
    );
  }

  @override
  State<AppImagePreview> createState() => _AppImagePreviewState();
}

class _AppImagePreviewState extends State<AppImagePreview> {
  late final PageController _pageController;
  late int _index;

  bool get _multi => widget.imageUrls.length > 1;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int i) {
    setState(() => _index = i);
    _pageController.animateToPage(
      i,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: colors.background,
      // No AppBar — it would steal vertical space and offset the image.
      body: Stack(
        children: [
          // ── Image fills the WHOLE viewport → truly centered ──
          Positioned.fill(
            child: PhotoViewGallery.builder(
              pageController: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: (i) => setState(() => _index = i),
              backgroundDecoration: BoxDecoration(color: colors.background),
              loadingBuilder: (_, __) => Center(
                child: CircularProgressIndicator(color: colors.primary),
              ),
              builder: (context, i) {
                return PhotoViewGalleryPageOptions.customChild(
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrls[i],
                    fit: BoxFit.contain,
                    placeholder: (_, __) => Center(
                      child: CircularProgressIndicator(color: colors.primary),
                    ),
                    errorWidget: (_, __, ___) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            color: colors.iconSecondary,
                            size: 56,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Image unavailable',
                            style: TextStyle(color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Top faded thumbnail strip (multi only) — overlay ──
          if (_multi)
            Positioned(
              top: topInset,
              left: 0,
              right: 80, // clear of the close button
              height: 84,
              child: ShaderMask(
                shaderCallback: (rect) => const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black, Colors.black],
                  stops: [0.0, 0.5, 1.0],
                ).createShader(rect),
                blendMode: BlendMode.dstIn,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: widget.imageUrls.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (_, i) => Opacity(
                    opacity: i == _index ? 1 : 0.4,
                    child: _MiniThumb(
                      url: widget.imageUrls[i],
                      onTap: () => _goTo(i),
                    ),
                  ),
                ),
              ),
            ),

          // ── Close button (overlay, top-right) ──
          Positioned(
            top: topInset + 8,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(Icons.close, color: colors.textPrimary, size: 24),
              ),
            ),
          ),

          // ── Bottom thumbnail selector (multi only) — overlay ──
          if (_multi)
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomInset + 12,
              height: 68,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: widget.imageUrls.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _SelectorThumb(
                  url: widget.imageUrls[i],
                  selected: i == _index,
                  onTap: () => _goTo(i),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Small faded thumbnail in the top strip.
class _MiniThumb extends StatelessWidget {
  const _MiniThumb({required this.url, required this.onTap});
  final String url;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 48,
          height: 48,
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => Container(
              color: Colors.white12,
              child: const Icon(
                Icons.broken_image_outlined,
                color: Colors.white38,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom selector thumbnail — white card, primary-green border when active.
class _SelectorThumb extends StatelessWidget {
  const _SelectorThumb({
    required this.url,
    required this.selected,
    required this.onTap,
  });
  final String url;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? colors.primary : colors.border,
            width: selected ? 2.5 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                color: Colors.grey.shade200,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Colors.grey.shade400,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
