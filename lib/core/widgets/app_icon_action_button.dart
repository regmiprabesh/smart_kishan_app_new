import 'package:flutter/material.dart';

class AppIconActionButton extends StatelessWidget {
  const AppIconActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
      child: IconButton(
        icon: Icon(icon, size: 19, color: color),
        tooltip: tooltip,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
        onPressed: onTap,
      ),
    );
  }
}
