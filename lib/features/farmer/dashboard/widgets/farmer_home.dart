import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_section_header.dart';
import 'package:smart_kishan/features/auth/session/session_cubit.dart';
import 'package:smart_kishan/features/auth/session/session_state.dart';
import 'package:smart_kishan/features/common/dashboard_tab_cubit.dart';
import 'package:smart_kishan/features/farmer/crop_info/widgets/crop_info_banner.dart';
import 'package:smart_kishan/features/farmer/daily_activity/cubit/daily_activity_cubit.dart';
import 'package:smart_kishan/features/farmer/daily_activity/cubit/daily_activity_state.dart';
import 'package:smart_kishan/features/farmer/daily_activity/data/activity.dart';
import 'package:smart_kishan/features/farmer/dashboard/widgets/quick_action_card.dart';
import 'package:smart_kishan/features/farmer/dashboard/widgets/weather_card.dart';
import 'package:smart_kishan/features/farmer/farmland/cubit/farmland_cubit.dart';
import 'package:smart_kishan/features/farmer/farmland/cubit/farmland_state.dart';
import 'package:smart_kishan/features/farmer/govt_services/govt_services_section.dart';
import 'package:smart_kishan/features/farmer/inventory/cubit/inventory_cubit.dart';
import 'package:smart_kishan/features/farmer/inventory/cubit/inventory_state.dart';
import 'package:smart_kishan/features/farmer/notes/widgets/notes_section.dart';
import 'package:smart_kishan/features/farmer/weather/cubit/weather_cubit.dart';

class FarmerHome extends StatefulWidget {
  const FarmerHome({super.key});

  @override
  State<FarmerHome> createState() => _FarmerHomeState();
}

class _FarmerHomeState extends State<FarmerHome> {
  @override
  void initState() {
    super.initState();
    context.read<WeatherCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        _FixedHeader(l10n: l10n),
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Curved green banner + weather card overlay
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 110,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: WeatherCard(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const NotesSection(),
                const SizedBox(height: 24),
                const GovtServicesSection(),
                const SizedBox(height: 24),
                const QuickActionsSection(),
                const SizedBox(height: 30),
                const CropInfoBanner(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(title: l10n.quickActions),
        const SizedBox(height: 20),
        _Grid(),
      ],
    );
  }
}

class _Grid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tile = context.colors.tileColors;

    // Inventory count is real; others 0 until their features exist.
    return BlocBuilder<InventoryCubit, InventoryState>(
      builder: (context, invState) {
        final inventoryCount = invState is InventoryLoaded
            ? invState.inventoryItems.length
            : 0;
        final inventoryCubit = context.read<InventoryCubit>();

        return BlocBuilder<DailyActivityCubit, DailyActivityState>(
          builder: (context, actState) {
            final activityCubit = context.read<DailyActivityCubit>();
            final activities = actState is DailyActivityLoaded
                ? actState.activities
                : const <Activity>[];
            final activityCount = activities.length;
            final incomeCount = activities
                .where((a) => a.income != null)
                .length;
            final expenseCount = activities
                .where((a) => a.expense != null)
                .length;
            return BlocBuilder<FarmlandCubit, FarmlandState>(
              builder: (context, farmlandState) {
                final farmlandCubit = context.read<FarmlandCubit>();
                final farmlandCount = farmlandState is FarmlandLoaded
                    ? farmlandState.farmlands.length
                    : 0;

                final actions = <QuickAction>[
                  QuickAction(
                    label: l10n.dailyActivities,
                    icon: Icons.task_alt,
                    imageAsset: 'assets/images/daily_activity.png',
                    count: activityCount,
                    onTap: () => context.push(
                      AppRoutePath.dailyActivity,
                      extra: activityCubit,
                    ),
                  ),
                  QuickAction(
                    label: l10n.inventory,
                    icon: Icons.inventory_2_outlined,
                    imageAsset: 'assets/images/inventory.png',
                    count: inventoryCount,
                    onTap: () => context.push(
                      AppRoutePath.inventory,
                      extra: inventoryCubit,
                    ),
                  ),
                  QuickAction(
                    label: l10n.income,
                    icon: Icons.sell_outlined,
                    imageAsset: 'assets/images/income.png',
                    count: incomeCount,
                    onTap: () =>
                        context.push(AppRoutePath.income, extra: activityCubit),
                  ),
                  QuickAction(
                    label: l10n.expense,
                    icon: Icons.account_balance_wallet_outlined,
                    imageAsset: 'assets/images/expense.png',
                    count: expenseCount,
                    onTap: () => context.push(
                      AppRoutePath.expense,
                      extra: activityCubit,
                    ),
                  ),
                  QuickAction(
                    label: l10n.farmLands,
                    icon: Icons.grass,
                    imageAsset: 'assets/images/farmland.png',
                    count: farmlandCount,
                    onTap: () => context.push(
                      AppRoutePath.farmlands,
                      extra: farmlandCubit,
                    ),
                  ),
                  QuickAction(
                    label: l10n.marketPrices,
                    icon: Icons.price_change_outlined,
                    imageAsset: 'assets/images/price_list.png',
                    onTap: () => context.push(AppRoutePath.marketPrices),
                  ),
                ];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: actions.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.0,
                        ),
                    itemBuilder: (_, i) => QuickActionCard(
                      action: actions[i],
                      color: tile[i % tile.length],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _FixedHeader extends StatelessWidget {
  const _FixedHeader({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      height: 80 + topInset,
      padding: EdgeInsets.only(top: topInset, left: 16, right: 16),
      color: colors.primary,
      child: Row(
        children: [
          // Drawer button (opens the shell's single drawer).
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Icon(
                Icons.menu_rounded,
                size: 26,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Welcome + name (from the session).
          Expanded(
            child: BlocBuilder<SessionCubit, SessionState>(
              builder: (context, state) {
                final name = state is Authenticated ? state.user.name : '';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.authWelcomeBack,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.85),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Profile avatar → switches to the Profile tab.
          GestureDetector(
            onTap: () => context.read<DashboardTabCubit>().select(3),
            child: BlocBuilder<SessionCubit, SessionState>(
              builder: (context, state) {
                final img = state is Authenticated ? state.user.image : null;
                final hasImg = img != null && img.isNotEmpty;
                return Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                    image: hasImg
                        ? DecorationImage(
                            image: NetworkImage(img),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: hasImg
                      ? null
                      : const Icon(
                          Icons.person_2_rounded,
                          size: 22,
                          color: Colors.white,
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
