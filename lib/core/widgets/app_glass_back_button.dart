import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Frosted circular back button that floats over a full-bleed hero image on
/// detail screens that have no AppBar (e.g. crop info, farmland). Place it in
/// the screen's top-level [Stack] at `top: topInset + 8, left: 12`.
///
/// Defaults to popping the current route; pass [onTap] to override.
class AppGlassBackButton extends StatelessWidget {
  const AppGlassBackButton({
    super.key,
    this.onTap,
    this.icon = CupertinoIcons.back,
  });

  final VoidCallback? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Material(
          color: Colors.black.withValues(alpha: 0.28),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap ?? () => Navigator.of(context).maybePop(),
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}
