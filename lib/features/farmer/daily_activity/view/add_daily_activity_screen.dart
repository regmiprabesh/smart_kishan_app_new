import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/app_snackbar.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_confirm_dialog.dart';
import 'package:smart_kishan/core/widgets/app_dropdown.dart';
import 'package:smart_kishan/core/widgets/app_field_card.dart';
import 'package:smart_kishan/core/widgets/app_primary_button.dart';
import 'package:smart_kishan/core/widgets/app_text_field.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/features/farmer/daily_activity/cubit/daily_activity_cubit.dart';
import 'package:smart_kishan/features/farmer/daily_activity/cubit/daily_activity_state.dart';
import 'package:smart_kishan/features/farmer/daily_activity/data/activity.dart';
import 'package:smart_kishan/features/farmer/daily_activity/view/activity_args.dart';
import 'package:smart_kishan/features/farmer/inventory/data/inventory_item.dart';

class AddDailyActivityScreen extends StatefulWidget {
  const AddDailyActivityScreen({super.key, required this.args});
  final ActivityArgs args;

  @override
  State<AddDailyActivityScreen> createState() => _AddDailyActivityScreenState();
}

class _AddDailyActivityScreenState extends State<AddDailyActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _quantity;
  late final TextEditingController _amount; // cost (Buy) or price (Sell)

  String _type = 'Buy';
  int? _inventoryItemId;
  bool _saving = false;

  bool get _isEdit => widget.args.activity != null;
  bool get _needsInventoryItem => _type == 'Buy' || _type == 'Sell';

  late final TextEditingController _otherIncome;
  late final TextEditingController _otherExpense;

  @override
  void initState() {
    super.initState();
    final a = widget.args.activity;
    _title = TextEditingController(text: a?.title ?? '');
    _description = TextEditingController(text: a?.description ?? '');
    _quantity = TextEditingController(text: a?.quantity?.toString() ?? '');
    _type = a?.type ?? 'Buy';
    _inventoryItemId = a?.inventoryItemId;
    // amount mirrors expense (Buy) or income (Sell) depending on type.
    final amount = _type == 'Sell' ? a?.income : a?.expense;
    _amount = TextEditingController(text: amount?.toString() ?? '');

    _otherIncome = TextEditingController(
      text: _type == 'Other' ? (a?.income?.toString() ?? '') : '',
    );
    _otherExpense = TextEditingController(
      text: _type == 'Other' ? (a?.expense?.toString() ?? '') : '',
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _quantity.dispose();
    _amount.dispose();
    _otherIncome.dispose();
    _otherExpense.dispose();
    super.dispose();
  }

  void _onTypeChanged(String type) {
    setState(() {
      _type = type;
      if (type == 'Other') {
        // Other has no inventory item / quantity / single amount.
        _inventoryItemId = null;
        _quantity.clear();
        _amount.clear();
      } else {
        // Buy/Sell don't use the dual income/expense fields.
        _otherIncome.clear();
        _otherExpense.clear();
      }
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final quantity = int.tryParse(_quantity.text.trim());

    // Buy/Sell with a real item + quantity → ask whether stock should move.
    // Other, or a Buy/Sell missing either field, skips the prompt entirely
    // (there's nothing meaningful to adjust).
    var adjustStock = false;
    if (_needsInventoryItem && _inventoryItemId != null && quantity != null) {
      final confirmed = await AppConfirmDialog.show(
        context,
        title: l10n.dailyActivityAdjustStockTitle,
        message: _type == 'Sell'
            ? l10n.dailyActivityAdjustStockSellMessage(quantity)
            : l10n.dailyActivityAdjustStockBuyMessage(quantity),
        confirmLabel: l10n.commonYes,
        cancelLabel: l10n.commonNo,
      );
      if (!mounted) return;
      adjustStock = confirmed;
    }

    setState(() => _saving = true);
    final cubit = widget.args.cubit;

    // Route amounts by type:
    //   Buy   → expense (required)
    //   Sell  → income  (required)
    //   Other → both optional
    double? expense;
    double? income;
    if (_type == 'Buy') {
      expense = double.tryParse(_amount.text.trim());
    } else if (_type == 'Sell') {
      income = double.tryParse(_amount.text.trim());
    } else {
      expense = double.tryParse(_otherExpense.text.trim());
      income = double.tryParse(_otherIncome.text.trim());
    }

    final activity = Activity(
      id: widget.args.activity?.id,
      title: _title.text.trim(),
      description: _description.text.trim(),
      type: _type,
      inventoryItemId: _needsInventoryItem ? _inventoryItemId : null,
      quantity: _needsInventoryItem
          ? int.tryParse(_quantity.text.trim())
          : null,
      expense: expense,
      income: income,
      adjustStock: adjustStock,
    );

    final result = _isEdit
        ? await cubit.update(activity)
        : await cubit.add(activity);

    if (!mounted) return;
    if (result.success) {
      AppSnackbar.success(
        _isEdit
            ? l10n.dailyActivityUpdatedSuccessfully
            : l10n.dailyActivityAddedSuccessfully,
      );
      context.pop();
    } else {
      setState(() => _saving = false);
      AppSnackbar.error(_messageFor(context, l10n, result));
    }
  }

  /// Turns a failed [ActivitySaveResult] into a localized string. Known
  /// reasonKeys map to proper en/ne copy; anything else falls back to the
  /// server's plain message (already in whatever language it responded in)
  /// or the generic error string as a last resort.
  ///
  /// Numbers are passed through context.ld(...) before interpolation —
  /// ICU placeholder substitution does NOT localize digits on its own
  /// (see AppFormatters), so without this a Nepali sentence would still
  /// show "205" in ASCII instead of "२०५".
  String _messageFor(
    BuildContext context,
    AppLocalizations l10n,
    ActivitySaveResult result,
  ) {
    final params = result.reasonParams;
    switch (result.reasonKey) {
      case 'insufficient_stock':
        final itemName = params['item_name']?.toString() ?? '';
        final requested = (params['requested'] as num?)?.toInt() ?? 0;
        final available = (params['available'] as num?)?.toInt() ?? 0;
        return l10n.dailyActivityInsufficientStock(
          itemName,
          context.ld(requested),
          context.ld(available),
        );
      default:
        return result.fallbackMessage ?? l10n.errorGeneric;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // InventoryItems come from the shared cubit's loaded state.
    final state = widget.args.cubit.state;
    final inventoryItems = state is DailyActivityLoaded
        ? state.inventoryItems
        : const <InventoryItem>[];

    return Scaffold(
      appBar: AppAppBar(
        title: _isEdit ? l10n.dailyActivityUpdate : l10n.dailyActivityAdd,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              AppFieldCard(
                icon: Icons.title,
                label: l10n.dailyActivityTitleLabel,
                child: AppTextField(
                  controller: _title,
                  label: '',
                  showLabel: false,
                  hint: l10n.dailyActivityTitleHint,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? l10n.dailyActivityTitleRequired
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              AppFieldCard(
                icon: Icons.description_outlined,
                label: l10n.dailyActivityDescriptionLabel,
                child: AppTextField(
                  controller: _description,
                  label: '',
                  showLabel: false,
                  hint: l10n.dailyActivityDescriptionHint,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                ),
              ),
              const SizedBox(height: 16),

              // Type selector (Buy / Sell / Other)
              AppFieldCard(
                icon: Icons.category_outlined,
                label: l10n.dailyActivityTypeLabel,
                child: _TypeSelector(selected: _type, onSelect: _onTypeChanged),
              ),
              const SizedBox(height: 16),

              // Type-conditional fields (Buy/Sell only)
              if (_needsInventoryItem) ...[
                AppFieldCard(
                  icon: Icons.inventory_2_outlined,
                  label: l10n.dailyActivityInventoryItemLabel,
                  child: AppDropdown<int>(
                    value: _inventoryItemId,
                    items: inventoryItems.map((p) => p.id!).toList(),
                    itemLabel: (id) =>
                        inventoryItems.firstWhere((p) => p.id == id).name ?? '',
                    hint: l10n.dailyActivityInventoryItemHint,
                    showLabel: false,
                    validator: (v) => v == null
                        ? l10n.dailyActivityInventoryItemRequired
                        : null,
                    onChanged: (v) => setState(() => _inventoryItemId = v),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppFieldCard(
                        icon: Icons.numbers,
                        label: l10n.dailyActivityQuantityLabel,
                        child: AppTextField(
                          controller: _quantity,
                          key: ValueKey('quantity_$_type'),
                          label: '',
                          showLabel: false,
                          hint: l10n.dailyActivityQuantityHint,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? l10n.dailyActivityQuantityRequired
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppFieldCard(
                        icon: _type == 'Sell'
                            ? Icons.trending_up
                            : Icons.trending_down,
                        label: _type == 'Sell'
                            ? l10n.dailyActivitySalePriceLabel
                            : l10n.dailyActivityCostPriceLabel,
                        child: AppTextField(
                          controller: _amount,
                          key: ValueKey('amount_$_type'),
                          label: '',
                          showLabel: false,
                          hint: l10n.dailyActivityAmountHint,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? l10n.dailyActivityAmountRequired
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              // Type-conditional fields (Other only): optional expense + income.
              if (_type == 'Other') ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppFieldCard(
                        icon: Icons.trending_down,
                        label: l10n.dailyActivityExpenseLabel,
                        child: AppTextField(
                          controller: _otherExpense,
                          label: '',
                          showLabel: false,
                          hint: l10n.dailyActivityAmountHint,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                          // optional — no validator ("if any")
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppFieldCard(
                        icon: Icons.trending_up,
                        label: l10n.dailyActivityIncomeLabel,
                        child: AppTextField(
                          controller: _otherIncome,
                          label: '',
                          showLabel: false,
                          hint: l10n.dailyActivityAmountHint,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                          // optional — no validator
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 12),
              AppPrimaryButton(
                label: _isEdit ? l10n.commonUpdate : l10n.commonAdd,
                isLoading: _saving,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Type selector (Buy / Sell / Other) ─────────────────────────────────────

class _TypeOption {
  const _TypeOption({
    required this.value,
    required this.label,
    required this.icon,
  });
  final String value;
  final String label;
  final IconData icon;
}

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({required this.selected, required this.onSelect});
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = [
      _TypeOption(
        value: 'Buy',
        label: l10n.dailyActivityBuy,
        icon: Icons.shopping_bag,
      ),
      _TypeOption(
        value: 'Sell',
        label: l10n.dailyActivitySell,
        icon: Icons.trending_up,
      ),
      _TypeOption(
        value: 'Other',
        label: l10n.dailyActivityOther,
        icon: Icons.more_horiz,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: _TypeCard(
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

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });
  final _TypeOption option;
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
              size: 24,
              color: isSelected ? Colors.white : colors.iconSecondary,
            ),
            const SizedBox(height: 6),
            Text(
              option.label,
              style: TextStyle(
                fontSize: 12,
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
