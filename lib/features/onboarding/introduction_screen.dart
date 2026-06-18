import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/core/di/injector.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/services/local_storage_service.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';

/// Intro stories after language selection on first launch.
/// "Get Started" / Skip marks onboarding done as a real bool (old code
/// stored the STRING 'false'), then goes to sign-in — the router's guard
/// will never show this flow again.
class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await sl<LocalStorageService>().setOnboardingDone();
    if (mounted) context.go(AppRoutePath.signIn);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final stories = [
      (
        l10n.onboardingFarmingTitle,
        l10n.onboardingFarmingDescription,
        'assets/images/intro_1.png',
      ),
      (
        l10n.onboardingFarmlandTitle,
        l10n.onboardingFarmlandDescription,
        'assets/images/intro_2.png',
      ),
      (
        l10n.onboardingStockTitle,
        l10n.onboardingStockDescription,
        'assets/images/intro_3.png',
      ),
      (
        l10n.onboardingNotesTitle,
        l10n.onboardingStockDescription,
        'assets/images/intro_4.png',
      ),
    ];
    final isLast = _currentPage == stories.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: _finish, child: Text(l10n.skip)),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: stories.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final (title, desc, image) = stories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          image,
                          height: 260,
                          errorBuilder: (_, __, ___) =>
                              const SizedBox(height: 260),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          desc,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(stories.length, (i) {
                final active = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: AppPrimaryButton(
                label: isLast ? l10n.getStarted : l10n.next,
                onPressed: () {
                  if (isLast) {
                    _finish();
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
