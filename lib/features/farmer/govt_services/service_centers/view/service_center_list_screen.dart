import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_search_field.dart';

import '../cubit/service_center_list_cubit.dart';
import '../cubit/service_center_list_state.dart';
import '../data/service_center.dart';
import '../widgets/service_center_category_chips.dart';
import '../widgets/service_center_filter_sheet.dart';
import '../widgets/service_center_list_body.dart';
import '../widgets/service_center_list_skeleton.dart';
import '../widgets/service_center_map_body.dart';
import 'service_center_detail_args.dart';

class ServiceCenterListScreen extends StatefulWidget {
  const ServiceCenterListScreen({super.key});

  @override
  State<ServiceCenterListScreen> createState() =>
      _ServiceCenterListScreenState();
}

class _ServiceCenterListScreenState extends State<ServiceCenterListScreen> {
  final _searchController = TextEditingController();
  final _mapController = MapController();

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _openDetail(ServiceCenter center) {
    final cubit = context.read<ServiceCenterListCubit>();
    context.push(
      AppRoutePath.serviceCenterDetail,
      extra: ServiceCenterDetailArgs(
        id: center.id,
        onRated: (average, total) =>
            cubit.updateAggregate(center.id, average, total),
      ),
    );
  }

  Future<void> _openFilters(
    BuildContext context,
    ServiceCenterListLoaded state,
  ) async {
    final result = await ServiceCenterFilterSheet.show(
      context,
      query: state.query,
    );
    if (result == null || !context.mounted) return;
    context.read<ServiceCenterListCubit>().applyFilters(
      typeId: result.typeId,
      clearType: result.typeId == null,
      sortBy: result.sortBy,
      radius: result.radius,
      featuredOnly: result.featuredOnly,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppAppBar(
        title: l10n.serviceCenters,
        actions: [
          BlocBuilder<ServiceCenterListCubit, ServiceCenterListState>(
            builder: (context, state) {
              if (state is! ServiceCenterListLoaded) {
                return const SizedBox.shrink();
              }
              final isMap = state.view == ServiceCenterView.map;
              return Row(
                children: [
                  // Single toggle: shows the icon of the OTHER view.
                  IconButton(
                    tooltip: isMap ? l10n.listView : l10n.mapView,
                    icon: HugeIcon(
                      icon: isMap
                          ? HugeIcons.strokeRoundedListChevronsDownUp
                          : HugeIcons.strokeRoundedMaping,
                    ),
                    onPressed: () =>
                        context.read<ServiceCenterListCubit>().toggleView(
                          isMap
                              ? ServiceCenterView.list
                              : ServiceCenterView.map,
                        ),
                  ),
                  IconButton(
                    tooltip: l10n.filters,
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedFilterHorizontal,
                    ),
                    onPressed: () => _openFilters(context, state),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ServiceCenterListCubit, ServiceCenterListState>(
        builder: (context, state) {
          return switch (state) {
            ServiceCenterListLoading() => Column(
              children: [const Expanded(child: ServiceCenterListSkeleton())],
            ),
            ServiceCenterListFailure(:final message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.textSecondary),
                ),
              ),
            ),
            ServiceCenterListLoaded() => _Loaded(
              state: state,
              searchController: _searchController,
              mapController: _mapController,
              onOpenDetail: _openDetail,
            ),
          };
        },
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({
    required this.state,
    required this.searchController,
    required this.mapController,
    required this.onOpenDetail,
  });

  final ServiceCenterListLoaded state;
  final TextEditingController searchController;
  final MapController mapController;
  final void Function(ServiceCenter) onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<ServiceCenterListCubit>();

    // Search + category chips are shared chrome above both views.
    final chrome = ColoredBox(
      color: context.colors.surface,
      child: Column(
        children: [
          AppSearchField(
            hintText: l10n.searchServiceCentersHint,
            controller: searchController,
            onChanged: cubit.search,
          ),
          ServiceCenterCategoryChips(
            types: state.types,
            selectedTypeId: state.query.typeId,
            onSelected: cubit.setType,
          ),
          if (state.refreshing) const LinearProgressIndicator(minHeight: 2),
        ],
      ),
    );
    if (state.view == ServiceCenterView.list) {
      return Column(
        children: [
          chrome,
          Expanded(
            child: ServiceCenterListBody(
              state: state,
              onOpenDetail: onOpenDetail,
            ),
          ),
        ],
      );
    }

    // Map view: chrome on top, map fills the rest with overlays.
    return Column(
      children: [
        chrome,
        Expanded(
          child: ServiceCenterMapBody(
            state: state,
            mapController: mapController,
            onOpenDetail: onOpenDetail,
          ),
        ),
      ],
    );
  }
}
