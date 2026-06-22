import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';

/// A picked file: its local path + whether it's an image (vs document).
class PickedMedia {
  const PickedMedia({required this.path, required this.isImage, this.name});
  final String path;
  final bool isImage;
  final String? name;
}

/// Which sources to offer in the picker sheet.
enum MediaSource { camera, gallery, files }

/// Reusable media picker. Shows a bottom sheet (Camera / Gallery / Files) and
/// returns a [PickedMedia]. Reused by farmland, products, profile, etc.
///
/// - For image-only contexts (profile, farmland), pass allowImagesOnly: true →
///   Files is restricted to image extensions.
/// - For doc contexts, pass allowedExtensions (e.g. ['pdf','doc','docx','jpg']).
class AppMediaPicker {
  static final ImagePicker _imagePicker = ImagePicker();

  /// Opens the source sheet and returns the chosen media (or null if cancelled).
  static Future<PickedMedia?> pick(
    BuildContext context, {
    Set<MediaSource> sources = const {
      MediaSource.camera,
      MediaSource.gallery,
      MediaSource.files,
    },
    bool allowImagesOnly = true,
    List<String>? allowedExtensions, // for Files (e.g. ['pdf','jpg'])
  }) async {
    await Future<void>.delayed(Duration.zero);
    if (!context.mounted) return null;

    final source = await showModalBottomSheet<MediaSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SourceSheet(sources: sources),
    );
    if (source == null || !context.mounted) return null;

    switch (source) {
      case MediaSource.camera:
        final x = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
          maxWidth: 1600,
        );
        return x == null
            ? null
            : PickedMedia(path: x.path, isImage: true, name: x.name);

      case MediaSource.gallery:
        final x = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
          maxWidth: 1600,
        );
        return x == null
            ? null
            : PickedMedia(path: x.path, isImage: true, name: x.name);

      case MediaSource.files:
        try {
          final result = await FilePicker.platform.pickFiles(
            type: allowedExtensions != null ? FileType.custom : FileType.image,
            allowedExtensions: allowedExtensions,
          );
          if (result == null || result.files.single.path == null) return null;
          final f = result.files.single;
          final ext = (f.extension ?? '').toLowerCase();
          final isImage = ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
          return PickedMedia(path: f.path!, isImage: isImage, name: f.name);
        } catch (e, st) {
          debugPrint(
            'FilePicker error: $e\n$st',
          ); // ← now you'll SEE the failure
          return null;
        }
    }
  }
}

class _SourceSheet extends StatelessWidget {
  const _SourceSheet({required this.sources});
  final Set<MediaSource> sources;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.mediaPickerTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ),
            if (sources.contains(MediaSource.camera))
              _SourceTile(
                icon: HugeIcons.strokeRoundedCamera01,
                label: l10n.mediaPickerCamera,
                onTap: () => Navigator.pop(context, MediaSource.camera),
              ),
            if (sources.contains(MediaSource.gallery))
              _SourceTile(
                icon: HugeIcons.strokeRoundedAlbum01,
                label: l10n.mediaPickerGallery,
                onTap: () => Navigator.pop(context, MediaSource.gallery),
              ),
            if (sources.contains(MediaSource.files))
              _SourceTile(
                icon: HugeIcons.strokeRoundedFolder01,
                label: l10n.mediaPickerFiles,
                onTap: () => Navigator.pop(context, MediaSource.files),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: HugeIcon(icon: icon, color: colors.primary, size: 22),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: colors.iconSecondary),
    );
  }
}
