import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/app/theme/theme_cubit.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_confirm_dialog.dart';
import 'package:smart_kishan/features/auth/session/cubit/session_cubit.dart';
import 'package:smart_kishan/features/auth/session/cubit/session_state.dart';
import 'package:smart_kishan/features/language/cubit/locale_cubit.dart';
import 'package:smart_kishan/features/language/data/Language.dart';
import 'package:smart_kishan/features/language/widgets/language_tile.dart';
import 'package:smart_kishan/features/profile/widgets/profile_menu_option.dart';

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
              _WaveHeader(
                userName: user?.name ?? '',
                userPhone: user?.phone,
                avatarUrl: user?.image,
                colors: colors,
                isDark: isDark,
              ),

              const SizedBox(height: 8),

              // ── Account ──────────────────────────────────────────────
              _SectionLabel(label: 'l10n.profileSectionAccount'),
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
              _SectionLabel(label: 'l10n.profileSectionPreferences'),
              ProfileMenuOption(
                icon: Icons.language_outlined,
                title: l10n.language,
                onTap: () => _showLanguageSheet(context),
              ),
              _ThemeToggleRow(colors: colors),

              // ── Danger zone ───────────────────────────────────────────
              Divider(
                height: 32,
                indent: 16,
                endIndent: 16,
                color: (colors.textSecondary as Color).withValues(alpha: 0.12),
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

// ── Section label ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: (colors.textSecondary as Color).withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

// ── Theme toggle row ──────────────────────────────────────────────────────

class _ThemeToggleRow extends StatelessWidget {
  const _ThemeToggleRow({required this.colors});
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    final primaryColor = colors.primary as Color;

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isOn = themeMode == ThemeMode.dark;

        return InkWell(
          onTap: () => context.read<ThemeCubit>().set(
            isOn ? ThemeMode.light : ThemeMode.dark,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SizedBox(
              height: 52,
              child: Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: Icon(
                      isOn
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      key: ValueKey(isOn),
                      size: 22,
                      color: colors.textSecondary as Color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      // TODO: add l10n keys darkMode / lightMode
                      isOn ? 'Dark Mode' : 'Light Mode',
                      style: TextStyle(
                        fontSize: 15,
                        color: colors.textPrimary as Color,
                      ),
                    ),
                  ),
                  _ThemePillToggle(
                    isOn: isOn,
                    primaryColor: primaryColor,
                    onTap: () => context.read<ThemeCubit>().set(
                      isOn ? ThemeMode.light : ThemeMode.dark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Custom pill toggle ────────────────────────────────────────────────────
//
// A fully custom animated toggle — avoids Switch.adaptive's platform-specific
// inactive track styling which looks washed out on light mode Material 3.
//
// Light off: light grey track, white thumb with sun icon, dark icon tint
// Light on:  brand-green track, white thumb with moon icon
// Dark  off: dark track, white thumb with sun icon
// Dark  on:  brand-green track, white thumb with moon icon

class _ThemePillToggle extends StatelessWidget {
  const _ThemePillToggle({
    required this.isOn,
    required this.primaryColor,
    required this.onTap,
  });

  final bool isOn;
  final Color primaryColor;
  final VoidCallback onTap;

  static const double _w = 52.0;
  static const double _h = 28.0;
  static const double _thumb = 22.0;
  static const double _pad = 3.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Track colour: green when on, a visible grey when off
    final trackColor = isOn
        ? primaryColor
        : isDark
        ? Colors.white.withValues(alpha: 0.15)
        : const Color(0xFFDDE1E7); // solid light grey — visible on white bg

    // Thumb slides between left (_pad) and right (_w - _thumb - _pad)
    final thumbX = isOn ? _w - _thumb - _pad : _pad;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        width: _w,
        height: _h,
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: BorderRadius.circular(_h / 2),
        ),
        child: Stack(
          children: [
            // Sliding thumb
            AnimatedPositioned(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              left: thumbX,
              top: _pad,
              child: Container(
                width: _thumb,
                height: _thumb,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      isOn ? Icons.dark_mode : Icons.light_mode,
                      key: ValueKey(isOn),
                      size: 14,
                      color: isOn
                          ? primaryColor
                          : const Color(0xFFFFB300), // amber sun
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Wave header ───────────────────────────────────────────────────────────

class _WaveHeader extends StatelessWidget {
  const _WaveHeader({
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
