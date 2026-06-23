import 'package:smart_kishan/core/localization/app_localizations.dart';

String satisfactionLabel(AppLocalizations l10n, int rating) => switch (rating) {
  1 => l10n.ratingLabel1,
  2 => l10n.ratingLabel2,
  3 => l10n.ratingLabel3,
  4 => l10n.ratingLabel4,
  5 => l10n.ratingLabel5,
  _ => '',
};
