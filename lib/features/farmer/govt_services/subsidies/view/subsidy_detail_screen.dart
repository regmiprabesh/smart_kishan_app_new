import 'package:flutter/material.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';

import '../data/subsidy.dart';
import 'subsidy_detail_body.dart';

/// Detail screen for a subsidy. The list already carries the full [Subsidy]
/// (info, documents, form fields), so detail is presentational — no fetch.
class SubsidyDetailScreen extends StatelessWidget {
  const SubsidyDetailScreen({super.key, required this.subsidy});

  final Subsidy subsidy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(title: l10n.subsidyDetails),
      body: SubsidyDetailBody(subsidy: subsidy),
    );
  }
}
