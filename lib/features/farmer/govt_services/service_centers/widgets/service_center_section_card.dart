import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

/// Generic titled card used to group a detail section (basic info, contact,
/// services, your rating, reviews) on the service-center detail screen.
class ServiceCenterSectionCard extends StatelessWidget {
  const ServiceCenterSectionCard({
    super.key,
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
