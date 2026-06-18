import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// One horizontally-scrolling government-service card: gradient fill, two
/// decorative bleed circles, an icon chip, a small badge pill, title +
/// subtitle. Faithful to the old `_buildHorizontalFeatureCard` (250×135 in a
/// 155-tall strip). Self-contained so the home screen just lists these.
class GovtServiceCard extends StatelessWidget {
  const GovtServiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String badge;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 135,
      child: Material(
        elevation: 3,
        shadowColor: gradientColors.first.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
            ),
            child: Stack(
              children: [
                Positioned(top: -30, right: -30, child: _circle(100, 0.08)),
                Positioned(bottom: -35, left: -35, child: _circle(110, 0.06)),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(icon, color: Colors.white, size: 22),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              badge,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              CupertinoIcons.right_chevron,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circle(double size, double alpha) => Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: alpha),
      shape: BoxShape.circle,
    ),
  );
}
