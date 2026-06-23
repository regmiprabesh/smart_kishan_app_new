abstract final class ApiEndpoints {
  // OpenWeatherMap. Key is supplied separately via Env.owmApiKey.
  static const String owmBase = 'https://api.openweathermap.org/data/2.5';
  static const String owmCurrentWeather = '$owmBase/weather';
  static const String owmForecast = '$owmBase/forecast';

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
  // Administrative-location lookups (public). Backend returns the list under a
  // top-level key (provinces/districts/municipalities/wards), not `data`.
  static const String provinces = '/locations/provinces';
  static String districts(int provinceId) =>
      '/locations/provinces/$provinceId/districts';
  static String municipalities(int districtId) =>
      '/locations/districts/$districtId/municipalities';
  static String wards(int municipalityId) =>
      '/locations/municipalities/$municipalityId/wards';

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

  // Service Centers
  static const String serviceCenters = '/service-centers';
  static const String serviceCenterTypes = '/service-centers/types';
  static String serviceCenter(int id) => '/service-centers/$id';
  static String serviceCenterRating(int id) => '/service-centers/$id/rating';
  static String serviceCenterReviews(int id) => '/service-centers/$id/reviews';

  // Subsidies
  static const String subsidies = '/farmer/subsidies';
  static const String subsidyApplications = '/farmer/subsidy-applications';
  static String subsidyApply(int id) => '/farmer/subsidies/$id/apply';
  static String subsidyWithdraw(int id) => '/farmer/subsidies/$id/withdraw';
  static String subsidyRating(int id) => '/farmer/subsidies/$id/rating';
  static String subsidyReviews(int id) => '/farmer/subsidies/$id/reviews';

  // Subsidy requests
  static const String subsidyRequests = '/subsidy-requests';
  static const String mySubsidyRequests = '/subsidy-requests/my-requests';
  static String subsidyRequest(int id) => '/subsidy-requests/$id';
  static String cancelSubsidyRequest(int id) => '/subsidy-requests/$id/cancel';
}
