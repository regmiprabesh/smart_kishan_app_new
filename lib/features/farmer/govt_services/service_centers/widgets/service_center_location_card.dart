import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_kishan/app/theme/app_theme.dart';
import 'package:smart_kishan/core/config/map_constants.dart';
import 'package:smart_kishan/core/localization/app_localizations.dart';
import 'package:smart_kishan/core/utils/launcher.dart';

import '../data/service_center.dart';

/// Non-interactive map preview with a marker; tapping (or the directions chip)
/// opens external maps directions to the center.
class ServiceCenterLocationCard extends StatelessWidget {
  const ServiceCenterLocationCard({super.key, required this.center});
  final ServiceCenter center;

  void _openDirections() =>
      launchExternal(MapConstants.directionsUrl(center.latitude, center.longitude));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final point = LatLng(center.latitude, center.longitude);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _openDirections,
            child: SizedBox(
              width: double.infinity,
              height: 180,
              child: Stack(
                children: [
                  IgnorePointer(
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: point,
                        initialZoom: MapConstants.selectedZoom,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: MapConstants.tileUrl,
                          userAgentPackageName: MapConstants.userAgent,
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: point,
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.location_pin,
                                color: colors.primary,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Material(
                      color: colors.surface,
                      elevation: 3,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: _openDirections,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.directions,
                                size: 16,
                                color: colors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                l10n.directions,
                                style: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
