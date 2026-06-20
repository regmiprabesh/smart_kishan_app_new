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
import 'package:smart_kishan/core/widgets/app_search_field.dart';
import 'package:smart_kishan/features/farmer/inventory/cubit/inventory_cubit.dart';
import 'package:smart_kishan/features/farmer/inventory/cubit/inventory_state.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';
import 'package:smart_kishan/features/farmer/inventory/data/inventory_item.dart';
import 'package:smart_kishan/features/farmer/inventory/view/inventory_item_args.dart';
import 'package:smart_kishan/shared/models/unit.dart';

/// Full inventory list. Rich inventoryItem cards (name, stock + unit, sellable
/// chip, description) with edit/delete. Receives the live InventoryCubit via
/// `extra` from the home so the count + list stay in sync.
class InventoryListScreen extends StatefulWidget {
  const InventoryListScreen({super.key, required this.cubit});
  final InventoryCubit cubit;

  @override
  State<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends State<InventoryListScreen> {
  late final _searchController = TextEditingController(
    text: widget.cubit.state is InventoryLoaded
        ? (widget.cubit.state as InventoryLoaded).query
        : '',
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        appBar: AppAppBar(title: l10n.inventory),
        body: BlocBuilder<InventoryCubit, InventoryState>(
          builder: (context, state) {
            return Column(
              children: [
                ColoredBox(
                  color: context.colors.surface,
                  child: AppSearchField(
                    hintText: l10n.commonSearch,
                    controller: _searchController,
                    onChanged: widget.cubit.search,
                    enabled: state is InventoryLoaded,
                  ),
                ),

                Expanded(
                  child: switch (state) {
                    InventoryLoading() => const AppCardListSkeleton(),
                    InventoryFailure() => AppEmptyState(
                      icon: Icons.error_outline,
                      title: l10n.errorGeneric,
                      actionLabel: l10n.commonRefresh,
                      onAction: () => widget.cubit.load(),
                      actionIcon: Icons.refresh,
                    ),
                    InventoryLoaded(:final inventoryItems, :final units) =>
                      inventoryItems.isEmpty
                          ? AppEmptyState(
                              icon: Icons.inventory_2_outlined,
                              title: l10n.inventoryItemEmpty,
                              description: l10n.inventoryItemEmptyDescription,
                              actionLabel: l10n.inventoryItemAdd,
                              onAction: () => _openEditor(context),
                            )
                          : _loaded(context, state, l10n, units),
                  },
                ),
              ],
            );
          },
        ),
        floatingActionButton: BlocBuilder<InventoryCubit, InventoryState>(
          builder: (context, state) {
            final hasItems =
                state is InventoryLoaded && state.inventoryItems.isNotEmpty;
            return hasItems
                ? FloatingActionButton.extended(
                    onPressed: () => _openEditor(context),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.inventoryItemAdd),
                  )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _loaded(
    BuildContext context,
    InventoryLoaded state,
    AppLocalizations l10n,
    List<Unit> units,
  ) {
    if (state.inventoryItems.isEmpty) {
      return AppEmptyState(
        icon: Icons.inventory_2_outlined,
        title: l10n.inventoryItemEmpty,
        description: l10n.inventoryItemEmptyDescription,
        actionLabel: l10n.inventoryItemAdd,
        onAction: () => _openEditor(context),
      );
    }
    final filtered = widget.cubit.filtered(state);
    if (filtered.isEmpty) {
      return AppEmptyState(icon: Icons.search_off, title: l10n.commonNoResults);
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, i) => _InventoryItemCard(
        inventoryItem: filtered[i],
        cubit: widget.cubit,
        units: units,
      ),
    );
  }

  void _openEditor(BuildContext context, {InventoryItem? inventoryItem}) {
    context.push(
      AppRoutePath.addInventoryItem,
      extra: InventoryItemArgs(
        cubit: widget.cubit,
        inventoryItem: inventoryItem,
      ),
    );
  }
}

class _InventoryItemCard extends StatelessWidget {
  const _InventoryItemCard({
    required this.inventoryItem,
    required this.units,
    required this.cubit,
  });
  final InventoryItem inventoryItem;
  final List<Unit> units;
  final InventoryCubit cubit;

  (Color, IconData) _tradeStyle(BuildContext context) {
    final colors = context.colors;
    return switch (inventoryItem.isSellable) {
      1 => (colors.success, Icons.sell_outlined),
      2 => (colors.info, Icons.storefront),
      3 => (colors.primary, Icons.swap_horiz),
      _ => (colors.iconSecondary, Icons.inventory_2_outlined),
    };
  }

  String _unitName(BuildContext context) {
    final unit =
        inventoryItem.unit ??
        (units.any((u) => u.id == inventoryItem.unitId)
            ? units.firstWhere((u) => u.id == inventoryItem.unitId)
            : null);
    return unit?.name?.of(context) ?? '';
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await AppConfirmDialog.delete(
      context,
      title: l10n.inventoryItemDeleteConfirmTitle,
      message: l10n.inventoryItemDeleteConfirmMessage,
    );
    if (ok) {
      final success = await cubit.delete(inventoryItem.id!);
      if (!success && context.mounted) AppSnackbar.error(l10n.errorGeneric);
    }
  }

  void _edit(BuildContext context) {
    context.push(
      AppRoutePath.addInventoryItem,
      extra: InventoryItemArgs(cubit: cubit, inventoryItem: inventoryItem),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final (tradeColor, tradeIcon) = _tradeStyle(context);

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
                    // Leading icon chip
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: tradeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(tradeIcon, color: tradeColor, size: 22),
                    ),

                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inventoryItem.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${l10n.inventoryItemStockLabel}: ${context.ld(inventoryItem.stock ?? 0)} ${_unitName(context)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
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

                    // AppIconActionButton(
                    //   icon: Icons.edit_rounded,
                    //   color: colors.primary,
                    //   tooltip: l10n.commonEdit,
                    //   onTap: () => _edit(context),
                    // ),
                    // const SizedBox(width: 8),
                    // AppIconActionButton(
                    //   icon: Icons.delete_rounded,
                    //   color: colors.error,
                    //   tooltip: l10n.commonDelete,
                    //   onTap: () => _confirmDelete(context),
                    // ),
                  ],
                ),
                if (inventoryItem.description != null &&
                    inventoryItem.description!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    inventoryItem.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textSecondary,
                      height: 1.4,
                    ),
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
