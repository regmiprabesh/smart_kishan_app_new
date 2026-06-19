import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_confirm_dialog.dart';
import 'package:smart_kishan/features/auth/cubit/session_cubit.dart';
import 'package:smart_kishan/features/auth/cubit/session_state.dart';
import 'package:smart_kishan/features/language/cubit/locale_cubit.dart';
import 'package:smart_kishan/features/language/data/language.dart';
import 'package:smart_kishan/features/language/widgets/language_tile.dart';
import 'package:smart_kishan/features/profile/widgets/profile_menu_option.dart';
import 'package:smart_kishan/features/profile/widgets/profile_section_label.dart';
import 'package:smart_kishan/features/profile/widgets/profile_theme_toggle.dart';
import 'package:smart_kishan/features/profile/widgets/profile_wave_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // ── helpers ───────────────────────────────────────────────────────────────

  void _showLanguageSheet(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>();
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: BlocBuilder<LocaleCubit, Locale>(
          bloc: localeCubit,
          builder: (ctx, locale) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Sheet handle ────────────────────────────────────────
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 4),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // ── Title ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Text(
                  l10n.selectLanguage,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Divider(height: 1, indent: 20, endIndent: 20),
              const SizedBox(height: 8),
              // ── Language tiles ──────────────────────────────────────
              for (final lang in Language.languageList())
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: LanguageTile(
                    language: lang,
                    isSelected: locale.languageCode == lang.languageCode,
                    onTap: () {
                      localeCubit.changeLocale(lang.languageCode);
                      Navigator.pop(sheetCtx);
                    },
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await AppConfirmDialog.show(
      context,
      title: l10n.confirmLogout,
      message: l10n.confirmLogoutMessage,
      confirmLabel: l10n.authLogout,
      cancelLabel: l10n.commonCancel,
      destructive: true,
    );
    if (ok && context.mounted) {
      context.read<SessionCubit>().signOut();
    }
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, state) {
          final user = state is Authenticated ? state.user : null;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // ── Wave header ──────────────────────────────────────────
              ProfileWaveHeader(
                userName: user?.name ?? '',
                userPhone: user?.phone,
                avatarUrl: user?.image,
                colors: colors,
                isDark: isDark,
              ),

              const SizedBox(height: 8),

              // ── Account ──────────────────────────────────────────────
              ProfileSectionLabel(label: 'l10n.profileSectionAccount'),
              ProfileMenuOption(
                icon: Icons.edit_outlined,
                title: l10n.profileEdit,
                onTap: () => context.push(AppRoutePath.editProfile),
              ),
              ProfileMenuOption(
                icon: Icons.lock_outline,
                title: l10n.profileChangePassword,
                onTap: () => context.push(AppRoutePath.updatePassword),
              ),
              ProfileMenuOption(
                icon: Icons.location_on_outlined,
                title: l10n.profileUpdateLocation,
                onTap: () => context.push(AppRoutePath.updateLocation),
              ),

              // ── Preferences ──────────────────────────────────────────
              ProfileSectionLabel(label: 'l10n.profileSectionPreferences'),
              ProfileMenuOption(
                icon: Icons.language_outlined,
                title: l10n.language,
                onTap: () => _showLanguageSheet(context),
              ),
              ProfileThemeToggleRow(colors: colors),

              // ── Danger zone ───────────────────────────────────────────
              Divider(
                height: 32,
                indent: 16,
                endIndent: 16,
                color: (colors.textSecondary).withValues(alpha: 0.12),
              ),
              ProfileMenuOption(
                icon: Icons.logout,
                title: l10n.authLogout,
                destructive: true,
                trailing: const SizedBox.shrink(),
                onTap: () => _confirmLogout(context),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
