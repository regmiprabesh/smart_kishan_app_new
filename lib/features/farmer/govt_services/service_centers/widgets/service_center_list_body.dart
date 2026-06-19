import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';

import '../cubit/service_center_list_cubit.dart';
import '../cubit/service_center_list_state.dart';
import '../data/service_center.dart';
import 'service_center_card.dart';

/// The scrollable list of service-center cards (with pull-to-refresh and an
/// empty state).
class ServiceCenterListBody extends StatelessWidget {
  const ServiceCenterListBody({
    super.key,
    required this.state,
    required this.onOpenDetail,
  });

  final ServiceCenterListLoaded state;
  final void Function(ServiceCenter) onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<ServiceCenterListCubit>();

    if (state.centers.isEmpty) {
      return AppEmptyState(
        icon: Icons.location_off,
        title: l10n.noServiceCentersFound,
        description: l10n.tryAdjustingFilters,
        actionLabel: l10n.commonRefresh,
        actionIcon: Icons.refresh,
        onAction: () => cubit.refresh(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => cubit.refresh(),
      child: state.centers.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.6,
                  child: AppEmptyState(
                    icon: Icons.location_off,
                    title: l10n.noServiceCentersFound,
                    description: l10n.tryAdjustingFilters,
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: state.centers.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, i) {
                final center = state.centers[i];
                return ServiceCenterCard(
                  center: center,
                  onViewOnMap: () {
                    final c = context.read<ServiceCenterListCubit>();
                    c.toggleView(ServiceCenterView.map);
                    c.selectCenter(center);
                  },
                  onViewDetail: () => onOpenDetail(center),
                );
              },
            ),
    );
  }
}
