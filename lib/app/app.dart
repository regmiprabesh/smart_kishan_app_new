import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/core/di/injector.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/features/auth/cubit/session_cubit.dart';
import 'package:smart_kishan/features/language/cubit/locale_cubit.dart';

import 'theme/app_theme.dart';
import 'theme/theme_cubit.dart';

/// The single app shell. Global cubits provided once at the root;
/// flow cubits are created per-route in app_router.dart.
class SmartKishanApp extends StatelessWidget {
  const SmartKishanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>.value(value: sl<SessionCubit>()),
        BlocProvider<LocaleCubit>.value(value: sl<LocaleCubit>()),
        BlocProvider<ThemeCubit>.value(value: sl<ThemeCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                title: 'Smart Kishan',
                debugShowCheckedModeBanner: false,

                // Snackbars from anywhere without a context.
                scaffoldMessengerKey: rootScaffoldMessengerKey,

                // Localization
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: locale,

                // Theme — no lerp on theme/locale switches (fonts with
                // different metrics made the lerp look like resizing).
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeMode,
                themeAnimationDuration: Duration.zero,

                routerConfig: sl<GoRouter>(),
              );
            },
          );
        },
      ),
    );
  }
}
