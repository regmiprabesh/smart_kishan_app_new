import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/launcher.dart';
import 'package:smart_kishan/core/widgets/app_image_preview.dart';
import 'package:smart_kishan/core/widgets/app_pdf_preview.dart';
import '../data/subsidy_document.dart';

/// A document the farmer must upload when applying. Read-only here — just shows
/// name, description, a required/optional badge, max size and accepted formats.
class RequiredDocumentTile extends StatelessWidget {
  const RequiredDocumentTile({super.key, required this.doc});
  final RequiredDocument doc;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final formats = doc.acceptedFormats.join(', ').toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined, size: 20, color: colors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  doc.name?.get(lang) ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: doc.isRequired
                      ? colors.error.withValues(alpha: 0.12)
                      : colors.info.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  doc.isRequired
                      ? l10n.subsidyDocRequired
                      : l10n.subsidyDocOptional,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: doc.isRequired ? colors.error : colors.info,
                    height: 1.0,
                  ),
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                ),
              ),
            ],
          ),
          if (doc.description?.get(lang).isNotEmpty == true) ...[
            const SizedBox(height: 6),
            Text(
              doc.description!.get(lang),
              style: TextStyle(fontSize: 13, color: colors.textSecondary),
            ),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (formats.isNotEmpty)
                _chip(context, Icons.attach_file, formats, colors.info),
              _chip(
                context,
                Icons.sd_storage_outlined,
                '${doc.maxFileSize} MB',
                colors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, IconData icon, String label, Color color) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// An admin-uploaded reference document — tappable to open externally.
class AdminDocumentTile extends StatelessWidget {
  const AdminDocumentTile({super.key, required this.doc});
  final SubsidyDocument doc;

  void _open(BuildContext context, String url) {
    if (doc.isImage) {
      AppImagePreview.open(context, imageUrls: [url]);
    } else if (doc.isPdf) {
      AppPdfPreview.open(context, url, title: doc.fileName);
    } else {
      launchExternal(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = doc.isPdf
        ? Icons.picture_as_pdf_outlined
        : doc.isImage
        ? Icons.image_outlined
        : Icons.insert_drive_file_outlined;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Icon(icon, color: colors.primary),
        title: Text(
          doc.fileName ?? '',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors.textPrimary,
          ),
        ),
        subtitle: doc.fileType != null
            ? Text(
                doc.fileType!.toUpperCase(),
                style: TextStyle(fontSize: 12, color: colors.textSecondary),
              )
            : null,
        trailing: Icon(
          Icons.open_in_new,
          size: 18,
          color: colors.iconSecondary,
        ),
        onTap: doc.filePath == null || doc.filePath!.isEmpty
            ? null
            : () => _open(context, doc.filePath!),
      ),
    );
  }
}
