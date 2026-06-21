import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';
import 'package:smart_kishan/features/auth/cubit/session_cubit.dart';
import 'package:smart_kishan/features/auth/cubit/session_state.dart';
import 'package:smart_kishan/shared/models/user.dart';

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
    if (_hasLocation) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<SubsidyListCubit>().load(),
      );
    }
  }

  User? get _user {
    final s = context.read<SessionCubit>().state;
    return s is Authenticated ? s.user : null;
  }

  bool get _hasLocation {
    final u = _user;
    return u != null &&
        u.provinceId != null &&
        u.districtId != null &&
        u.municipalityId != null &&
        u.wardId != null;
  }

  void _openDetail(Subsidy s) => context.push(
        AppRoutePath.subsidyDetail,
        extra: SubsidyDetailArgs(subsidy: s),
      );

  void _openApply(Subsidy s) => context.push(
        AppRoutePath.subsidyApply,
        extra: SubsidyDetailArgs(subsidy: s),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppAppBar(
        title: l10n.subsidies,
        actions: [
          if (_hasLocation)
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: l10n.subsidyMyApplications,
              onPressed: () =>
                  context.push(AppRoutePath.mySubsidyApplications),
            ),
        ],
      ),
      floatingActionButton: _hasLocation
          ? FloatingActionButton.extended(
              onPressed: () => context.push(AppRoutePath.mySubsidyRequests),
              icon: const Icon(Icons.add),
              label: Text(l10n.subsidyRequestSubsidy),
            )
          : null,
      body: !_hasLocation
          ? SubsidyLocationRequired(
              onAddLocation: () => context.push(AppRoutePath.editProfile),
            )
          : BlocBuilder<SubsidyListCubit, SubsidyListState>(
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
                  SubsidyListLoaded(:final subsidies) =>
                    _list(context, l10n, subsidies),
                };
              },
            ),
    );
  }

  Widget _list(BuildContext context, AppLocalizations l10n,
      List<Subsidy> subsidies) {
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
