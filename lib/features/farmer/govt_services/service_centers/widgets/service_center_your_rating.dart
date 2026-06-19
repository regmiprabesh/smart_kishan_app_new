import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_confirm_dialog.dart';
import 'package:smart_kishan/core/widgets/app_outlined_button.dart';

import '../cubit/service_center_detail_cubit.dart';
import '../data/service_center.dart';
import 'rate_service_center_dialog.dart';
import 'service_center_section_card.dart';
import 'star_rating.dart';

/// The signed-in user's own rating: add button when none, or a summary with
/// edit/delete chips and the review text.
class ServiceCenterYourRating extends StatelessWidget {
  const ServiceCenterYourRating({super.key, required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final mine = center.userRating;

    return ServiceCenterSectionCard(
      title: l10n.yourRating,
      child: mine == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.helpOthersRate,
                  style: TextStyle(color: colors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 12),
                AppOutlinedButton(
                  label: l10n.addYourRating,
                  icon: Icons.star_outline,
                  height: 46,
                  fontSize: 15,
                  iconSize: 20,
                  onPressed: () => _openRateDialog(context, null),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Rating summary
                    StarRating(rating: mine.rating, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      context.ld(mine.rating.toString()),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    // Edit + delete as tinted icon chips
                    _IconChip(
                      icon: Icons.edit_outlined,
                      color: colors.primary,
                      onTap: () => _openRateDialog(context, mine),
                    ),
                    const SizedBox(width: 8),
                    _IconChip(
                      icon: Icons.delete_outline,
                      color: colors.error,
                      onTap: () => _confirmDelete(context),
                    ),
                  ],
                ),
                if (mine.review?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surfaceAlt,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      mine.review!,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Future<void> _openRateDialog(
    BuildContext context,
    ServiceCenterRating? existing,
  ) async {
    final cubit = context.read<ServiceCenterDetailCubit>();
    final l10n = AppLocalizations.of(context)!;
    final result = await RateServiceCenterDialog.show(
      context,
      existing: existing,
    );
    if (result == null || !context.mounted) return;

    final outcome = await cubit.submitRating(
      rating: result.rating,
      review: result.review,
    );
    if (!context.mounted) return;
    switch (outcome) {
      case RatingActionResult.submitted:
        AppSnackbar.success(l10n.ratingSubmittedSuccess);
      case RatingActionResult.updated:
        AppSnackbar.success(l10n.ratingUpdatedSuccess);
      default:
        AppSnackbar.error(l10n.errorGeneric);
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final cubit = context.read<ServiceCenterDetailCubit>();
    final l10n = AppLocalizations.of(context)!;
    final ok = await AppConfirmDialog.delete(
      context,
      title: l10n.deleteRatingQuestion,
      message: l10n.deleteRatingReviewConfirm,
    );
    if (!ok) return;
    await cubit.deleteRating();
    AppSnackbar.success(l10n.ratingDeletedSuccess);
  }
}

class _IconChip extends StatelessWidget {
  const _IconChip({
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.10),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
