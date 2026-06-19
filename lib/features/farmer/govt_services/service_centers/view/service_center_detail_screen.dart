import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';

import '../cubit/service_center_detail_cubit.dart';
import '../cubit/service_center_detail_state.dart';
import '../data/service_center.dart';
import '../widgets/service_center_contact_info.dart';
import '../widgets/service_center_hero.dart';
import '../widgets/service_center_info_card.dart';
import '../widgets/service_center_location_card.dart';
import '../widgets/service_center_rating_overview.dart';
import '../widgets/service_center_recent_reviews.dart';
import '../widgets/service_center_services.dart';
import '../widgets/service_center_your_rating.dart';
import 'service_center_detail_skeleton.dart';

/// Service-center detail. Hero header (image-as-banner with the name/type
/// overlaid, or a tinted placeholder when no image), a compact info card
/// (distance / ward / hours), contact rows, rating overview + your-rating, and
/// recent reviews. Reads its center live from the cubit so rate/delete updates
/// reflect immediately.
class ServiceCenterDetailScreen extends StatelessWidget {
  const ServiceCenterDetailScreen({super.key});

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
            ServiceCenterDetailLoaded(:final center) => _Body(center: center),
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
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        ServiceCenterHero(center: center),
        ServiceCenterInfoCard(center: center),
        if (center.hasRatings) ServiceCenterRatingOverview(center: center),
        ServiceCenterContactInfo(center: center),
        ServiceCenterLocationCard(center: center),
        if (center.services != null && center.services!.isNotEmpty)
          ServiceCenterServices(center: center),
        ServiceCenterYourRating(center: center),
        if (center.ratings != null && center.ratings!.isNotEmpty)
          ServiceCenterRecentReviews(center: center),
      ],
    );
  }
}
