import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    this.compact = false,
    this.actionIcon = Icons.add,
  });

  final IconData icon;
  final String title;
  final String? description;

  final String? actionLabel;
  final VoidCallback? onAction;

  final bool compact;
  final IconData actionIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconSize = compact ? 40.0 : 64.0;
    final circlePad = compact ? 16.0 : 28.0;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? 16 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(circlePad),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: iconSize, color: colors.primary),
            ),
            SizedBox(height: compact ? 12 : 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: compact ? 14 : 18,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: colors.textSecondary),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: compact ? 16 : 32),
              ElevatedButton.icon(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(actionIcon),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
