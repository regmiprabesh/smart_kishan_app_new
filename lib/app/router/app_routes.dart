abstract final class AppRoutePath {
  // Launch flow
  static const String splash = '/splash';
  static const String selectLanguage = '/select-language';
  static const String introduction = '/introduction';

  // Auth
  static const String signIn = '/sign-in';
  static const String registerPhone = '/register-phone';
  static const String registerDetails = '/register-details';
  static const String forgotPasswordPhone = '/forgot-password-phone';
  static const String otp = '/otp'; // shared: registration + reset
  static const String resetPassword = '/reset-password';

  // Dashboards
  static const String farmerDashboard = '/farmer';
  static const String customerDashboard = '/market';
  static const String vendorDashboard = '/vendor';

  static const String myUsers = '/myUsers';
  static const String chatbot = '/chatbot';
  static const String myDeliveryAddresses = '/myDeliveryAddress';
  static const String orderHistory = '/orderHistory';
  static const String buyersGroup = '/buyersGroup';

  static const String editProfile = '/editProfile';
  static const String updatePassword = '/updatePassword';
  static const String updateLocation = '/updateLocation';

  //Notes
  static const String notes = '/notes';
  static const String addNote = '/notes/add';

  //Quick Actions
  //Inventory
  static const String inventory = '/inventory';
  static const String addInventoryItem = '/inventory/add';

  //Daily Activities
  static const String dailyActivity = '/dailyActivity';
  static const String addDailyActivity = '/daily-activity/add';

  //Income
  static const String income = '/income';

  //Expense
  static const String expense = '/expense';

  //Chart Screen
  static const String ledgerChart = '/chart';

  //FarmLands
  static const String farmlands = '/farmland';
  static const String addFarmland = '/farmland/add';
  static const String farmlandDetail = '/farmland/detail';

  //Market Price
  static const String marketPrices = '/market-prices';

  //Crop Information
  static const String cropInfoList = '/crops';
  static const String cropInfoDetail = '/crops/detail';

  //Government Services
  static const String serviceCenters = '/service-centers';
  static const String serviceCenterDetail = '/service-centers/detail';
  static const String subsidies = '/subsidies';
  static const String complaints = '/complaints';
  static const String surveys = '/surveys';
  // Deep-linkable feature paths (Phase 3+ — registered as the features
  // are ported; server can already target them):
  //   /subsidies, /subsidies/:id, /market/products/:id,
  //   /orders, /surveys/:id, /complaints/:id ...
}
