import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/features/language/data/language.dart';
import '../cubit/locale_cubit.dart';
import '../widgets/language_tile.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                l10n.language,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.selectLanguage,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 28),
              BlocBuilder<LocaleCubit, Locale>(
                builder: (context, locale) {
                  return Column(
                    children: [
                      for (final lang in Language.languageList()) ...[
                        LanguageTile(
                          language: lang,
                          isSelected: locale.languageCode == lang.languageCode,
                          onTap: () => context.read<LocaleCubit>().changeLocale(
                            lang.languageCode,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  );
                },
              ),
              const Spacer(flex: 2),
              AppPrimaryButton(
                label: l10n.next,
                onPressed: () => context.push(AppRoutePath.introduction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
