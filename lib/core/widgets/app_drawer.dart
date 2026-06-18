import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';

class AppDrawerItem {
  const AppDrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.section,
    this.isActive = false,
    this.destructive = false,
    this.groupBreak = false,
  });

  final List<List<dynamic>> icon;
  final String title;
  final VoidCallback onTap;
  final String? section;
  final bool isActive;
  final bool destructive;
  final bool groupBreak;
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.items,
    required this.userName,
    this.userPhone,
    this.modeLabel,
    this.modeIcon,
    this.avatarUrl,
    this.appVersion,
  });

  final List<AppDrawerItem> items;
  final String userName;
  final String? userPhone;

  /// Mode tag text (e.g. "Farmer"). Shown capitalized.
  final String? modeLabel;

  /// Mode tag leading icon (HugeIcon data). Pass the icon for the mode.
  final List<List<dynamic>>? modeIcon;

  final String? avatarUrl;
  final String? appVersion;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final topInset = MediaQuery.paddingOf(context).top;

    return Drawer(
      backgroundColor: colors.surface,
      // Sharp edges (no rounded drawer corners).
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            colors: colors,
            topInset: topInset,
            userName: userName,
            userPhone: userPhone,
            modeLabel: modeLabel,
            modeIcon: modeIcon,
            avatarUrl: avatarUrl,
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: _buildItems(colors),
              ),
            ),
          ),
          if (appVersion != null) _Footer(colors: colors, version: appVersion!),
        ],
      ),
    );
  }

  List<Widget> _buildItems(dynamic colors) {
    final widgets = <Widget>[];
    bool seenDestructive = false;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      if (item.groupBreak) {
        widgets.add(
          Divider(
            height: 16,
            indent: 20,
            endIndent: 20,
            color: (colors.textSecondary as Color).withValues(alpha: 0.15),
          ),
        );
      }
      if (item.section != null) {
        widgets.add(
          Padding(
            padding: EdgeInsets.fromLTRB(20, i == 0 ? 4 : 16, 20, 6),
            child: Text(
              item.section!.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: (colors.textSecondary as Color).withValues(alpha: 0.7),
                letterSpacing: 0.8,
              ),
            ),
          ),
        );
      }

      widgets.add(_Tile(item: item, colors: colors));
    }

    return widgets;
  }
}

// ── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.colors,
    required this.topInset,
    required this.userName,
    this.userPhone,
    this.modeLabel,
    this.modeIcon,
    this.avatarUrl,
  });

  final dynamic colors;
  final double topInset;
  final String userName;
  final String? userPhone;
  final String? modeLabel;
  final List<List<dynamic>>? modeIcon;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF0E4F2F), colors.primary],
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -28,
            left: 40,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          // Content — reduced vertical padding for a shorter header.
          Padding(
            padding: EdgeInsets.fromLTRB(20, topInset + 14, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Avatar(
                  colors: colors,
                  hasAvatar: hasAvatar,
                  avatarUrl: avatarUrl,
                  initials: _initials(userName),
                ),
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (userPhone != null && userPhone!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    userPhone!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (modeLabel != null && modeLabel!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (modeIcon != null) ...[
                          HugeIcon(
                            icon: modeIcon!,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          _capitalize(modeLabel!),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.colors,
    required this.hasAvatar,
    required this.avatarUrl,
    required this.initials,
  });

  final dynamic colors;
  final bool hasAvatar;
  final String? avatarUrl;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: colors.surface,
        backgroundImage: hasAvatar
            ? NetworkImage(avatarUrl!) as ImageProvider
            : null,
        child: hasAvatar
            ? null
            : Text(
                initials,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
              ),
      ),
    );
  }
}

// ── Tile ──────────────────────────────────────────────────────────────────────

class _Tile extends StatelessWidget {
  const _Tile({required this.item, required this.colors});
  final AppDrawerItem item;
  final dynamic colors;

  @override
  Widget build(BuildContext context) {
    final Color accent = item.destructive
        ? colors.error
        : item.isActive
        ? colors.primary
        : colors.textSecondary;

    final Color bubbleColor = item.destructive
        ? (colors.error as Color).withValues(alpha: 0.10)
        : item.isActive
        ? (colors.primary as Color).withValues(alpha: 0.12)
        : (colors.textSecondary as Color).withValues(alpha: 0.08);

    final Color textColor = item.destructive
        ? colors.error
        : item.isActive
        ? colors.primary
        : colors.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Material(
        color: item.isActive
            ? (colors.primary as Color).withValues(alpha: 0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: HugeIcon(icon: item.icon, color: accent, size: 20),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: item.isActive
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Footer ────────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer({required this.colors, required this.version});
  final dynamic colors;
  final String version;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: (colors.textSecondary as Color).withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SmartKishan',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
          Text(
            version,
            style: TextStyle(
              fontSize: 11,
              color: (colors.textSecondary as Color).withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
