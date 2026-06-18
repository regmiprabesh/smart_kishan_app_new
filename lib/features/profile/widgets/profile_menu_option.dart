import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

/// A single row in the profile menu (icon + title + chevron).
class ProfileMenuOption extends StatelessWidget {
  const ProfileMenuOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.destructive = false,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool destructive;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = destructive ? colors.error : colors.textPrimary;

    return ListTile(
      leading: Icon(
        icon,
        color: destructive ? colors.error : colors.iconPrimary,
      ),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      trailing:
          trailing ?? Icon(Icons.chevron_right, color: colors.iconSecondary),
      onTap: onTap,
    );
  }
}
