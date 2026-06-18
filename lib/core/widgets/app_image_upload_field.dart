import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_image_preview.dart';
import 'package:smart_kishan/core/widgets/app_network_image.dart';

/// Polished image upload field. Uses a fixed ASPECT RATIO (default 16:10) with
/// BoxFit.cover, so portrait OR landscape photos both fill the frame neatly
/// instead of stretching the layout. Tap image → preview; camera badge → change.
/// Optional [uploadProgress] (0..1) shows a % overlay.
class AppImageUploadField extends StatelessWidget {
  const AppImageUploadField({
    super.key,
    required this.onPickRequested,
    this.pickedPath,
    this.networkUrl,
    this.uploadProgress,
    this.aspectRatio = 16 / 10,
    this.onRemove,
  });

  final String? pickedPath;
  final String? networkUrl;
  final double? uploadProgress;
  final VoidCallback onPickRequested;
  final double aspectRatio;
  final VoidCallback? onRemove;

  bool get _hasImage =>
      (pickedPath != null) || (networkUrl != null && networkUrl!.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;

    if (!_hasImage) {
      return AspectRatio(
        aspectRatio: aspectRatio,
        child: GestureDetector(
          onTap: onPickRequested,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colors.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_a_photo_outlined,
                    size: 26,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.imageUploadAdd,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (pickedPath == null && networkUrl != null) {
                AppImagePreview.open(context, imageUrls: [networkUrl!]);
              } else {
                onPickRequested();
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: pickedPath != null
                    ? Image.file(File(pickedPath!), fit: BoxFit.cover)
                    : AppNetworkImage(url: networkUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          if (uploadProgress != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.45),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 54,
                          height: 54,
                          child: CircularProgressIndicator(
                            value: uploadProgress,
                            strokeWidth: 4,
                            color: Colors.white,
                            backgroundColor: Colors.white24,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${(uploadProgress! * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (onRemove != null && uploadProgress == null)
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
          if (uploadProgress == null)
            Positioned(
              right: 10,
              bottom: 10,
              child: GestureDetector(
                onTap: onPickRequested,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.photo_camera_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
