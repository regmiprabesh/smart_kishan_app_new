import 'package:smart_kishan/core/config/env.dart';

abstract final class ApiEndpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String switchMode = '/auth/mode';

  // Profile
  static const String updateProfile = '/users/update-profile';
  static const String uploadProfileImage = '/users/upload-profile-image';
  static const String changePassword = '/users/change-password';
  static const String updateLocation = '/users/update-location';

  // Notes
  static const String notes = '/notes';
  static String note(int id) => '/notes/$id';

  // Inventory Items
  static const String inventoryItems = '/products';
  static String inventoryItem(int id) => '/products/$id';

  // Unit
  static const String units = '/units';

  //Daily Activity
  static const String activities = '/activities';
  static String activity(int id) => '/activities/$id';

  // Farmland
  static const String farmlands = '/farmlands';
  static String farmland(int id) => '/farmlands/$id';
  static const String farmlandSoil = '/farmlands-soil';

  //MarketPrice
  static const String marketPrices = '/market-prices';

  //Crops Information
  static const String crops = '/cropInfo';
}
