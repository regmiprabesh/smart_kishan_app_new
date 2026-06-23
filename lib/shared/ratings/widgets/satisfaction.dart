import 'package:smart_kishan/core/localization/app_localizations.dart';

/// Emoji + short satisfaction label for a 1–5 rating, shown live on the rate
/// page. Labels reuse the existing ratingLabel1..5 strings.
String satisfactionEmoji(int rating) => switch (rating) {
  1 => '😞',
  2 => '😕',
  3 => '🙂',
  4 => '😀',
  5 => '🤩',
  _ => '⭐',
};

String satisfactionLabel(AppLocalizations l10n, int rating) => switch (rating) {
  1 => l10n.ratingLabel1,
  2 => l10n.ratingLabel2,
  3 => l10n.ratingLabel3,
  4 => l10n.ratingLabel4,
  5 => l10n.ratingLabel5,
  _ => '',
};
