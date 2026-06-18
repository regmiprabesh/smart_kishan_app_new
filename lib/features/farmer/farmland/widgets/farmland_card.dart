import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_card_menu.dart';
import 'package:smart_kishan/core/widgets/app_network_image.dart';
import 'package:smart_kishan/features/auth/session/session_cubit.dart';
import 'package:smart_kishan/features/auth/session/session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/farmland.dart';

/// Faithful recreation of the original farmland card: a horizontal list-tile
/// layout — 80×80 thumbnail on the left, content (title, description, added-by,
/// info chips) on the right, ⋮ menu for edit/delete. Clean and compact.
class FarmlandCard extends StatelessWidget {
  const FarmlandCard({
    super.key,
    required this.farmland,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Farmland farmland;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String? _addressOrAddedBy(
    BuildContext context,
    AppLocalizations l10n,
    bool isParent,
  ) {
    final hasAddress = farmland.address != null && farmland.address!.isNotEmpty;
    final hasAddedBy = isParent && farmland.user?.name != null;
    return (hasAddress || hasAddedBy) ? 'show' : null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;

    // Added-by visibility (parent accounts only).
    final session = context.read<SessionCubit>().state;
    final me = session is Authenticated ? session.user : null;
    final isParent = me?.parentId == null || me?.parentId == 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Left: 80×80 thumbnail ──
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colors.border.withValues(alpha: 0.7),
                  ),
                ),
                child: AppNetworkImage(
                  url: farmland.image,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(12),
                  fallbackIcon: Icons.landscape_rounded,
                ),
              ),
              const SizedBox(width: 12),
              // ── Right: content (UNCHANGED — same title/desc/address/added-by) ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row + ⋮ menu
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            farmland.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                        // Compact menu, aligned to the title.
                        SizedBox(
                          height: 20,
                          width: 28,
                          child: AppCardMenu(
                            actions: [
                              AppCardMenuAction(
                                icon: Icons.edit_rounded,
                                label: l10n.commonEdit,
                                onTap: onEdit,
                              ),
                              AppCardMenuAction(
                                icon: Icons.delete_rounded,
                                label: l10n.commonDelete,
                                destructive: true,
                                onTap: onDelete,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Description
                    if (farmland.description != null &&
                        farmland.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        farmland.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],

                    // Address + added-by on ONE line
                    if (_addressOrAddedBy(context, l10n, isParent) != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          // Address (truncated) — flexible, takes available space
                          if (farmland.address != null &&
                              farmland.address!.isNotEmpty) ...[
                            Icon(
                              Icons.location_on,
                              size: 12,
                              color: colors.info,
                            ),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                farmland.address!,
                                maxLines: 1,
                                overflow: TextOverflow
                                    .ellipsis, // ← cuts off long addresses
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                          // Separator between address and added-by (only if both present)
                          if (farmland.address != null &&
                              farmland.address!.isNotEmpty &&
                              isParent &&
                              farmland.user?.name != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                color: colors.textHint,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          // Added-by (parent only)
                          if (isParent && farmland.user?.name != null) ...[
                            Icon(
                              Icons.person_outline,
                              size: 12,
                              color: colors.primary,
                            ),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                farmland.user!.name!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
