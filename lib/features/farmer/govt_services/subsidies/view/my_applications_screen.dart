import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';

import '../cubit/my_applications_cubit.dart';
import '../cubit/my_applications_state.dart';
import '../data/subsidy.dart';
import '../widgets/application_card.dart';
import '../widgets/subsidy_list_skeleton.dart';
import 'application_detail_args.dart';

class MyApplicationsScreen extends StatelessWidget {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppAppBar(title: l10n.subsidyMyApplications),
      body: BlocBuilder<MyApplicationsCubit, MyApplicationsState>(
        builder: (context, state) {
          return switch (state) {
            MyApplicationsLoading() => const SubsidyListSkeleton(),
            MyApplicationsFailure() => AppEmptyState(
                icon: Icons.error_outline,
                title: l10n.errorGeneric,
                actionLabel: l10n.commonRefresh,
                onAction: () => context.read<MyApplicationsCubit>().load(),
                actionIcon: Icons.refresh,
              ),
            MyApplicationsLoaded(:final applications) =>
              _list(context, l10n, applications),
          };
        },
      ),
    );
  }

  Widget _list(
    BuildContext context,
    AppLocalizations l10n,
    List<Subsidy> apps,
  ) {
    if (apps.isEmpty) {
      return AppEmptyState(
        icon: Icons.inbox_outlined,
        title: l10n.subsidyApplicationsEmptyTitle,
        description: l10n.subsidyApplicationsEmptyDesc,
      );
    }
    return RefreshIndicator(
      onRefresh: () => context.read<MyApplicationsCubit>().load(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: apps.length,
        itemBuilder: (_, i) {
          final s = apps[i];
          return ApplicationCard(
            subsidy: s,
            onTap: () => _openDetail(context, s),
          );
        },
      ),
    );
  }

  Future<void> _openDetail(BuildContext context, Subsidy s) async {
    final cubit = context.read<MyApplicationsCubit>();
    final withdrawn = await context.push<bool>(
      AppRoutePath.subsidyApplicationDetail,
      extra: ApplicationDetailArgs(subsidy: s),
    );
    if (withdrawn == true && s.id != null) cubit.removeApplication(s.id!);
  }
}
