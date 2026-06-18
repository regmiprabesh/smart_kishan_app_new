import 'package:smart_kishan/app/router/app_routes.dart';

abstract final class AppMode {
  static const String farmer = 'farmer';
  static const String buyer = 'buyer';
  static const String seller = 'seller';
}

String dashboardPathForMode(String? mode) {
  switch (mode) {
    case AppMode.buyer:
      return AppRoutePath.farmerDashboard;
    case AppMode.seller:
      return AppRoutePath.farmerDashboard;
    case AppMode.farmer:
    default:
      return AppRoutePath.farmerDashboard;
  }
}
