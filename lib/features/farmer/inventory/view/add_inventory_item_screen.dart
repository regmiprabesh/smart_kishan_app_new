import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_dropdown.dart';
import 'package:smart_kishan/core/widgets/app_field_card.dart';
import 'package:smart_kishan/core/widgets/app_text_field.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/features/farmer/inventory/cubit/inventory_state.dart';
import 'package:smart_kishan/features/farmer/inventory/data/inventory_item.dart';
import 'package:smart_kishan/features/farmer/inventory/view/inventory_item_args.dart';
import 'package:smart_kishan/shared/models/unit.dart';

/// Full-screen add / edit inventory item. Faithful to the original design:
/// each field sits in a white card with an icon-chip + label above it; stock
/// and unit share a row (grid); trade option is a 3-card selector
/// (sell / buy / both). Pops on success.
class AddInventoryItemScreen extends StatefulWidget {
  const AddInventoryItemScreen({super.key, required this.args});
  final InventoryItemArgs args;

  @override
  State<AddInventoryItemScreen> createState() => _AddInventoryItemScreenState();
}

class _AddInventoryItemScreenState extends State<AddInventoryItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _stock;
  late final TextEditingController _description;
  int? _unitId;
  int _isSellable = 1; // default: sell (बिक्री)
  bool _saving = false;

  bool get _isEdit => widget.args.inventoryItem != null;

  @override
  void initState() {
    super.initState();
    final p = widget.args.inventoryItem;
    _name = TextEditingController(text: p?.name ?? '');
    _stock = TextEditingController(text: p?.stock?.toString() ?? '');
    _description = TextEditingController(text: p?.description ?? '');
    _unitId = p?.unitId;
    _isSellable = p?.isSellable ?? 1;
  }

  @override
  void dispose() {
    _name.dispose();
    _stock.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final l10n = AppLocalizations.of(context)!;
    final cubit = widget.args.cubit;

    final inventoryItem = InventoryItem(
      id: widget.args.inventoryItem?.id,
      name: _name.text.trim(),
      stock: int.tryParse(_stock.text.trim()),
      unitId: _unitId,
      isSellable: _isSellable,
      description: _description.text.trim(),
    );

    final ok = _isEdit
        ? await cubit.update(inventoryItem)
        : await cubit.add(inventoryItem);

    if (!mounted) return;
    if (ok) {
      AppSnackbar.success(
        _isEdit
            ? l10n.inventoryItemUpdatedSuccessfully
            : l10n.inventoryItemAddedSuccessfully,
      );
      context.pop();
    } else {
      setState(() => _saving = false);
      AppSnackbar.error(l10n.errorGeneric);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Units come from the shared cubit's loaded state.
    final state = widget.args.cubit.state;
    final units = state is InventoryLoaded ? state.units : const <Unit>[];

    return Scaffold(
      appBar: AppAppBar(
        title: _isEdit ? l10n.inventoryItemUpdate : l10n.inventoryItemAdd,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Name ─────────────────────────────────────────
              AppFieldCard(
                icon: Icons.inventory_2_outlined,
                label: l10n.inventoryItemNameLabel,
                child: AppTextField(
                  controller: _name,
                  label: '',
                  showLabel: false,
                  hint: l10n.inventoryItemNameHint,
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return l10n.inventoryItemNameRequired;
                    if (value.length < 3) {
                      return l10n.inventoryItemNameInvalid;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),

              // ── Stock + Unit (grid) ──────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppFieldCard(
                      icon: Icons.pie_chart_outline,
                      label: l10n.inventoryItemStockLabel,
                      child: AppTextField(
                        label: '',
                        showLabel: false,
                        controller: _stock,
                        hint: l10n.inventoryItemStockHint,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? l10n.inventoryItemStockRequired
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppFieldCard(
                      icon: Icons.straighten,
                      label: l10n.inventoryItemUnitLabel,
                      child: AppDropdown<int>(
                        value: _unitId,
                        items: units.map((u) => u.id!).toList(),
                        itemLabel: (id) {
                          final unit = units.firstWhere((u) => u.id == id);
                          return unit.name?.of(context) ?? '';
                        },
                        hint: l10n.inventoryItemUnitLabel,
                        validator: (v) =>
                            v == null ? l10n.inventoryItemUnitRequired : null,
                        showLabel: false,
                        onChanged: (v) => setState(() => _unitId = v),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Description ──────────────────────────────────
              AppFieldCard(
                icon: Icons.description_outlined,
                label: l10n.inventoryItemDescriptionLabel,
                child: AppTextField(
                  label: '',
                  showLabel: false,
                  controller: _description,
                  hint: l10n.inventoryItemDescriptionHint,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                ),
              ),
              const SizedBox(height: 16),

              // ── Trade option (sell / buy / both) ─────────────
              AppFieldCard(
                icon: Icons.sync_alt,
                label: l10n.inventoryItemTradeOptionLabel,
                child: _TradeSelector(
                  selected: _isSellable,
                  onSelect: (v) => setState(() => _isSellable = v),
                ),
              ),
              const SizedBox(height: 28),

              AppPrimaryButton(
                label: _isEdit ? l10n.commonUpdate : l10n.commonAdd,
                isLoading: _saving,
                onPressed: _submit,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Trade option selector (sell / buy / both) ──────────────────────────────

class _TradeOption {
  const _TradeOption({
    required this.value,
    required this.label,
    required this.icon,
  });
  final int value; // isSellable: 1=sell, 2=buy, 3=both
  final String label;
  final IconData icon;
}

/// 3-card selector for isSellable. Selected card fills primary; others are
/// outlined. Matches the original बिक्री / खरिद / दुबै design.
class _TradeSelector extends StatelessWidget {
  const _TradeSelector({required this.selected, required this.onSelect});
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = [
      _TradeOption(
        value: 1,
        label: l10n.inventoryItemSell,
        icon: Icons.trending_up,
      ),
      _TradeOption(
        value: 2,
        label: l10n.inventoryItemBuy,
        icon: Icons.shopping_bag,
      ),
      _TradeOption(
        value: 3,
        label: l10n.inventoryItemBoth,
        icon: Icons.swap_horiz,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: _TradeCard(
              option: options[i],
              isSelected: selected == options[i].value,
              onTap: () => onSelect(options[i].value),
            ),
          ),
        ],
      ],
    );
  }
}

class _TradeCard extends StatelessWidget {
  const _TradeCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });
  final _TradeOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surfaceAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
          ),
        ),
        child: Column(
          children: [
            Icon(
              option.icon,
              size: 26,
              color: isSelected ? Colors.white : colors.iconSecondary,
            ),
            const SizedBox(height: 6),
            Text(
              option.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
