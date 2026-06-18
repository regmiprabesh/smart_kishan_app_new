import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/config/map_constants.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/core/widgets/app_outlined_button.dart';
import 'package:smart_kishan/features/farmer/govt_services/service_centers/view/service_center_detail_skeleton.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cubit/service_center_detail_cubit.dart';
import '../cubit/service_center_detail_state.dart';
import '../data/service_center.dart';
import '../widgets/rate_service_center_dialog.dart';
import '../widgets/review_item.dart';
import '../widgets/service_center_type_style.dart';
import '../widgets/star_rating.dart';

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
        _HeroHeader(center: center),
        _InfoCard(center: center),
        if (center.hasRatings) _RatingOverview(center: center),
        _ContactInfo(center: center),
        _LocationCard(center: center),
        if (center.services != null && center.services!.isNotEmpty)
          _Services(center: center),
        _YourRating(center: center),
        if (center.ratings != null && center.ratings!.isNotEmpty)
          _RecentReviews(center: center),
      ],
    );
  }
}

/// Image banner with a dark gradient scrim and the type + name overlaid.
/// Falls back to a tinted type-icon placeholder when there's no image (or it
/// fails to load) — so it works now and when images are added later.
class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typeColor = ServiceCenterTypeStyle.of(center.type);
    final hasImage = center.images != null && center.images!.isNotEmpty;

    return SizedBox(
      height: 210,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image or placeholder
          if (hasImage)
            Image.network(
              center.images!.first,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _placeholder(typeColor),
              loadingBuilder: (context, child, progress) =>
                  progress == null ? child : _placeholder(typeColor),
            )
          else
            _placeholder(typeColor),

          // Gradient scrim so white text stays readable over any image.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
                stops: [0.45, 1.0],
              ),
            ),
          ),

          // Featured pill (top-right)
          if (center.isFeatured)
            Positioned(top: 12, right: 12, child: _FeaturedPill()),

          // Title + type overlaid at the bottom
          Positioned(
            left: 16,
            right: 16,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (center.type?.name != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: typeColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          ServiceCenterTypeStyle.iconOf(center.type),
                          size: 13,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          center.type!.name!.of(context),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  center.name?.of(context) ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 15,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        center.address?.of(context) ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(Color typeColor) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Soft diagonal gradient backdrop
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                typeColor.withValues(alpha: 0.22),
                typeColor.withValues(alpha: 0.06),
              ],
            ),
          ),
        ),

        // Oversized faint icon for texture, tucked into a corner
        Positioned(
          right: -20,
          bottom: -30,
          child: Icon(
            ServiceCenterTypeStyle.iconOf(center.type),
            size: 160,
            color: typeColor.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}

class _FeaturedPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.rating,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 12, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            l10n.featured,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Quiet key facts grouped into ONE card (distance / ward / hours) instead of
/// several thin cards — calmer rhythm.
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    final rows = <Widget>[];
    if (center.distance != null) {
      rows.add(
        _InfoRow(
          icon: Icons.navigation,
          iconColor: colors.info,
          label: l10n.distance,
          value:
              '${context.ld(center.distance!.toStringAsFixed(1))} ${l10n.km} ${l10n.away}',
        ),
      );
    }
    if (center.wardNo != null) {
      rows.add(
        _InfoRow(
          icon: Icons.tag,
          iconColor: colors.textSecondary,
          label: l10n.wardNo(context.ld(center.wardNo.toString())),
          value: '',
        ),
      );
    }
    if (center.operatingHours != null && center.operatingHours!.isNotEmpty) {
      rows.add(_HoursBlock(center: center));
    }

    if (rows.isEmpty) return const SizedBox.shrink();

    return _Card(
      title: l10n.basicInformation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i != rows.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: colors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (value.isNotEmpty)
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: iconColor == colors.textSecondary
                  ? colors.textSecondary
                  : iconColor,
            ),
          ),
      ],
    );
  }
}

