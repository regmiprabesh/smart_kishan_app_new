import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_network_image.dart';
import 'package:smart_kishan/core/widgets/app_image_preview.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/features/farmer/farmland/data/recommended_crops.dart';
import '../cubit/farmland_cubit.dart';
import '../cubit/farmland_state.dart';
import '../data/farmland.dart';
import 'farmland_args.dart';

/// Farmland detail page. Reads the CURRENT farmland from the cubit by id (via
/// BlocBuilder) rather than a static snapshot, so edits made on the add/edit
/// screen reflect immediately when you return here.
class FarmlandDetailScreen extends StatelessWidget {
  const FarmlandDetailScreen({
    super.key,
    required this.farmlandId,
    required this.cubit,
  });

  final int farmlandId;
  final FarmlandCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<FarmlandCubit, FarmlandState>(
        builder: (context, state) {
          final farmland = state is FarmlandLoaded
              ? state.farmlands.where((f) => f.id == farmlandId).firstOrNull
              : null;

          // Deleted (or not loaded) → pop back to the list.
          if (farmland == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted && context.canPop()) context.pop();
            });
            return const Scaffold(body: SizedBox.shrink());
          }

          return _DetailBody(farmland: farmland, cubit: cubit);
        },
      ),
    );
  }
}

/// The actual detail UI, given a (fresh) farmland.
class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.farmland, required this.cubit});
  final Farmland farmland;
  final FarmlandCubit cubit;

  bool get _hasImage => farmland.image != null && farmland.image!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      // No appBar — the image fills the top, behind the status bar.
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero image — full-bleed, extends under the status bar.
                GestureDetector(
                  onTap: _hasImage
                      ? () => AppImagePreview.open(
                          context,
                          imageUrls: [farmland.image!],
                        )
                      : null,
                  child: SizedBox(
                    height: 280,
                    width: double.infinity,
                    child: _hasImage
                        ? AppNetworkImage(
                            url: farmland.image,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: colors.surfaceAlt,
                            child: Center(
                              child: Icon(
                                Icons.landscape_rounded,
                                size: 56,
                                color: colors.primary.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                  ),
                ),

                // Details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farmland.title ?? '',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                      if (farmland.description != null &&
                          farmland.description!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          farmland.description!,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      if (farmland.lat != null && farmland.lng != null)
                        _InfoCard(
                          icon: Icons.location_on_rounded,
                          title: l10n.farmlandLocationSection,
                          rows: [
                            if (farmland.address != null &&
                                farmland.address!.isNotEmpty)
                              (l10n.farmlandAddressLabel, farmland.address!),
                            (
                              l10n.farmlandLatLabel,
                              context.ld(farmland.lat!.toStringAsFixed(6)),
                            ),
                            (
                              l10n.farmlandLngLabel,
                              context.ld(farmland.lng!.toStringAsFixed(6)),
                            ),
                          ],
                        ),
                      if (farmland.lat != null &&
                          farmland.lng != null &&
                          farmland.recommendedCrops != null &&
                          !farmland.recommendedCrops!.isEmpty) ...[
                        const SizedBox(height: 12),
                        _RecommendedCropsCard(
                          crops: farmland.recommendedCrops!,
                        ),
                      ],

                      if (_hasSoil(farmland)) ...[
                        const SizedBox(height: 12),
                        _InfoCard(
                          icon: Icons.grass_rounded,
                          title: l10n.farmlandSoilSection,
                          rows: [
                            if (farmland.nitrogen != null)
                              (
                                l10n.farmlandNitrogen,
                                context.ld(farmland.nitrogen!.toString()),
                              ),
                            if (farmland.organicMatter != null)
                              (
                                l10n.farmlandOrganicMatter,
                                context.ld(farmland.organicMatter!.toString()),
                              ),
                            if (farmland.phosphate != null)
                              (
                                l10n.farmlandPhosphate,
                                context.ld(farmland.phosphate!.toString()),
                              ),
                            if (farmland.potassium != null)
                              (
                                l10n.farmlandPotassium,
                                context.ld(farmland.potassium!.toString()),
                              ),
                            if (farmland.pH != null)
                              (
                                l10n.farmlandPH,
                                context.ld(farmland.pH!.toString()),
                              ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 24),
                      AppPrimaryButton(
                        label: l10n.farmlandUpdate,
                        onPressed: () => context.push(
                          AppRoutePath.addFarmland,
                          extra: FarmlandArgs(cubit: cubit, farmland: farmland),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating frosted-glass back button (over the image)
          Positioned(
            top: topInset + 8,
            left: 12,
            child: _GlassBackButton(onTap: () => context.pop()),
          ),
        ],
      ),
    );
  }

  bool _hasSoil(Farmland f) =>
      f.nitrogen != null ||
      f.phosphate != null ||
      f.potassium != null ||
      f.pH != null ||
      f.organicMatter != null;
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.rows,
  });
  final IconData icon;
  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: colors.primary),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...rows.map(
            (r) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    r.$1,
                    style: TextStyle(fontSize: 13, color: colors.textSecondary),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      r.$2,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
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

class _GlassBackButton extends StatelessWidget {
  const _GlassBackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.black.withValues(alpha: 0.28),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(CupertinoIcons.back, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecommendedCropsCard extends StatelessWidget {
  const _RecommendedCropsCard({required this.crops});
  final RecommendedCrops crops;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.agriculture_rounded,
                  size: 18,
                  color: colors.success,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                l10n.farmlandRecommendedCrops,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (crops.vegetables.isNotEmpty) ...[
            _CropGroup(
              label: l10n.farmlandRecommendedVegetables,
              crops: crops.vegetables,
              color: colors.success,
            ),
            if (crops.fruits.isNotEmpty) const SizedBox(height: 16),
          ],

          if (crops.fruits.isNotEmpty)
            _CropGroup(
              label: l10n.farmlandRecommendedFruits,
              crops: crops.fruits,
              color: colors.warning,
            ),
        ],
      ),
    );
  }
}

/// A labeled group (Vegetables / Fruits) listing crop names as a simple list.
class _CropGroup extends StatelessWidget {
  const _CropGroup({
    required this.label,
    required this.crops,
    required this.color,
  });
  final String label;
  final List<RecommendedCrop> crops;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        ...crops.map(
          (c) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    c.name?.of(context) ?? '',
                    style: TextStyle(fontSize: 14, color: colors.textPrimary),
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
