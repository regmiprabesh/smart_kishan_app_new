import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/core/enums/app_mode.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_bottom_nav.dart';
import 'package:smart_kishan/core/widgets/app_drawer.dart';
import 'package:smart_kishan/features/auth/session/cubit/session_cubit.dart';
import 'package:smart_kishan/features/auth/session/cubit/session_state.dart';
import 'package:smart_kishan/features/common/dashboard_tab_cubit.dart';
import 'package:smart_kishan/features/farmer/daily_activity/cubit/daily_activity_cubit.dart';
import 'package:smart_kishan/features/farmer/dashboard/widgets/farmer_home.dart';
import 'package:smart_kishan/features/farmer/ledger/cubit/ledger_cubit.dart';
import 'package:smart_kishan/features/farmer/ledger/view/ledger_chart_screen.dart';
import 'package:smart_kishan/features/profile/view/profile_screen.dart';

/// Farmer mode shell: IndexedStack of tabs + bottom nav + drawer.
/// Tabs: Home, Notes(placeholder chart spot), Users, Profile — kept close
/// to the old set; Chart/Ledger routes via the feature grid for now.
class FarmerDashboardScreen extends StatelessWidget {
  const FarmerDashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => DashboardTabCubit(),
      child: Builder(
        builder: (context) {
          final session = context.read<SessionCubit>();
          final authState = session.state is Authenticated
              ? session.state as Authenticated
              : null;
          final user = authState?.user;
          final mode = authState?.mode;
          final tag = modeTag(context, mode);
          final drawer = FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snap) {
              final version = snap.hasData
                  ? 'v${context.ld(snap.data!.version)}'
                  : null;
              return AppDrawer(
                userName: user?.name ?? '',
                userPhone: user?.phone,
                avatarUrl: user?.image,
                modeLabel: tag?.$1, // ← localized label from helper
                modeIcon: tag?.$2,
                appVersion: version,
                items: [
                  AppDrawerItem(
                    section: l10n.drawerSectionMain,
                    icon: HugeIcons.strokeRoundedProductLoading,
                    title: l10n.marketplaceBuyerMode,
                    onTap: () => session.switchMode(AppMode.buyer),
                  ),
                  AppDrawerItem(
                    icon: HugeIcons.strokeRoundedShopSign,
                    title: l10n.marketplaceSellerMode,
                    onTap: () => session.switchMode(AppMode.seller),
                  ),

                  AppDrawerItem(
                    icon: HugeIcons.strokeRoundedPropertyView,
                    title: l10n.inventory,
                    onTap: () => context.push(AppRoutePath.inventory),
                  ),
                  // AppDrawerItem(
                  //   icon: HugeIcons.strokeRoundedTaskDaily01,
                  //   title: l10n.dailyActivities,
                  //   onTap: () => context.push(AppRoutePath.dailyActivity),
                  // ),
                  // AppDrawerItem(
                  //   icon: HugeIcons.strokeRoundedPlant01,
                  //   title: l10n.farmLands,
                  //   onTap: () => context.push(AppRoutePath.farmlands),
                  // ),
                  AppDrawerItem(
                    section: l10n.drawerSectionServices,
                    icon: HugeIcons.strokeRoundedHandHelping,
                    title: l10n.subsidies,
                    onTap: () => context.push(AppRoutePath.subsidies),
                  ),
                  AppDrawerItem(
                    icon: HugeIcons.strokeRoundedOffice,
                    title: 'Service centers',
                    onTap: () => context.push(AppRoutePath.subsidies),
                  ),
                  AppDrawerItem(
                    icon: HugeIcons.strokeRoundedLogout03,
                    title: l10n.authLogout,
                    destructive: true,
                    groupBreak: true,
                    onTap: () => session.signOut(),
                  ),
                ],
              );
            },
          );
          return BlocBuilder<DashboardTabCubit, int>(
            builder: (context, index) {
              return Scaffold(
                drawer: drawer,
                body: IndexedStack(
                  index: index,
                  children: [
                    FarmerHome(),
                    BlocProvider(
                      create: (ctx) =>
                          LedgerCubit(ctx.read<DailyActivityCubit>()),
                      child: Builder(
                        builder: (ctx) =>
                            LedgerChartScreen(cubit: ctx.read<LedgerCubit>()),
                      ),
                    ),
                    _ComingSoonTab(titleKey: 'users'),
                    ProfileScreen(),
                  ],
                ),
                bottomNavigationBar: AppBottomNav(
                  currentIndex: index,
                  onTap: context.read<DashboardTabCubit>().select,
                  items: [
                    AppNavItem(
                      icon: HugeIcons.strokeRoundedHome01,
                      label: l10n.navigationHome,
                    ),
                    AppNavItem(
                      icon: HugeIcons.strokeRoundedChartAnalysis,
                      label: l10n.navigationChart,
                    ),
                    AppNavItem(
                      icon: HugeIcons.strokeRoundedUserMultiple,
                      label: l10n.navigationUsers,
                    ),
                    AppNavItem(
                      icon: HugeIcons.strokeRoundedUser,
                      label: l10n.navigationProfile,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  (String, List<List<dynamic>>)? modeTag(BuildContext context, String? mode) {
    final l10n = AppLocalizations.of(context)!;
    return switch (mode) {
      AppMode.farmer => (l10n.modeFarmer, HugeIcons.strokeRoundedPlant02),
      AppMode.seller => (l10n.modeVendor, HugeIcons.strokeRoundedStore01),
      AppMode.buyer => (l10n.modeBuyer, HugeIcons.strokeRoundedShoppingBag01),
      _ => null,
    };
  }
}

/// Temporary tab body for Ledger/Users until their Phase-4 builds.
class _ComingSoonTab extends StatelessWidget {
  const _ComingSoonTab({required this.titleKey});
  final String titleKey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titleKey)),
      body: const Center(child: Text('Coming in Phase 4')),
    );
  }
}
