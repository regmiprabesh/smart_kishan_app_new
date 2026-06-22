import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';

import '../cubit/my_requests_cubit.dart';
import '../cubit/my_requests_state.dart';
import '../data/subsidy_request.dart';
import '../widgets/request_card.dart';
import '../widgets/subsidy_list_skeleton.dart';
import 'request_detail_args.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(
        title: l10n.subsidyMyRequests,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.subsidyRequestNew,
            onPressed: () => _newRequest(context),
          ),
        ],
      ),
      body: BlocBuilder<MyRequestsCubit, MyRequestsState>(
        builder: (context, state) {
          return switch (state) {
            MyRequestsLoading() => const SubsidyListSkeleton(),
            MyRequestsFailure() => AppEmptyState(
                icon: Icons.error_outline,
                title: l10n.errorGeneric,
                actionLabel: l10n.commonRefresh,
                onAction: () => context.read<MyRequestsCubit>().load(),
                actionIcon: Icons.refresh,
              ),
            MyRequestsLoaded(:final requests) => _list(context, l10n, requests),
          };
        },
      ),
    );
  }

  Widget _list(
    BuildContext context,
    AppLocalizations l10n,
    List<SubsidyRequest> requests,
  ) {
    if (requests.isEmpty) {
      return AppEmptyState(
        icon: Icons.lightbulb_outline,
        title: l10n.subsidyRequestsEmptyTitle,
        description: l10n.subsidyRequestsEmptyDesc,
        actionLabel: l10n.subsidyRequestNew,
        onAction: () => _newRequest(context),
      );
    }
    return RefreshIndicator(
      onRefresh: () => context.read<MyRequestsCubit>().load(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (_, i) {
          final r = requests[i];
          return RequestCard(request: r, onTap: () => _openDetail(context, r));
        },
      ),
    );
  }

  Future<void> _newRequest(BuildContext context) async {
    final cubit = context.read<MyRequestsCubit>();
    final created = await context.push<bool>(AppRoutePath.requestSubsidy);
    if (created == true) cubit.load();
  }

  Future<void> _openDetail(BuildContext context, SubsidyRequest r) async {
    final cubit = context.read<MyRequestsCubit>();
    final cancelled = await context.push<bool>(
      AppRoutePath.subsidyRequestDetail,
      extra: RequestDetailArgs(request: r),
    );
    if (cancelled == true && r.id != null) cubit.removeRequest(r.id!);
  }
}
