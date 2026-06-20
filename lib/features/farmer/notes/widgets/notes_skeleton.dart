import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/widgets/app_shimmer.dart';

/// Full-screen loading placeholder for the notes list — shimmering cards that
/// mirror the real note card (accent bar + title + actions, description lines,
/// date footer).
class NotesListSkeleton extends StatelessWidget {
  const NotesListSkeleton({super.key, this.count = 4});
  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      itemBuilder: (_, _) => const _NoteCardSkeleton(),
    );
  }
}

class _NoteCardSkeleton extends StatelessWidget {
  const _NoteCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row: accent bar + title + two action chips
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: AppShimmer.box(height: 14, radius: 6)),
                const SizedBox(width: 12),
                AppShimmer.box(width: 28, height: 28, radius: 8),
                const SizedBox(width: 8),
                AppShimmer.box(width: 28, height: 28, radius: 8),
              ],
            ),
            const SizedBox(height: 14),
            // Description lines
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmer.box(height: 11, radius: 6),
                  const SizedBox(height: 8),
                  AppShimmer.box(width: 220, height: 11, radius: 6),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Date footer
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: AppShimmer.box(width: 90, height: 11, radius: 6),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact loading placeholder for the dashboard notes section. Renders INSIDE
/// the section's existing card (replaces the spinner) — two shimmering preview
/// rows matching the real preview list.
class NotesSectionSkeleton extends StatelessWidget {
  const NotesSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _PreviewRowSkeleton(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(color: colors.divider, height: 1),
        ),
        const _PreviewRowSkeleton(),
      ],
    );
  }
}

class _PreviewRowSkeleton extends StatelessWidget {
  const _PreviewRowSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppShimmer.box(width: 160, height: 13, radius: 6),
              const SizedBox(height: 6),
              AppShimmer.box(height: 11, radius: 6),
            ],
          ),
        ),
      ],
    );
  }
}
