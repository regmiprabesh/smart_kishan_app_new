import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/widgets/app_shimmer.dart';

/// Shimmer placeholder shown while farmlands load — mirrors the real ROW
/// layout (80×80 thumbnail left, title/desc/meta right) with dividers, so the
/// transition into the loaded list is seamless.
class FarmlandListSkeleton extends StatelessWidget {
  const FarmlandListSkeleton({super.key, this.count = 5});
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: count,
      itemBuilder: (_, __) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Left: 80×80 thumbnail ──
                AppShimmer(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // ── Right: title, description, meta ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      AppShimmer.box(width: 140, height: 15), // title
                      const SizedBox(height: 10),
                      AppShimmer.box(
                        width: double.infinity,
                        height: 12,
                      ), // desc line 1
                      const SizedBox(height: 6),
                      AppShimmer.box(width: 200, height: 12), // desc line 2
                      const SizedBox(height: 10),
                      AppShimmer.box(
                        width: 160,
                        height: 11,
                      ), // address/added-by
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider — matches the real list's between-row dividers
          Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: colors.divider,
          ),
        ],
      ),
    );
  }
}
