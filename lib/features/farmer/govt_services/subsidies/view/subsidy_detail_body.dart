import 'package:flutter/material.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/shared/ratings/ratings_config.dart';
import 'package:smart_kishan/shared/ratings/widgets/ratings_section.dart';
import 'package:smart_kishan/core/utils/formatters.dart';
import 'package:smart_kishan/features/farmer/govt_services/subsidies/widgets/subsidy_document_tile.dart';
import 'package:smart_kishan/features/farmer/govt_services/subsidies/widgets/subsidy_section_header.dart';

import '../data/subsidy.dart';
import '../subsidy_labels.dart';

class SubsidyDetailBody extends StatelessWidget {
  const SubsidyDetailBody({
    super.key,
    required this.subsidy,
    required this.onApply,
  });

  final Subsidy subsidy;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final s = subsidy;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context, l10n, s),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((s.description?.of(context) ?? '').isNotEmpty) ...[
                  SubsidySectionTitle(title: l10n.subsidyDescription),
                  const SizedBox(height: 8),
                  Text(
                    (s.description?.of(context) ?? ''),
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                if ((s.eligibilityCriteria?.of(context) ?? '').isNotEmpty) ...[
                  SubsidySectionTitle(title: l10n.subsidyEligibility),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      (s.eligibilityCriteria?.of(context) ?? ''),
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                _infoGrid(context, l10n, s),
                if (s.documents.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  SubsidySectionTitle(title: l10n.subsidyAdminDocuments),
                  const SizedBox(height: 8),
                  ...s.documents.map((d) => AdminDocumentTile(doc: d)),
                ],
                if (s.requiredDocuments.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  SubsidySectionTitle(title: l10n.subsidyRequiredDocuments),
                  const SizedBox(height: 8),
                  ...s.requiredDocuments.map(
                    (d) => RequiredDocumentTile(doc: d),
                  ),
                ],
                if (_hasLocation(s)) ...[
                  const SizedBox(height: 20),
                  SubsidySectionTitle(title: l10n.subsidyLocationDetails),
                  const SizedBox(height: 8),
                  _locationCard(context, l10n, s),
                ],
                const SizedBox(height: 28),
                RatingsSection(
                  config: RatingsConfig(
                    rateTitle: l10n.subsidyRateThis,
                    title: s.title?.of(context),
                    description: s.description?.of(context),
                    fallbackIcon: Icons.volunteer_activism_outlined,
                    suggestedTags: [
                      l10n.subsidyTagFastApproval,
                      l10n.subsidyTagHelpfulStaff,
                      l10n.subsidyTagClearProcess,
                      l10n.subsidyTagWellOrganized,
                      l10n.subsidyTagTooMuchPaperwork,
                      l10n.subsidyTagSlowResponse,
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                _applyButton(context, l10n, s),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _hasLocation(Subsidy s) =>
      s.province != null ||
      s.district != null ||
      s.municipality != null ||
      s.ward != null;

  Widget _header(BuildContext context, AppLocalizations l10n, Subsidy s) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (s.title?.of(context) ?? '').isEmpty
                ? l10n.subsidyUntitled
                : (s.title?.of(context) ?? ''),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _badge(
                subsidyTypeLabel(l10n, s.subsidyType),
                bg: Colors.white,
                fg: colors.primary,
              ),
              if (s.locationLevel != null)
                _badge(
                  subsidyLevelLabel(l10n, s.locationLevel),
                  bg: Colors.white.withValues(alpha: 0.25),
                  fg: Colors.white,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, {required Color bg, required Color fg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  Widget _infoGrid(BuildContext context, AppLocalizations l10n, Subsidy s) {
    final rows = <Widget>[
      if ((s.targetCropOrSector?.of(context) ?? '').isNotEmpty)
        _InfoRow(
          l10n.subsidyTargetSector,
          (s.targetCropOrSector?.of(context) ?? ''),
        ),
      if (s.fiscalYear != null)
        _InfoRow(l10n.subsidyFiscalYear, context.ld(s.fiscalYear!)),
      if (s.expectedBeneficiaries != null)
        _InfoRow(
          l10n.subsidyExpectedBeneficiaries,
          context.ld(s.expectedBeneficiaries!),
        ),
      if (s.budgetPerBeneficiary != null)
        _InfoRow(
          l10n.subsidyBudgetPerBeneficiary,
          '${l10n.currencySymbol} ${context.ld(s.budgetPerBeneficiary!)}',
        ),
      if (s.totalBudget != null)
        _InfoRow(
          l10n.subsidyTotalBudget,
          '${l10n.currencySymbol} ${context.ld(s.totalBudget!)}',
        ),
      if (s.deadline != null)
        _InfoRow(l10n.subsidyDeadline, context.shortDate(s.deadline)),
    ];
    return Column(children: rows);
  }

  Widget _locationCard(BuildContext context, AppLocalizations l10n, Subsidy s) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (s.province != null)
            _locationItem(
              context,
              Icons.map_outlined,
              l10n.subsidyProvince,
              s.province!.name?.of(context) ?? '',
            ),
          if (s.district != null)
            _locationItem(
              context,
              Icons.location_city_outlined,
              l10n.subsidyDistrict,
              s.district!.name?.of(context) ?? '',
            ),
          if (s.municipality != null)
            _locationItem(
              context,
              Icons.apartment_outlined,
              l10n.subsidyMunicipality,
              '${s.municipality!.name?.of(context) ?? ''}'
              '${s.municipality!.type != null ? ' (${s.municipality!.type})' : ''}',
            ),
          if (s.ward != null)
            _locationItem(
              context,
              Icons.home_outlined,
              l10n.subsidyWard,
              s.ward!.name?.of(context) ?? context.ld(s.ward!.wardNumber ?? ''),
            ),
        ],
      ),
    );
  }

  Widget _locationItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.primary),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13, color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _applyButton(BuildContext context, AppLocalizations l10n, Subsidy s) {
    final colors = context.colors;
    final disabled = s.hasApplied || s.isExpired;
    final label = s.hasApplied
        ? l10n.subsidyAlreadyApplied
        : s.isExpired
        ? l10n.subsidyExpired
        : l10n.subsidyApplyNow;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: disabled ? null : onApply,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
