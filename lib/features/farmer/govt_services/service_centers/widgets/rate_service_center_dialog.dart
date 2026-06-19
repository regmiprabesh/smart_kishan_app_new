import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_outlined_button.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';

import '../data/service_center.dart';
import 'star_rating.dart';

/// Result of the rate dialog: the chosen star count + optional review text.
class RateDialogResult {
  const RateDialogResult({required this.rating, this.review});
  final int rating;
  final String? review;
}

/// Modal for adding or editing a rating. Pre-fills from [existing] when editing.
/// Returns a [RateDialogResult] on submit, or null on cancel.
class RateServiceCenterDialog extends StatefulWidget {
  const RateServiceCenterDialog({super.key, this.existing});

  final ServiceCenterRating? existing;

  static Future<RateDialogResult?> show(
    BuildContext context, {
    ServiceCenterRating? existing,
  }) {
    return showDialog<RateDialogResult>(
      context: context,
      builder: (_) => RateServiceCenterDialog(existing: existing),
    );
  }

  @override
  State<RateServiceCenterDialog> createState() =>
      _RateServiceCenterDialogState();
}

class _RateServiceCenterDialogState extends State<RateServiceCenterDialog> {
  late int _rating = widget.existing?.rating ?? 0;
  late final _reviewController = TextEditingController(
    text: widget.existing?.review ?? '',
  );

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  static const _labels = ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final editing = widget.existing != null;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.rating.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.star_rounded,
                    color: colors.rating,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    editing ? l10n.editYourRating : l10n.rateServiceCenter,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Big stars + live label
            Center(
              child: Column(
                children: [
                  StarRating(
                    rating: _rating,
                    size: 40,
                    onChanged: (v) => setState(() => _rating = v),
                  ),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: Text(
                      _rating == 0 ? ' ' : _labels[_rating],
                      key: ValueKey(_rating),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.rating,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Review field
            Text(
              l10n.writeReviewOptional,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: l10n.shareYourExperienceHint,
                counterText: '',
                filled: true,
                fillColor: colors.surfaceAlt,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Actions
            Row(
              children: [
                Expanded(
                  child: AppOutlinedButton(
                    label: l10n.commonCancel,
                    height: 46,
                    fontSize: 15,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppPrimaryButton(
                    label: l10n.submit,
                    height: 46,
                    fontSize: 15,
                    onPressed: _rating == 0
                        ? null
                        : () => Navigator.pop(
                            context,
                            RateDialogResult(
                              rating: _rating,
                              review: _reviewController.text.trim().isEmpty
                                  ? null
                                  : _reviewController.text.trim(),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
