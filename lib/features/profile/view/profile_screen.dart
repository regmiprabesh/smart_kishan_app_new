import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_confirm_dialog.dart';
import 'package:smart_kishan/features/auth/session/session_cubit.dart';
import 'package:smart_kishan/features/auth/session/session_state.dart';
import 'package:smart_kishan/features/language/cubit/locale_cubit.dart';
import 'package:smart_kishan/features/language/data/Language.dart';
import 'package:smart_kishan/features/language/widgets/language_tile.dart';
import 'package:smart_kishan/features/profile/widgets/profile_menu_option.dart';

/// Profile view — shared by farmer/buyer/seller dashboards (a tab in each).
/// Shows the user header, a language switcher (reusing LanguageTile via a
/// bottom sheet), menu options, and logout with a confirm dialog.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLanguageSheet(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>();
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetCtx) => SafeArea(
        child: BlocBuilder<LocaleCubit, Locale>(
          bloc: localeCubit,
          builder: (ctx, locale) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              const SizedBox(height: 8),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, state) {
          final user = state is Authenticated ? state.user : null;
          return ListView(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                color: colors.primary,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: colors.surface,
                      backgroundImage:
                          (user?.image != null && user!.image!.isNotEmpty)
                          ? NetworkImage(user.image!)
                          : null,
                      child: (user?.image == null || user!.image!.isEmpty)
                          ? Icon(Icons.person, size: 44, color: colors.primary)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.name ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (user?.phone != null)
                      Text(
                        user!.phone!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
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
              ProfileMenuOption(
                icon: Icons.language_outlined,
                title: l10n.language,
                onTap: () => _showLanguageSheet(context),
              ),
              const Divider(),
              ProfileMenuOption(
                icon: Icons.logout,
                title: l10n.authLogout,
                destructive: true,
                trailing: const SizedBox.shrink(),
                onTap: () => _confirmLogout(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
