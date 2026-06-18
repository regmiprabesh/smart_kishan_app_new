import 'package:flutter/material.dart';
import 'package:smart_kishan/core/utils/formatters.dart';

class QuickAction {
  const QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.imageAsset,
    this.count, // ← nullable; omit entirely to hide the badge
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final String? imageAsset;
  final int? count; // ← was: final int count = 0
}

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key, required this.action, required this.color});

  final QuickAction action;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: action.onTap,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Only show count when it's been explicitly provided.
                    if (action.count != null) ...[
                      Text(
                        context.ld(action.count!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Expanded(
                      child: Text(
                        action.label,
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(64),
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(right: 15, top: 15),
                  child: _Graphic(action: action, color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Graphic extends StatelessWidget {
  const _Graphic({required this.action, required this.color});
  final QuickAction action;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (action.imageAsset != null) {
      return Image.asset(
        action.imageAsset!,
        width: 32,
        height: 32,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(action.icon, color: color, size: 30),
      );
    }
    return Icon(action.icon, color: color, size: 30);
  }
}
