import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';
import 'package:smart_kishan/features/auth/cubit/session_cubit.dart';
import 'package:smart_kishan/features/auth/cubit/session_state.dart';

import '../cubit/subsidy_list_cubit.dart';
import '../cubit/subsidy_list_state.dart';
import '../data/subsidy.dart';
import '../widgets/subsidy_card.dart';
import '../widgets/subsidy_list_skeleton.dart';
import '../widgets/subsidy_location_required.dart';
import 'subsidy_detail_args.dart';

class SubsidyListScreen extends StatefulWidget {
  const SubsidyListScreen({super.key});

  @override
  State<SubsidyListScreen> createState() => _SubsidyListScreenState();
}

class _SubsidyListScreenState extends State<SubsidyListScreen> {
  @override
  void initState() {
    super.initState();
    // The list always loads — the backend returns every approved subsidy when
    // the user has no location, and the location-scoped set once they do.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<SubsidyListCubit>().load(),
    );
  }

  bool get _hasLocation =>
      userHasSubsidyLocation(context.read<SessionCubit>().state);

  /// Captures the cubit now so the deferred onApplied callback (fired when the
  /// application succeeds, screens later) doesn't touch a stale context.
  VoidCallback? _onApplied(Subsidy s) {
    if (s.id == null) return null;
    final cubit = context.read<SubsidyListCubit>();
    final id = s.id!;
    return () => cubit.markApplied(id);
  }

  void _openDetail(Subsidy s) async {
    final cubit = context.read<SubsidyListCubit>();
    await context.push(
      AppRoutePath.subsidyDetail,
      extra: SubsidyDetailArgs(subsidy: s, onApplied: _onApplied(s)),
    );
    // Reflect any rating made on the detail screen (separate route) on return.
    await cubit.refresh();
  }

  /// Apply gate: browsing needs no location, applying does. Without one we
  /// prompt the user to add it. On success the session updates, which the
  /// BlocListener below catches to reload the now location-scoped list — the
  /// user lands back here with the irrelevant subsidies gone, then re-taps
  /// Apply on a relevant one.
  Future<void> _openApply(Subsidy s) async {
    if (!_hasLocation) {
      await ensureSubsidyLocation(context);
      return;
    }
    if (!mounted) return;
    context.push(
      AppRoutePath.subsidyApply,
      extra: SubsidyDetailArgs(subsidy: s, onApplied: _onApplied(s)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppAppBar(
        title: l10n.subsidies,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: l10n.subsidyMyApplications,
            onPressed: () => context.push(AppRoutePath.mySubsidyApplications),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutePath.mySubsidyRequests),
        icon: const Icon(Icons.add),
        label: Text(l10n.subsidyRequestSubsidy),
      ),
      body: BlocListener<SessionCubit, SessionState>(
        // When a location is added (e.g. from the apply gate), the user returns
        // to a freshly filtered list with irrelevant subsidies removed.
        listenWhen: (prev, curr) =>
            userHasSubsidyLocation(prev) != userHasSubsidyLocation(curr),
        listener: (context, state) {
          if (userHasSubsidyLocation(state)) {
            context.read<SubsidyListCubit>().load();
          }
        },
        child: BlocBuilder<SubsidyListCubit, SubsidyListState>(
          builder: (context, state) {
            return switch (state) {
              SubsidyListLoading() => const SubsidyListSkeleton(),
              SubsidyListFailure() => AppEmptyState(
                icon: Icons.error_outline,
                title: l10n.errorGeneric,
                actionLabel: l10n.commonRefresh,
                actionIcon: Icons.refresh,
                onAction: () => context.read<SubsidyListCubit>().load(),
              ),
              SubsidyListLoaded(:final subsidies) => _list(
                context,
                l10n,
                subsidies,
              ),
            };
          },
        ),
      ),
    );
  }

  Widget _list(
    BuildContext context,
    AppLocalizations l10n,
    List<Subsidy> subsidies,
  ) {
    if (subsidies.isEmpty) {
      return AppEmptyState(
        icon: Icons.card_giftcard_outlined,
        title: l10n.subsidyNoneAvailable,
        actionLabel: l10n.commonRefresh,
        actionIcon: Icons.refresh,
        onAction: () => context.read<SubsidyListCubit>().load(),
      );
    }
    return RefreshIndicator(
      onRefresh: () => context.read<SubsidyListCubit>().load(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        itemCount: subsidies.length,
        itemBuilder: (_, i) {
          final s = subsidies[i];
          return SubsidyCard(
            subsidy: s,
            onTap: () => _openDetail(s),
            onRate: () => _openDetail(s),
            onApply: () => _openApply(s),
          );
        },
      ),
    );
  }
}
