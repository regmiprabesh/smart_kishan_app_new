import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';

/// One action in an AppCardMenu.
class AppCardMenuAction {
  const AppCardMenuAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive; // renders in error color (e.g. delete)
}

/// A ⋮ overflow menu for list cards (Edit / Delete / …). Visible, uncluttered,
/// and scales to more actions. Reused across list screens. Stops tap from
/// bubbling to the card's onTap.
class AppCardMenu extends StatelessWidget {
  const AppCardMenu({super.key, required this.actions});
  final List<AppCardMenuAction> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, color: colors.iconSecondary),
      tooltip: '',
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: colors.surface,
      onSelected: (i) => actions[i].onTap(),
      itemBuilder: (context) => [
        for (var i = 0; i < actions.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: Row(
              children: [
                Icon(
                  actions[i].icon,
                  size: 20,
                  color: actions[i].destructive
                      ? colors.error
                      : colors.iconPrimary,
                ),
                const SizedBox(width: 12),
                Text(
                  actions[i].label,
                  style: TextStyle(
                    color: actions[i].destructive
                        ? colors.error
                        : colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
