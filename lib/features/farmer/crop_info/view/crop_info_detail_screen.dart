import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/widgets/app_detail_hero.dart';
import 'package:smart_kishan/core/widgets/app_glass_back_button.dart';
import '../data/crop_info.dart';

/// Crop detail: full-bleed hero image (tap → preview), name + description, then
/// the cultivation activities as expandable sections. Frosted back button.
class CropInfoDetailScreen extends StatelessWidget {
  const CropInfoDetailScreen({super.key, required this.crop});
  final CropInfo crop;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transparent crop artwork → BoxFit.contain.
                AppDetailHero(
                  imageUrl: crop.image,
                  fallbackIcon: Icons.eco_rounded,
                  fit: BoxFit.contain,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crop.name?.of(context) ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                      if (crop.description?.of(context) != null &&
                          crop.description!.of(context).isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          crop.description!.of(context),
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],

                      // Cultivation activities
                      if (crop.activities.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        _ActivitiesCard(activities: crop.activities),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Frosted back button
          Positioned(
            top: topInset + 8,
            left: 12,
            child: AppGlassBackButton(onTap: () => context.pop()),
          ),
        ],
      ),
    );
  }
}

/// Activities as expandable sections (first two open by default, like original).
class _ActivitiesCard extends StatelessWidget {
  const _ActivitiesCard({required this.activities});
  final List<CropActivity> activities;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: colors.divider),
        child: Column(
          children: [
            for (var i = 0; i < activities.length; i++)
              ExpansionTile(
                initiallyExpanded: i == 0 || i == 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: i == 0 ? const Radius.circular(16) : Radius.zero,
                    bottom: i == activities.length - 1
                        ? const Radius.circular(16)
                        : Radius.zero,
                  ),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: i == 0 ? const Radius.circular(16) : Radius.zero,
                    bottom: i == activities.length - 1
                        ? const Radius.circular(16)
                        : Radius.zero,
                  ),
                ),
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedAlignment: Alignment.centerLeft,
                title: Text(
                  activities[i].title?.of(context) ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      activities[i].description?.of(context) ?? '',
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.6,
                        color: colors.textSecondary,
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
