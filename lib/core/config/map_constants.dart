// core/config/map_constants.dart
import 'package:latlong2/latlong.dart';

abstract final class MapConstants {
  static const tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const userAgent = 'com.example.smartKishan';
  static const osrmBase = 'https://router.project-osrm.org/route/v1/driving';
  static const nominatimBase = 'https://nominatim.openstreetmap.org/reverse';

  // Kathmandu fallback when user location isn't available.
  static const fallbackCenter = LatLng(27.7103, 85.3222);

  static const initialZoom = 13.0;
  static const minZoom = 5.0;
  static const maxZoom = 18.0;
  static const selectedZoom = 15.0;
}
