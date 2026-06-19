import 'package:flutter/material.dart';

/// Curved gradient header with floating bubbles and an overlapping avatar ring,
/// plus the user's name and phone. Used at the top of the profile screen.
class ProfileWaveHeader extends StatelessWidget {
  const ProfileWaveHeader({
    super.key,
    required this.userName,
    required this.colors,
    required this.isDark,
    this.userPhone,
    this.avatarUrl,
  });

  final String userName;
  final String? userPhone;
  final String? avatarUrl;
  final dynamic colors;
  final bool isDark;

  static const double _waveHeight = 140.0;
  static const double _avatarRadius = 44.0;
  static const double _overlapFraction = 0.5;

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;
    final initials = _initials(userName);
    final overlapOffset = _avatarRadius * 2 * _overlapFraction + 3;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            ClipPath(
              clipper: _WaveClipper(),
              child: Container(
                height: _waveHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [const Color(0xFF062318), const Color(0xFF0E4F2F)]
                        : [const Color(0xFF0E4F2F), const Color(0xFF1A7A4A)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -40,
                      right: -24,
                      child: _Bubble(size: 140, opacity: 0.07),
                    ),
                    Positioned(
                      top: 20,
                      left: -20,
                      child: _Bubble(size: 90, opacity: 0.05),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -overlapOffset,
              child: _AvatarRing(
                radius: _avatarRadius,
                hasAvatar: hasAvatar,
                avatarUrl: avatarUrl,
                initials: initials,
                colors: colors,
              ),
            ),
          ],
        ),
        SizedBox(height: overlapOffset + 10),
        Text(
          userName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary as Color,
          ),
        ),
        if (userPhone != null && userPhone!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            userPhone!,
            style: TextStyle(
              fontSize: 13,
              color: (colors.textSecondary as Color).withValues(alpha: 0.8),
            ),
          ),
        ],
        const SizedBox(height: 4),
      ],
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveClipper old) => false;
}

class _AvatarRing extends StatelessWidget {
  const _AvatarRing({
    required this.radius,
    required this.hasAvatar,
    required this.initials,
    required this.colors,
    this.avatarUrl,
  });

  final double radius;
  final bool hasAvatar;
  final String? avatarUrl;
  final String initials;
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: colors.surface as Color,
        backgroundImage: hasAvatar
            ? NetworkImage(avatarUrl!) as ImageProvider
            : null,
        child: hasAvatar
            ? null
            : Text(
                initials,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: colors.primary as Color,
                ),
              ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size, required this.opacity});
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}
