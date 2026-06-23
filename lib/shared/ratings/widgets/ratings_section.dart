import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/widgets/app_confirm_dialog.dart';
import 'package:smart_kishan/core/widgets/app_outlined_button.dart';
import 'package:smart_kishan/shared/ratings/widgets/rating_section_card.dart';

import '../cubit/ratings_cubit.dart';
import '../cubit/ratings_state.dart';
import '../ratings_config.dart';
import '../ratings_repository.dart';
import '../review.dart';
import '../view/rate_page.dart';
import '../view/reviews_page.dart';
import 'rating_summary_header.dart';
import 'review_tile.dart';
import 'star_rating.dart';

/// Inline ratings block for any detail screen: aggregate header, the user's own
/// rating (add / edit / delete), and up to five recent reviews with a "see all"
/// link to the full [ReviewsPage]. Rating opens the full-page [RatePage].
///
/// Expects a [RatingsCubit] provided above it; pass the feature's [config].
class RatingsSection extends StatelessWidget {
  const RatingsSection({super.key, required this.config, this.maxInline = 5});

  final RatingsConfig config;
  final int maxInline;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final state = context.watch<RatingsCubit>().state;
    final shown = state.reviews.take(maxInline).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 24,
              width: 4,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.ratingsAndReviews,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ),
            if (state.loading)
              const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: 12),
        RatingSummaryHeader(average: state.average, total: state.total),
        const SizedBox(height: 16),
        _yourRating(context, l10n, state),
        if (shown.isNotEmpty) ...[
          const SizedBox(height: 16),
          _recentReviews(context, l10n, state, shown),
        ],
      ],
    );
  }

  Widget _yourRating(
    BuildContext context,
    AppLocalizations l10n,
    RatingsState state,
  ) {
    final colors = context.colors;
    final mine = state.myReview;

    return RatingsSectionCard(
      title: l10n.yourRating,
      trailing: mine == null
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _IconChip(
                  icon: Icons.edit_outlined,
                  color: colors.primary,
                  onTap: () => _openRate(context, mine),
                ),
                const SizedBox(width: 8),
                _IconChip(
                  icon: Icons.delete_outline,
                  color: colors.error,
                  onTap: () => _confirmDelete(context),
                ),
              ],
            ),
      child: mine == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.helpOthersRate(config.targetType),
                  style: TextStyle(color: colors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 12),
                AppOutlinedButton(
                  label: l10n.addYourRating,
                  icon: Icons.star_outline,
                  height: 46,
                  fontSize: 15,
                  iconSize: 20,
                  isLoading: state.submitting,
                  onPressed: () => _openRate(context, null),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StarRating(rating: mine.rating, size: 22),
                if (mine.text?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 12),
                  Text(
                    mine.text!,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _recentReviews(
    BuildContext context,
    AppLocalizations l10n,
    RatingsState state,
    List<Review> shown,
  ) {
    return RatingsSectionCard(
      title: l10n.recentReviews,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        children: [
          for (var i = 0; i < shown.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ReviewTile(review: shown[i]),
            ),
            if (i != shown.length - 1)
              Divider(height: 1, color: context.colors.divider),
          ],
          if (state.total > shown.length ||
              state.reviews.length > shown.length) ...[
            Divider(height: 1, color: context.colors.divider),
            TextButton(
              onPressed: () => _openReviews(context),
              child: Text(l10n.ratingSeeAllReviews),
            ),
          ],
        ],
      ),
    );
  }

  void _openRate(BuildContext context, Review? existing) {
    final cubit = context.read<RatingsCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: RatePage(config: config, existing: existing),
        ),
      ),
    );
  }

  void _openReviews(BuildContext context) {
    final cubit = context.read<RatingsCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: ReviewsPage(config: config),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final cubit = context.read<RatingsCubit>();
    final l10n = AppLocalizations.of(context)!;
    final ok = await AppConfirmDialog.delete(
      context,
      title: l10n.deleteRatingQuestion,
      message: l10n.deleteRatingReviewConfirm,
    );
    if (!ok) return;
    final outcome = await cubit.delete();
    if (outcome == RatingMutationResult.deleted) {
      AppSnackbar.success(l10n.ratingDeletedSuccess);
    } else {
      AppSnackbar.error(l10n.errorGeneric);
    }
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
