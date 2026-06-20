import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_card_list_skeleton.dart';
import 'package:smart_kishan/core/widgets/app_card_menu.dart';
import 'package:smart_kishan/core/widgets/app_confirm_dialog.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';
import 'package:smart_kishan/core/widgets/app_search_field.dart';
import 'package:smart_kishan/features/farmer/daily_activity/cubit/daily_activity_cubit.dart';
import 'package:smart_kishan/features/farmer/daily_activity/cubit/daily_activity_state.dart';
import 'package:smart_kishan/features/farmer/daily_activity/data/activity.dart';
import 'package:smart_kishan/features/farmer/daily_activity/view/activity_args.dart';
import 'package:smart_kishan/features/auth/cubit/session_cubit.dart';
import 'package:smart_kishan/features/auth/cubit/session_state.dart';

/// Full daily-activity list. Rich cards with a type badge (Buy/Sell/Other),
/// income/expense, quantity, and an ⋮ menu (edit/delete). Receives the live
/// cubit via `extra` from the home so the count + list stay in sync.
class DailyActivityListScreen extends StatefulWidget {
  const DailyActivityListScreen({super.key, required this.cubit});
  final DailyActivityCubit cubit;

  @override
  State<DailyActivityListScreen> createState() =>
      _DailyActivityListScreenState();
}

class _DailyActivityListScreenState extends State<DailyActivityListScreen> {
  late final _searchController = TextEditingController(
    text: widget.cubit.state is DailyActivityLoaded
        ? (widget.cubit.state as DailyActivityLoaded).query
        : '',
  );

  @override
  void dispose() {
    //widget.cubit.search('');
    _searchController.dispose();
    super.dispose();
  }

  void _openEditor({Activity? activity}) {
    context.push(
      AppRoutePath.addDailyActivity,
      extra: ActivityArgs(cubit: widget.cubit, activity: activity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        appBar: AppAppBar(title: l10n.dailyActivities),
        floatingActionButton:
            BlocBuilder<DailyActivityCubit, DailyActivityState>(
              builder: (context, state) {
                final hasItems =
                    state is DailyActivityLoaded && state.activities.isNotEmpty;
                return hasItems
                    ? FloatingActionButton.extended(
                        onPressed: () => _openEditor(),
                        icon: const Icon(Icons.add),
                        label: Text(l10n.dailyActivityAdd),
                      )
                    : const SizedBox.shrink();
              },
            ),
        body: BlocBuilder<DailyActivityCubit, DailyActivityState>(
          builder: (context, state) {
            return Column(
              children: [
                ColoredBox(
                  color: context.colors.surface,
                  child: AppSearchField(
                    hintText: l10n.commonSearch,
                    controller: _searchController,
                    onChanged: widget.cubit.search,
                    enabled: state is DailyActivityLoaded,
                  ),
                ),
                Expanded(
                  child: switch (state) {
                    DailyActivityLoading() => const AppCardListSkeleton(),
                    DailyActivityFailure() => AppEmptyState(
                      icon: Icons.error_outline,
                      title: l10n.errorGeneric,
                      actionLabel: l10n.commonRefresh,
                      actionIcon: Icons.refresh,
                      onAction: () => widget.cubit.load(),
                    ),
                    DailyActivityLoaded() => _loaded(context, state, l10n),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _loaded(
    BuildContext context,
    DailyActivityLoaded state,
    AppLocalizations l10n,
  ) {
    // Empty = no activities at all (show the add CTA).
    if (state.activities.isEmpty) {
      return AppEmptyState(
        icon: Icons.event_note_outlined,
        title: l10n.dailyActivityEmpty,
        description: l10n.dailyActivityEmptyDescription,
        actionLabel: l10n.dailyActivityAdd,
        onAction: () => _openEditor(),
      );
    }
    // Filtered by the current query (lives in the cubit/state).
    final filtered = widget.cubit.filtered(state);
    if (filtered.isEmpty) {
      return AppEmptyState(icon: Icons.search_off, title: l10n.commonNoResults);
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (_, i) =>
          _ActivityCard(activity: filtered[i], cubit: widget.cubit),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity, required this.cubit});
  final Activity activity;
  final DailyActivityCubit cubit;

  /// type → (label, color, icon). Unknown/Other handled gracefully.
  (String, Color, IconData) _typeStyle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return switch (activity.type) {
      'Buy' => (l10n.dailyActivityBuy, colors.info, Icons.trending_down),
      'Sell' => (l10n.dailyActivitySell, colors.success, Icons.trending_up),
      'Other' => (l10n.dailyActivityOther, colors.primary, Icons.event_note),
      _ => (l10n.dailyActivityOther, colors.iconSecondary, Icons.more_horiz),
    };
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await AppConfirmDialog.delete(
      context,
      title: l10n.dailyActivityDeleteConfirmTitle,
      message: l10n.dailyActivityDeleteConfirmMessage,
    );
    if (ok) {
      final success = await cubit.delete(activity.id!);
      if (!success && context.mounted) AppSnackbar.error(l10n.errorGeneric);
    }
  }

  void _edit(BuildContext context) {
    context.push(
      AppRoutePath.addDailyActivity,
      extra: ActivityArgs(cubit: cubit, activity: activity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final (typeLabel, typeColor, typeIcon) = _typeStyle(context);

    // Amount line: Sell shows income (+), Buy shows expense (−), Other none.
    final bool hasAmount = activity.income != null || activity.expense != null;
    final bool isIncome = activity.income != null;
    final double amountValue = activity.income ?? activity.expense ?? 0;

    final sessionState = context.read<SessionCubit>().state;
    final currentUser = sessionState is Authenticated
        ? sessionState.user
        : null;
    final isParent =
        currentUser?.parentId == null || currentUser?.parentId == 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _edit(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Leading type chip
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(typeIcon, color: typeColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Type badge + quantity
                          Row(
                            children: [
                              Text(
                                typeLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: typeColor,
                                ),
                              ),
                              if (activity.quantity != null) ...[
                                Text(
                                  ' · ',
                                  style: TextStyle(color: colors.textSecondary),
                                ),
                                Text(
                                  '${l10n.dailyActivityQuantityLabel}: ${context.ld(activity.quantity!)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Amount (income green / expense red)
                    if (hasAmount)
                      Text(
                        '${isIncome ? '+' : '-'}${l10n.currencySymbol} ${context.ld(amountValue.toStringAsFixed(0))}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isIncome ? colors.success : colors.error,
                        ),
                      ),
                    AppCardMenu(
                      actions: [
                        AppCardMenuAction(
                          icon: Icons.edit_rounded,
                          label: l10n.commonEdit,
                          onTap: () => _edit(context),
                        ),
                        AppCardMenuAction(
                          icon: Icons.delete_rounded,
                          label: l10n.commonDelete,
                          destructive: true,
                          onTap: () => _confirmDelete(context),
                        ),
                      ],
                    ),
                  ],
                ),
                if (activity.description != null &&
                    activity.description!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    activity.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
                // Footer: date always; "added by" only for parent accounts.
                if (activity.date != null ||
                    (isParent && activity.user != null)) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Date — always shown when present.
                      if (activity.date != null) ...[
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 14,
                          color: colors.iconSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.shortDate(activity.date),
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      // Added-by — only for parent accounts, after a dot separator.
                      if (isParent && activity.user != null) ...[
                        if (activity.date != null) ...[
                          const SizedBox(width: 10),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: colors.iconSecondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Icon(
                          Icons.person_outline_rounded,
                          size: 14,
                          color: colors.iconSecondary,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            activity.user!.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
