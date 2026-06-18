import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_kishan/app/router/app_routes.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/config/map_constants.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/widgets/app_bar.dart';
import 'package:smart_kishan/core/widgets/app_empty_state.dart';
import 'package:smart_kishan/features/farmer/govt_services/service_centers/view/service_center_list_skeleton.dart';
import 'package:smart_kishan/features/farmer/govt_services/service_centers/widgets/service_center_map_preview.dart';

import '../cubit/service_center_list_cubit.dart';
import '../cubit/service_center_list_state.dart';
import '../data/service_center.dart';
import '../widgets/service_center_card.dart';
import '../widgets/service_center_category_chips.dart';
import '../widgets/service_center_filter_sheet.dart';
import '../widgets/service_center_results_sheet.dart';
import '../widgets/service_center_type_style.dart';
import 'service_center_detail_args.dart';

/// Service-center directory. Search + category chips are always visible; the
/// app-bar toggle flips between the list and the flutter_map (OSM) view. On the
/// map, a draggable sheet lists the top centers for the active filter, tapping a
/// marker shows a route + preview card. The cubit owns all data/query state.
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
    context.push(
      AppRoutePath.serviceCenterDetail,
      extra: ServiceCenterDetailArgs(id: center.id),
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
    final cubit = context.read<ServiceCenterListCubit>();

    // Search + category chips are shared chrome above both views.
    final chrome = ColoredBox(
      color: context.colors.surface,
      child: Column(
        children: [
          _SearchBar(controller: searchController, onChanged: cubit.search),
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
            child: _ListBody(state: state, onOpenDetail: onOpenDetail),
          ),
        ],
      );
    }

    // Map view: chrome on top, map fills the rest with overlays.
    return Column(
      children: [
        chrome,
        Expanded(
          child: _MapBody(
            state: state,
            mapController: mapController,
            onOpenDetail: onOpenDetail,
          ),
        ),
      ],
    );
  }
}

class _ListBody extends StatelessWidget {
  const _ListBody({required this.state, required this.onOpenDetail});

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

class _MapBody extends StatelessWidget {
  const _MapBody({
    required this.state,
    required this.mapController,
    required this.onOpenDetail,
  });

  final ServiceCenterListLoaded state;
  final MapController mapController;
  final void Function(ServiceCenter) onOpenDetail;

  /// The sheet lists whatever the active sort produced — so the title reflects
  /// the sort rather than always claiming "nearest". Default sort is distance.
  String _sheetTitle(BuildContext context, String sortBy) {
    final l10n = AppLocalizations.of(context)!;
    return switch (sortBy) {
      'distance' => l10n.top5ByDistance,
      'name' => l10n.top5ByName,
      'rating' => l10n.top5ByRating,
      'newest' => l10n.top5Newest,
      _ => l10n.serviceCenters,
    };
  }

  void _fitToRoute(ServiceCenterListLoaded state) {
    final user = state.userLocation;
    final sel = state.selected;
    if (user == null || sel == null) return;

    final bounds = LatLngBounds(
      LatLng(
        user.latitude < sel.latitude ? user.latitude : sel.latitude,
        user.longitude < sel.longitude ? user.longitude : sel.longitude,
      ),
      LatLng(
        user.latitude > sel.latitude ? user.latitude : sel.latitude,
        user.longitude > sel.longitude ? user.longitude : sel.longitude,
      ),
    );

    mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        // Extra bottom padding so the route isn't hidden behind the preview card.
        padding: const EdgeInsets.fromLTRB(60, 80, 60, 220),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ServiceCenterListCubit>();
    final center = state.userLocation ?? MapConstants.fallbackCenter;

    return BlocListener<ServiceCenterListCubit, ServiceCenterListState>(
      // Fit the camera once, when the route transitions from empty → loaded.
      listenWhen: (prev, curr) {
        final p = prev is ServiceCenterListLoaded ? prev.routePoints : const [];
        final c = curr is ServiceCenterListLoaded ? curr.routePoints : const [];
        return p.isEmpty && c.isNotEmpty;
      },
      listener: (context, state) {
        if (state is ServiceCenterListLoaded) _fitToRoute(state);
      },
      child: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: MapConstants.initialZoom,
              minZoom: MapConstants.minZoom,
              maxZoom: MapConstants.maxZoom,
              onTap: (_, _) => cubit.clearSelection(),
            ),
            children: [
              TileLayer(
                urlTemplate: MapConstants.tileUrl,
                userAgentPackageName: MapConstants.userAgent,
              ),
              if (state.routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: state.routePoints,
                      color: context.colors.info,
                      strokeWidth: 4,
                      borderColor: Colors.white,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              if (state.userLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: state.userLocation!,
                      width: 22,
                      height: 22,
                      child: const _UserDot(),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: state.centers
                    // While a center is selected, show only that one marker.
                    .where(
                      (c) =>
                          state.selectedId == null || state.selectedId == c.id,
                    )
                    .map((c) {
                      final selected = state.selectedId == c.id;
                      final color = ServiceCenterTypeStyle.of(c.type);
                      return Marker(
                        point: LatLng(c.latitude, c.longitude),
                        width: selected ? 50 : 40,
                        height: selected ? 50 : 40,
                        child: GestureDetector(
                          onTap: () {
                            cubit.selectCenter(c);
                            mapController.move(
                              LatLng(c.latitude, c.longitude),
                              MapConstants.selectedZoom,
                            );
                          },
                          child: _MapMarker(
                            color: color,
                            icon: ServiceCenterTypeStyle.iconOf(c.type),
                            selected: selected,
                          ),
                        ),
                      );
                    })
                    .toList(),
              ),
            ],
          ),

          // Recenter on the user.
          if (state.userLocation != null)
            Positioned(
              right: 16,
              bottom: 100,
              child: FloatingActionButton.small(
                heroTag: 'sc_recenter',
                backgroundColor: context.colors.surface,
                foregroundColor: context.colors.primary,
                elevation: 3,
                onPressed: () => mapController.move(
                  state.userLocation!,
                  MapConstants.selectedZoom,
                ),
                child: const Icon(CupertinoIcons.location_fill),
              ),
            ),

          // Nothing selected → nearby sheet; marker tapped → route preview card.
          if (state.selected == null)
            ServiceCenterNearbySheet(
              centers: state.centers,
              title: _sheetTitle(context, state.query.sortBy),
              onTapCenter: (c) {
                cubit.selectCenter(c);
                mapController.move(
                  LatLng(c.latitude, c.longitude),
                  MapConstants.selectedZoom,
                );
              },
              onOpenDetail: onOpenDetail,
            )
          else
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: ServiceCenterMapPreview(
                center: state.selected!,
                routeLoading: state.routeLoading,
                hasRoute: state.routePoints.isNotEmpty,
                onClose: cubit.clearSelection,
                onOpenDetail: () => onOpenDetail(state.selected!),
              ),
            ),
        ],
      ),
    );
  }
}
// ── shared small pieces ─────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    this.onChanged,
    this.enabled = true,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: l10n.searchServiceCentersHint,
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: colors.surfaceAlt,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({
    required this.color,
    required this.icon,
    required this.selected,
  });

  final Color color;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: selected ? 3 : 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: selected ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: selected ? 24 : 20),
    );
  }
}

class _UserDot extends StatelessWidget {
  const _UserDot();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.info,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: context.colors.info.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
