import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/core/di/injector.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/shared/ratings/cubit/ratings_cubit.dart';
import 'package:smart_kishan/shared/ratings/cubit/ratings_state.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/features/auth/cubit/session_cubit.dart';

import '../data/subsidy.dart';
import '../data/subsidy_ratings_repository.dart';
import '../data/subsidy_repository.dart';
import '../widgets/subsidy_location_required.dart';
import 'subsidy_detail_args.dart';
import 'subsidy_detail_body.dart';

/// Detail screen for a subsidy. The list already carries the full [Subsidy]
/// (info, documents, form fields), so the core detail is presentational — no
/// fetch. Ratings (other farmers' reviews + the user's own) are loaded lazily
/// via the shared [RatingsCubit]. Stateful to flip Apply to "Applied" on success.
class SubsidyDetailScreen extends StatefulWidget {
  const SubsidyDetailScreen({super.key, required this.args});

  final SubsidyDetailArgs args;

  @override
  State<SubsidyDetailScreen> createState() => _SubsidyDetailScreenState();
}

class _SubsidyDetailScreenState extends State<SubsidyDetailScreen> {
  late Subsidy _subsidy = widget.args.subsidy;

  Future<void> _apply() async {
    // Browsing is open to everyone, but applying is location-scoped. If the
    // user has no location, prompt them to add it; on success we pop back to
    // the subsidies list, which reloads itself (now filtered to their area).
    if (!userHasSubsidyLocation(context.read<SessionCubit>().state)) {
      final added = await ensureSubsidyLocation(context);
      if (added && mounted) context.pop();
      return;
    }

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
    return BlocProvider(
      create: (_) => RatingsCubit(
        SubsidyRatingsRepository(sl<SubsidyRepository>(), _subsidy.id ?? 0),
        seedAverage: _subsidy.averageRating,
        seedTotal: _subsidy.totalRatings,
      )..load(),
      child: BlocListener<RatingsCubit, RatingsState>(
        listenWhen: (p, c) => p.average != c.average || p.total != c.total,
        listener: (_, s) => widget.args.onRated?.call(s.average, s.total),
        child: Scaffold(
          appBar: AppAppBar(title: l10n.subsidyDetails),
          body: SubsidyDetailBody(subsidy: _subsidy, onApply: _apply),
        ),
      ),
    );
  }
}
