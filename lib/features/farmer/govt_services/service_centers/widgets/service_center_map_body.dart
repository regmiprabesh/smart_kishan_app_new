import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/config/map_constants.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';

import '../cubit/service_center_list_cubit.dart';
import '../cubit/service_center_list_state.dart';
import '../data/service_center.dart';
import 'service_center_map_preview.dart';
import 'service_center_results_sheet.dart';
import 'service_center_type_style.dart';

/// The map view: tiles, markers, route polyline, recenter button, and the
/// nearby-results sheet / selected-center preview card.
class ServiceCenterMapBody extends StatelessWidget {
  const ServiceCenterMapBody({
    super.key,
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
