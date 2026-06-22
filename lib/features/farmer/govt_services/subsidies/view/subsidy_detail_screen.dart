import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';

import '../data/subsidy.dart';
import 'subsidy_detail_args.dart';
import 'subsidy_detail_body.dart';

/// Detail screen for a subsidy. The list already carries the full [Subsidy]
/// (info, documents, form fields), so detail is presentational — no fetch.
/// Stateful only to flip the Apply button to "Applied" on a successful
/// application, and to relay that up via [SubsidyDetailArgs.onApplied].
class SubsidyDetailScreen extends StatefulWidget {
  const SubsidyDetailScreen({super.key, required this.args});

  final SubsidyDetailArgs args;

  @override
  State<SubsidyDetailScreen> createState() => _SubsidyDetailScreenState();
}

class _SubsidyDetailScreenState extends State<SubsidyDetailScreen> {
  late Subsidy _subsidy = widget.args.subsidy;

  Future<void> _apply() async {
    final ok = await context.push<bool>(
      AppRoutePath.subsidyApply,
      extra: SubsidyDetailArgs(
        subsidy: _subsidy,
        onApplied: widget.args.onApplied,
      ),
    );
    if (ok == true && mounted) {
      setState(() => _subsidy = _subsidy.copyWith(hasApplied: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(title: l10n.subsidyDetails),
      body: SubsidyDetailBody(subsidy: _subsidy, onApply: _apply),
    );
  }
}
