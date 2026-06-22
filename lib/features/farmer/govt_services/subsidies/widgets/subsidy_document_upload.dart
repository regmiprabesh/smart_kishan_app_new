import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_outlined_button.dart';

import '../data/subsidy_document.dart';

/// Apply-form upload card for one required document. Picking, validation and
/// preview are handled by the screen; this reflects state and exposes actions.
class SubsidyDocumentUpload extends StatelessWidget {
  const SubsidyDocumentUpload({
    super.key,
    required this.doc,
    required this.fileName,
    required this.onPick,
    required this.onRemove,
    required this.onPreview,
    this.showError = false,
  });

  final RequiredDocument doc;
  final String? fileName;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final VoidCallback onPreview;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final hasFile = fileName != null;
    final missing = showError && doc.isRequired && !hasFile;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: missing
              ? colors.error
              : hasFile
              ? colors.success
              : colors.border,
          width: (missing || hasFile) ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: doc.name?.of(context) ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: colors.textPrimary,
                    ),
                    children: [
                      if (doc.isRequired)
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: colors.error),
                        ),
                    ],
                  ),
                ),
              ),
              if (hasFile)
                Icon(Icons.check_circle, color: colors.success, size: 22),
            ],
          ),
          if (doc.description?.of(context).isNotEmpty == true) ...[
            const SizedBox(height: 6),
            Text(
              doc.description!.of(context),
              style: TextStyle(fontSize: 13, color: colors.textSecondary),
            ),
          ],
          const SizedBox(height: 10),
          _chips(context),
          const SizedBox(height: 12),
          if (hasFile) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.successLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: colors.success, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      fileName!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: colors.textPrimary),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: l10n.subsidyPreview,
                    icon: Icon(
                      Icons.visibility_outlined,
                      size: 20,
                      color: colors.primary,
                    ),
                    onPressed: onPreview,
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.close, size: 18, color: colors.error),
                    onPressed: onRemove,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            AppOutlinedButton(
              label: l10n.subsidyChangeFile,
              icon: Icons.cached,
              height: 40,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              onPressed: onPick,
            ),
          ] else ...[
            AppOutlinedButton(
              label: l10n.subsidyUploadFile,
              icon: Icons.upload_file_outlined,
              height: 40,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              onPressed: onPick,
            ),
            if (missing) ...[
              const SizedBox(height: 6),
              Text(
                l10n.subsidyDocumentMissing,
                style: TextStyle(fontSize: 12, color: colors.error),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _chips(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final formats = doc.acceptedFormats.join(', ').toUpperCase();
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        _Chip(
          icon: Icons.attach_file,
          label: formats,
          bg: colors.info.withValues(alpha: 0.12),
          fg: colors.info,
        ),
        _Chip(
          icon: Icons.cloud_upload_outlined,
          label: '${l10n.subsidyMaxSize} ${context.ld(doc.maxFileSize)} MB',
          bg: colors.success.withValues(alpha: 0.12),
          fg: colors.success,
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
  });
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
