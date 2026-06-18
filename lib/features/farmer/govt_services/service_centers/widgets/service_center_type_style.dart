import 'package:flutter/material.dart';

import '../data/service_center.dart';

/// Maps a [ServiceCenterType]'s backend `color`/`icon` strings to Flutter
/// values. Kept as one small helper so markers, the detail header, and the
/// list rows all tint/iconify identically. Faithful to the old
/// `_getTypeColor` / `_getIconData` switch.
abstract final class ServiceCenterTypeStyle {
  /// Parse a "#RRGGBB" (or "#AARRGGBB") hex string into a [Color].
  /// Falls back to the app green if null/unparseable.
  static Color color(String? hex, {Color fallback = const Color(0xFF4CAF50)}) {
    if (hex == null || hex.isEmpty) return fallback;
    var h = hex.replaceFirst('#', '').trim();
    if (h.length == 6) h = 'FF$h'; // add full alpha
    final value = int.tryParse(h, radix: 16);
    return value == null ? fallback : Color(value);
  }

  /// Map the backend icon key to an [IconData]. Add cases as new types appear.
  static IconData icon(String? key) {
    switch (key) {
      case 'agriculture':
      case 'agri':
        return Icons.agriculture;
      case 'local_florist':
      case 'plant':
        return Icons.local_florist;
      case 'pets':
      case 'vet':
      case 'veterinary':
        return Icons.pets;
      case 'water_drop':
      case 'irrigation':
        return Icons.water_drop;
      case 'account_balance':
      case 'bank':
      case 'cooperative':
        return Icons.account_balance;
      case 'store':
      case 'market':
        return Icons.store;
      case 'science':
      case 'lab':
      case 'soil':
        return Icons.science;
      case 'warehouse':
      case 'storage':
        return Icons.warehouse;
      case 'location_city':
      case 'office':
        return Icons.location_city;
      default:
        return Icons.location_on;
    }
  }

  static Color of(ServiceCenterType? type) => color(type?.color);
  static IconData iconOf(ServiceCenterType? type) => icon(type?.icon);
}
