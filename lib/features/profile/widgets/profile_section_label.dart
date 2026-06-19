import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

/// Small uppercase section header used between profile menu groups.
class ProfileSectionLabel extends StatelessWidget {
  const ProfileSectionLabel({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: (colors.textSecondary).withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