class _HoursBlock extends StatelessWidget {
  const _HoursBlock({required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final entries = center.operatingHours!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.schedule, size: 18, color: colors.textSecondary),
            const SizedBox(width: 10),
            Text(
              l10n.operatingHours,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...entries.map(
          (e) => Padding(
            padding: const EdgeInsets.only(left: 28, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  e.label.of(context),
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
                Text(
                  e.hours.of(context),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: e.closed ? FontWeight.w600 : FontWeight.w400,
                    color: e.closed ? colors.error : colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.title,
    required this.child,
    this.padding,
    this.trailing,
  });
  final String title;
  final Widget child;
  final EdgeInsets? padding;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          Padding(
            padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _RatingOverview extends StatelessWidget {
  const _RatingOverview({required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final avg = center.averageRating ?? 0;
    final total = center.totalRatings ?? 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.rating.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.rating.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                context.ld(avg.toStringAsFixed(1)),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: colors.rating,
                ),
              ),
              StarRating(rating: avg.round(), size: 16),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${context.ld(total.toString())} ${total == 1 ? l10n.ratingSingular : l10n.ratingPlural}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.basedOnUserReviews,
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  const _ContactInfo({required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    final rows = <Widget>[];
    if (center.phone != null) {
      rows.add(
        _ContactRow(
          icon: Icons.phone,
          iconColor: colors.success,
          title: context.ld(center.phone!),
          subtitle: l10n.phone,
          trailing: IconButton(
            icon: Icon(Icons.call, color: colors.success, size: 22),
            onPressed: () => _launch('tel:${center.phone}'),
          ),
        ),
      );
    }
    if (center.email != null) {
      rows.add(
        _ContactRow(
          icon: Icons.email_outlined,
          iconColor: colors.warning,
          title: center.email!,
          subtitle: l10n.emailLabel,
          trailing: IconButton(
            icon: Icon(Icons.send_outlined, color: colors.warning),
            onPressed: () => _launch('mailto:${center.email}'),
          ),
        ),
      );
    }
    if (center.website != null) {
      rows.add(
        _ContactRow(
          icon: Icons.language,
          iconColor: colors.info,
          title: center.website!,
          subtitle: l10n.website,
          trailing: IconButton(
            icon: Icon(Icons.open_in_new, color: colors.info),
            onPressed: () => _launch(center.website!),
          ),
        ),
      );
    }
    if (center.contactPerson != null) {
      rows.add(
        _ContactRow(
          icon: Icons.person,
          iconColor: colors.primary,
          title: center.contactPerson?.of(context) ?? '',

          subtitle:
              center.contactPersonDesignation?.of(context) ??
              l10n.contactPerson,
        ),
      );
    }

    if (rows.isEmpty) return const SizedBox.shrink();

    return _Card(
      title: l10n.contactInformation,
      padding: EdgeInsets.zero,
      child: Column(children: rows),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: colors.textSecondary, fontSize: 12),
      ),
      trailing: trailing,
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.center});
  final ServiceCenter center;

  void _openDirections() => _launch(
    'https://www.google.com/maps/dir/?api=1&destination=${center.latitude},${center.longitude}',
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final point = LatLng(center.latitude, center.longitude);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _openDirections,
            child: SizedBox(
              width: double.infinity,
              height: 180,
              child: Stack(
                children: [
                  IgnorePointer(
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: point,
                        initialZoom: MapConstants.selectedZoom,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: MapConstants.tileUrl,
                          userAgentPackageName: MapConstants.userAgent,
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: point,
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.location_pin,
                                color: colors.primary,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Material(
                      color: colors.surface,
                      elevation: 3,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: _openDirections,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.directions,
                                size: 16,
                                color: colors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                l10n.directions,
                                style: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Services extends StatelessWidget {
  const _Services({required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return _Card(
      title: l10n.servicesOffered,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: center.services!.map((s) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              s?.of(context) ?? '',
              style: TextStyle(
                fontSize: 13,
                color: colors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _YourRating extends StatelessWidget {
  const _YourRating({required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final mine = center.userRating;

    return _Card(
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.deleteRatingQuestion),
        content: Text(l10n.deleteRatingReviewConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await cubit.deleteRating();
    AppSnackbar.success(l10n.ratingDeletedSuccess);
  }
}

class _RecentReviews extends StatelessWidget {
  const _RecentReviews({required this.center});
  final ServiceCenter center;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reviews = center.ratings!;
    final shown = reviews.take(5).toList();

    return _Card(
      title: l10n.recentReviews,
      child: Column(
        children: [
          for (var i = 0; i < shown.length; i++) ...[
            ReviewItem(rating: shown[i]),
            if (i != shown.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

Future<void> _launch(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
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
