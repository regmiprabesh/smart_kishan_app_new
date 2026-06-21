import 'package:smart_kishan/core/localization/app_localizations.dart';

/// Maps backend `subsidy_type` and `location_level` enum strings to localized
/// labels. Kept in one place so the card, detail, and request screens agree.
String subsidyTypeLabel(AppLocalizations l10n, String? type) {
  switch (type?.toLowerCase()) {
    case 'fertilizer':
      return l10n.subsidyTypeFertilizer;
    case 'equipment':
      return l10n.subsidyTypeEquipment;
    case 'training':
      return l10n.subsidyTypeTraining;
    case 'irrigation':
      return l10n.subsidyTypeIrrigation;
    case 'livestock':
      return l10n.subsidyTypeLivestock;
    case 'seeds':
      return l10n.subsidyTypeSeeds;
    case 'insurance':
      return l10n.subsidyTypeInsurance;
    case 'loan':
      return l10n.subsidyTypeLoan;
    case 'organic':
      return l10n.subsidyTypeOrganic;
    default:
      return l10n.subsidyTypeGeneral;
  }
}

String subsidyLevelLabel(AppLocalizations l10n, String? level) {
  switch (level?.toLowerCase()) {
    case 'central':
      return l10n.subsidyLevelCentral;
    case 'province':
      return l10n.subsidyLevelProvince;
    case 'district':
      return l10n.subsidyLevelDistrict;
    case 'municipality':
      return l10n.subsidyLevelMunicipality;
    case 'ward':
      return l10n.subsidyLevelWard;
    default:
      return level ?? '';
  }
}
