import 'package:flutter/material.dart';

/// Pure branding UI. ZERO logic: SessionCubit.restore() (kicked off in
/// main) + the router's redirect guard decide where to go next.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // adjust to your asset
              width: 140,
              errorBuilder: (_, __, ___) => const FlutterLogo(size: 100),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(strokeWidth: 2.5),
          ],
        ),
      ),
    );
  }
}
