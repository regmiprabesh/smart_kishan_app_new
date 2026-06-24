import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';

import '../cubit/ratings_cubit.dart';
import '../ratings_config.dart';
import '../data/review_sort.dart';
import '../widgets/rating_summary_header.dart';
import '../widgets/ratings_entity_header.dart';
import '../widgets/review_tile.dart';

/// Full, sortable list of every review for an entity. Reusable across features
/// — driven by the shared [RatingsCubit] passed down from the detail screen.
/// Fetches the full list fresh on open (the detail only carries a capped
/// preview).
class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key, required this.config});

  final RatingsConfig config;

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch the full list only if it hasn't been loaded already. The subsidy
    // detail loads on open (so this is a no-op there); the service-center
    // detail only seeds a preview, so this pulls the full list fresh.
    final cubit = context.read<RatingsCubit>();
    if (!cubit.state.loaded) cubit.load();
  }

  String _sortLabel(AppLocalizations l10n, ReviewSort s) => switch (s) {
    ReviewSort.newest => l10n.ratingSortNewest,
    ReviewSort.oldest => l10n.ratingSortOldest,
    ReviewSort.highest => l10n.ratingSortHighest,
    ReviewSort.lowest => l10n.ratingSortLowest,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final cubit = context.watch<RatingsCubit>();
    final state = cubit.state;

    return Scaffold(
      appBar: AppAppBar(
        title: l10n.ratingReviewsTitle,
        actions: [
          PopupMenuButton<ReviewSort>(
            icon: const Icon(Icons.sort),
            tooltip: l10n.ratingSortBy,
            initialValue: state.sort,
            onSelected: cubit.setSort,
            itemBuilder: (_) => [
              for (final s in ReviewSort.values)
                PopupMenuItem(value: s, child: Text(_sortLabel(l10n, s))),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RatingsEntityHeader(config: widget.config),
          const SizedBox(height: 12),
          if (state.loading && state.reviews.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.reviews.isEmpty)
            AppEmptyState(
              icon: Icons.reviews_outlined,
              title: l10n.subsidyNoRatingsYet,
              compact: true,
            )
          else ...[
            RatingSummaryHeader(average: state.average, total: state.total),
            const SizedBox(height: 8),
            for (var i = 0; i < state.reviews.length; i++) ...[
              ReviewTile(review: state.reviews[i]),
              if (i != state.reviews.length - 1)
                Divider(height: 1, color: colors.divider),
            ],
          ],
        ],
      ),
    );
  }
}
