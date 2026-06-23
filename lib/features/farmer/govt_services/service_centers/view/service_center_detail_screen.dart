import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/di/injector.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/shared/ratings/cubit/ratings_cubit.dart';
import 'package:smart_kishan/shared/ratings/cubit/ratings_state.dart';
import 'package:smart_kishan/shared/ratings/ratings_config.dart';
import 'package:smart_kishan/shared/ratings/widgets/ratings_section.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';

import '../cubit/service_center_detail_cubit.dart';
import '../cubit/service_center_detail_state.dart';
import '../data/service_center.dart';
import 'service_center_detail_args.dart';
import '../data/service_center_ratings_repository.dart';
import '../data/service_center_repository.dart';
import '../widgets/service_center_contact_info.dart';
import '../widgets/service_center_hero.dart';
import '../widgets/service_center_info_card.dart';
import '../widgets/service_center_location_card.dart';
import '../widgets/service_center_services.dart';
import '../widgets/service_center_detail_skeleton.dart';

/// Service-center detail. Hero header, a compact info card (distance / ward /
/// hours), contact rows, location, services, and the shared ratings & reviews
/// section (rate page + sortable reviews page) — the same module subsidies use.
class ServiceCenterDetailScreen extends StatelessWidget {
  const ServiceCenterDetailScreen({super.key, required this.args});

  final ServiceCenterDetailArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppAppBar(title: l10n.details),
      body: BlocBuilder<ServiceCenterDetailCubit, ServiceCenterDetailState>(
        builder: (context, state) {
          return switch (state) {
            ServiceCenterDetailLoading() => const Center(
              child: ServiceCenterDetailSkeleton(),
            ),
            ServiceCenterDetailFailure() => Center(
              child: Text(
                l10n.serviceCenterNotFound,
                style: TextStyle(color: colors.textSecondary),
              ),
            ),
            // Ratings are seeded from the loaded center (embedded in the detail),
            // so the section needs no fetch on open — only on rate/delete.
            ServiceCenterDetailLoaded(:final center) => BlocProvider(
              create: (_) => RatingsCubit(
                ServiceCenterRatingsRepository(
                  sl<ServiceCenterRepository>(),
                  center.id,
                ),
                seedAverage: center.averageRating ?? 0,
                seedTotal: center.totalRatings ?? 0,
                seedReviews: (center.ratings ?? const [])
                    .map(ServiceCenterRatingsRepository.toReview)
                    .toList(),
                seedMyReview: center.userRating == null
                    ? null
                    : ServiceCenterRatingsRepository.toReview(
                        center.userRating!,
                      ),
              ),
              child: BlocListener<RatingsCubit, RatingsState>(
                listenWhen: (p, c) =>
                    p.average != c.average || p.total != c.total,
                listener: (_, s) => args.onRated?.call(s.average, s.total),
                child: _Body(center: center),
              ),
            ),
          };
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final images = center.images;
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        ServiceCenterHero(center: center),
        ServiceCenterInfoCard(center: center),
        ServiceCenterContactInfo(center: center),
        ServiceCenterLocationCard(center: center),
        if (center.services != null && center.services!.isNotEmpty)
          ServiceCenterServices(center: center),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: RatingsSection(
            config: RatingsConfig(
              targetType: l10n.homeServiceCentersBadge,
              rateTitle: AppLocalizations.of(context)!.rateServiceCenter,
              title: center.name?.of(context),
              description: center.address?.of(context),
              imageUrl: (images != null && images.isNotEmpty)
                  ? images.first
                  : null,
              fallbackIcon: Icons.storefront_outlined,
              suggestedTags: [
                l10n.serviceCenterTagHelpfulStaff,
                l10n.serviceCenterTagKnowledgeable,
                l10n.serviceCenterTagFairPrices,
                l10n.serviceCenterTagWellStocked,
                l10n.serviceCenterTagLongWait,
                l10n.serviceCenterTagLimitedStock,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
