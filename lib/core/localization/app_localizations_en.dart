// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Smart Kishan';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Please select your preferred language';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get getStarted => 'Get Started';

  @override
  String get onboardingFarmingTitle => 'Farming Made Easier';

  @override
  String get onboardingFarmingDescription =>
      'Simplify farm management with tools designed to help you grow and succeed effortlessly.';

  @override
  String get onboardingFarmlandTitle => 'Manage Multiple Farmlands';

  @override
  String get onboardingFarmlandDescription =>
      'Store and track data from different farmlands, customized for each plot.';

  @override
  String get onboardingStockTitle => 'Organize Farm Stock Efficiently';

  @override
  String get onboardingStockDescription =>
      'Keep a clear record of all farm supplies and stock levels in one place.';

  @override
  String get onboardingNotesTitle => 'Quick Notes for Fast Reminders';

  @override
  String get onboardingNotesDescription =>
      'Note down important tasks or ideas instantly to stay organized and stay on top of your farm\'s needs.';

  @override
  String get errorNoInternet =>
      'Couldn\'t connect. Please check your internet connection and try again.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get authWelcomeBack => 'Welcome Back!';

  @override
  String get authLoginDescription => 'Please sign in to continue.';

  @override
  String get authLoginButton => 'Login';

  @override
  String get authForgotPassword => 'Forgot your password ?';

  @override
  String get authNoAccount => 'Don\'t have an account ?';

  @override
  String get authRegisterNow => 'Register Now';

  @override
  String get authInvalidCredentials => 'गलत फोन नम्बर वा पासवर्ड।';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneNumberHint => 'Enter your phone number';

  @override
  String get phoneNumberRequired => 'Please enter your phone number';

  @override
  String get phoneNumberInvalid => 'Please enter a valid phone number';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get orDividerText => 'OR';

  @override
  String get authRegisterTitle => 'Create Account';

  @override
  String get authRegisterDescription =>
      'Please enter your phone number to continue. We will send a verification code to verify your account.';

  @override
  String get authRequestOtpButton => 'Request OTP';

  @override
  String get authAlreadyHaveAccount => 'Already have an account ?';

  @override
  String get authSignInNow => 'Sign In';

  @override
  String get authOtpSent => 'The OTP code has been sent to your phone number.';

  @override
  String get authPhoneAlreadyRegistered =>
      'This phone number is already registered.';

  @override
  String get authPhoneNotRegistered => 'This phone number is not registered.';

  @override
  String authOtpThrottled(Object seconds) {
    return 'Please wait $seconds seconds before requesting another code.';
  }

  @override
  String get authOtpSendFailed => 'Failed to send OTP.';

  @override
  String get authOtpInvalid => 'The verification code is incorrect.';

  @override
  String get authOtpResent =>
      'The OTP code has been resent to your phone number.';

  @override
  String get authOtpTitle => 'Verification Code';

  @override
  String authOtpDescription(Object phoneNumber) {
    return 'Please enter the 6-digit verification code sent to $phoneNumber.';
  }

  @override
  String get authVerificationExpired =>
      'Your verification expired. Please verify your number again.';

  @override
  String get authVerifyButton => 'Verify';

  @override
  String get authDidNotReceiveOtp => 'Didn\'t receive the OTP ?';

  @override
  String authResendInSeconds(Object seconds) {
    return 'Try again in $seconds seconds.';
  }

  @override
  String get authResendButton => 'Resend';

  @override
  String get authOtpTooManyAttempts =>
      'Too many incorrect OTP attempts. Please request a new OTP and try again.';

  @override
  String get authOtpExpired => 'OTP code expired, Please request a new one.';

  @override
  String get authCreateAccountTitle => 'Create Account';

  @override
  String get authCreateAccountDescription =>
      'Complete the details below to create your Smart Kishan account and get started.';

  @override
  String get authAccountCreated =>
      'Your account has been created successfully!';

  @override
  String get authForgotPasswordTitle => 'Forgot Password';

  @override
  String get authForgotPasswordDescription =>
      'Enter your phone number to receive an OTP code for password reset.';

  @override
  String get authRememberedPassword => 'Remembered your password?';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get fullNameHint => 'Enter your full name';

  @override
  String get fullNameRequired => 'Please enter your full name';

  @override
  String get fullNameInvalid =>
      'Please enter a valid full name (at least 3 characters).';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get emailHint => 'Enter your email address';

  @override
  String get emailInvalid => 'Please enter a valid email address.';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters long.';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Re-enter your password';

  @override
  String get confirmPasswordRequired => 'Please confirm your password.';

  @override
  String get confirmPasswordInvalid => 'Passwords do not match.';

  @override
  String get authCreateAccountButton => 'Create Account';

  @override
  String get authBackToLogin => 'Back to Login';

  @override
  String get authEmailAlreadyRegistered =>
      'This email address is already registered.';

  @override
  String get authInvalidRegistrationData =>
      'The provided registration information is invalid. Please review your details and try again.';

  @override
  String get inventory => 'Inventory';

  @override
  String get dailyActivities => 'Daily Activities';

  @override
  String get farmLands => 'Farm Lands';

  @override
  String get notes => 'Notes';

  @override
  String get crops => 'Crops';

  @override
  String get kalimatiPrice => 'Kalimati Price';

  @override
  String get users => 'Users';

  @override
  String get subsidies => 'Subsidies';

  @override
  String get weatherPesticideRecommended =>
      'Today is a good day to apply pesticides.';

  @override
  String get weatherPesticideNotRecommended =>
      'Today is not a good day to apply pesticides.';

  @override
  String get weatherHumidity => 'Humidity';

  @override
  String get weatherThunderstorm => 'Thunderstorm';

  @override
  String get weatherDrizzle => 'Drizzle';

  @override
  String get weatherRain => 'Rain';

  @override
  String get weatherSnow => 'Snow';

  @override
  String get weatherClear => 'Clear';

  @override
  String get weatherClouds => 'Cloudy';

  @override
  String get weatherMist => 'Mist';

  @override
  String get weatherHaze => 'Haze';

  @override
  String get weatherFog => 'Fog';

  @override
  String get navigationHome => 'Home';

  @override
  String get navigationChart => 'Chart';

  @override
  String get navigationUsers => 'Users';

  @override
  String get navigationProfile => 'Profile';

  @override
  String get marketplaceBuyerMode => 'Buyer Mode';

  @override
  String get marketplaceSellerMode => 'Seller Mode';

  @override
  String get authLogout => 'Logout';

  @override
  String get profile => 'Profile';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profileUpdate => 'Update Profile';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully.';

  @override
  String get profileUpdateFailed => 'Failed to update profile.';

  @override
  String get profileChangePassword => 'Change Password';

  @override
  String get profileUpdateLocation => 'Update Location';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get confirmLogoutMessage => 'Are you sure you want to logout?';

  @override
  String get notesSearchHint => 'Search notes';

  @override
  String get notesNoResults => 'No matching notes';

  @override
  String get notesAdd => 'Add Note';

  @override
  String get notesUpdate => 'Update Note';

  @override
  String get notesAddedSuccessfully => 'Note added successfully.';

  @override
  String get notesUpdatedSuccessfully => 'Note updated successfully.';

  @override
  String get notesTitleLabel => 'Note Title';

  @override
  String get notesTitleHint => 'Enter note title';

  @override
  String get notesTitleRequired => 'Note title is required.';

  @override
  String get notesTitleInvalid => 'Note title must be at least 3 characters.';

  @override
  String get notesDescriptionLabel => 'Note Description';

  @override
  String get notesDescriptionHint => 'Enter note description';

  @override
  String get notesPriorityLabel => 'Note Priority';

  @override
  String get notesPriorityHint => 'Enter note priority';

  @override
  String get notesDeleteConfirmTitle => 'Confirm Delete';

  @override
  String get notesDeleteConfirmMessage =>
      'Are you sure you want to delete this note? This action cannot be undone.';

  @override
  String get notesEmpty => 'You don\'t have any notes yet !';

  @override
  String get notesEmptyDescription =>
      'Add notes to keep your important thoughts and information safe.';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonUpdate => 'Update';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonEdit => 'Edit';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get inventoryItemAdd => 'Add Inventory Item';

  @override
  String get inventoryItemUpdate => 'Update Inventory Item';

  @override
  String get inventoryItemEmpty => 'You don\'t have any inventory items yet!';

  @override
  String get inventoryItemEmptyDescription =>
      'Click the button below to add a new inventory item.';

  @override
  String get inventoryItemNameLabel => 'Inventory Item Name';

  @override
  String get inventoryItemNameHint => 'Enter inventory item name';

  @override
  String get inventoryItemNameRequired => 'Inventory item name is required.';

  @override
  String get inventoryItemNameInvalid =>
      'Inventory item name must be at least 3 characters.';

  @override
  String get inventoryItemStockLabel => 'Stock';

  @override
  String get inventoryItemStockHint => 'Enter stock quantity';

  @override
  String get inventoryItemStockRequired => 'Stock is required.';

  @override
  String get inventoryItemUnitLabel => 'Unit';

  @override
  String get inventoryItemUnitRequired => 'Please select a unit.';

  @override
  String get inventoryItemDescriptionLabel => 'Inventory Item Description';

  @override
  String get inventoryItemDescriptionHint => 'Enter inventory item description';

  @override
  String get inventoryItemTradeOptionLabel => 'Buy/Sell Option';

  @override
  String get inventoryItemBuy => 'Buy';

  @override
  String get inventoryItemSell => 'Sell';

  @override
  String get inventoryItemBoth => 'Both';

  @override
  String get inventoryItemDeleteConfirmTitle => 'Confirm Delete';

  @override
  String get inventoryItemDeleteConfirmMessage =>
      'Are you sure you want to delete this inventory item?';

  @override
  String get inventoryItemAddedSuccessfully =>
      'Inventory item added successfully.';

  @override
  String get inventoryItemUpdatedSuccessfully =>
      'Inventory item updated successfully.';

  @override
  String get dailyActivityAdd => 'Add Activity';

  @override
  String get dailyActivityUpdate => 'Update Activity';

  @override
  String get dailyActivityAddedSuccessfully => 'Activity added successfully.';

  @override
  String get dailyActivityUpdatedSuccessfully =>
      'Activity updated successfully.';

  @override
  String get dailyActivityEmpty => 'You don\'t have any activities yet!';

  @override
  String get dailyActivityEmptyDescription =>
      'Record your daily purchases, sales, and other farming activities here.';

  @override
  String get dailyActivityTitleLabel => 'Activity Title';

  @override
  String get dailyActivityTitleHint => 'Enter activity title';

  @override
  String get dailyActivityTitleRequired => 'Activity title is required.';

  @override
  String get dailyActivityDescriptionLabel => 'Description';

  @override
  String get dailyActivityDescriptionHint => 'Enter description';

  @override
  String get dailyActivityTypeLabel => 'Activity Type';

  @override
  String get dailyActivityBuy => 'Buy';

  @override
  String get dailyActivitySell => 'Sell';

  @override
  String get dailyActivityOther => 'Other';

  @override
  String get dailyActivityInventoryItemLabel => 'Inventory Item';

  @override
  String get dailyActivityInventoryItemHint => 'Select inventory item';

  @override
  String get dailyActivityInventoryItemRequired =>
      'Please select an inventory item.';

  @override
  String get dailyActivityQuantityLabel => 'Quantity';

  @override
  String get dailyActivityQuantityHint => 'Enter quantity';

  @override
  String get dailyActivityQuantityRequired => 'Quantity is required.';

  @override
  String get dailyActivitySalePriceLabel => 'Sale Price';

  @override
  String get dailyActivityCostPriceLabel => 'Cost Price';

  @override
  String get dailyActivityAmountHint => '0.00';

  @override
  String get dailyActivityAmountRequired => 'Amount is required.';

  @override
  String get dailyActivityDeleteConfirmTitle => 'Delete Activity';

  @override
  String get dailyActivityDeleteConfirmMessage =>
      'Are you sure you want to delete this activity? This action cannot be undone.';

  @override
  String get currencySymbol => 'Rs.';

  @override
  String get dailyActivityExpenseLabel => 'Expense (if any)';

  @override
  String get dailyActivityIncomeLabel => 'Income (if any)';

  @override
  String get myIncome => 'My Income';

  @override
  String get myExpense => 'My Expense';

  @override
  String get financialRecords => 'Financial Records';

  @override
  String get financialRecordsEmpty => 'No records found for this period.';

  @override
  String get chartScreenTitle => 'Financial Charts';

  @override
  String get chartIncomeAnalysis => 'Income Analysis';

  @override
  String get chartExpenseAnalysis => 'Expense Analysis';

  @override
  String get chartIncomeEmpty => 'No income records found yet.';

  @override
  String get chartExpenseEmpty => 'No expense records found yet.';

  @override
  String get chartFilterDaily => 'Daily';

  @override
  String get chartFilterMonthly => 'Monthly';

  @override
  String get chartFilterYearly => 'Yearly';

  @override
  String get chartLast7Days => 'Last 7 Days';

  @override
  String get chartLast7Months => 'Last 7 Months';

  @override
  String get chartLast5Years => 'Last 5 Years';

  @override
  String get chartNoDateFound => 'No date found.';

  @override
  String chartIncomeTitle(Object period) {
    return '$period Income Chart';
  }

  @override
  String chartExpenseTitle(Object period) {
    return '$period Expense Chart';
  }

  @override
  String chartIncomeExpenseTitle(Object period) {
    return '$period Income/Expense Chart';
  }

  @override
  String get farmlandAdd => 'Add Farmland';

  @override
  String get farmlandUpdate => 'Update Farmland';

  @override
  String get farmlandAddedSuccessfully => 'Farmland added successfully.';

  @override
  String get farmlandUpdatedSuccessfully => 'Farmland updated successfully.';

  @override
  String get farmlandEmpty => 'No farmlands yet!';

  @override
  String get farmlandEmptyDescription =>
      'Add your farmland with its location and soil details.';

  @override
  String get farmlandAddImage => 'Add Farmland Photo';

  @override
  String get farmlandNameLabel => 'Farmland Name';

  @override
  String get farmlandNameHint => 'Enter farmland name';

  @override
  String get farmlandNameRequired => 'Farmland name is required.';

  @override
  String get farmlandNameInvalid =>
      'Farmland name must be at least 3 characters.';

  @override
  String get farmlandDescriptionLabel => 'Description';

  @override
  String get farmlandDescriptionHint => 'Enter description';

  @override
  String get farmlandLocationSection => 'Location';

  @override
  String get farmlandUseMyLocation => 'Use My Location';

  @override
  String get farmlandLatLabel => 'Latitude';

  @override
  String get farmlandLatHint => 'Enter latitude';

  @override
  String get farmlandLngLabel => 'Longitude';

  @override
  String get farmlandLngHint => 'Enter longitude';

  @override
  String get farmlandCoordinatesRequired =>
      'Please enter latitude and longitude first.';

  @override
  String get farmlandSoilSection => 'Soil Properties';

  @override
  String get farmlandAutoFetch => 'Auto-fetch';

  @override
  String get farmlandSoilFetchFailed => 'Couldn\'t fetch soil data.';

  @override
  String get farmlandNitrogen => 'Nitrogen (%)';

  @override
  String get farmlandOrganicMatter => 'Organic Matter (%)';

  @override
  String get farmlandPhosphate => 'Phosphate (kg/ha)';

  @override
  String get farmlandPotassium => 'Potassium';

  @override
  String get farmlandPH => 'pH';

  @override
  String get farmlandLocationChip => 'Location';

  @override
  String get farmlandSoilChip => 'Soil';

  @override
  String get farmlandDeleteConfirmTitle => 'Delete Farmland';

  @override
  String get farmlandDeleteConfirmMessage =>
      'Are you sure you want to delete this farmland? This action cannot be undone.';

  @override
  String get imageUploadAdd => 'Add photo';

  @override
  String get mediaPickerTitle => 'Choose a source';

  @override
  String get mediaPickerCamera => 'Camera';

  @override
  String get mediaPickerGallery => 'Gallery';

  @override
  String get mediaPickerFiles => 'Files';

  @override
  String get farmlandBasicInfoSection => 'Basic Information';

  @override
  String get farmlandAddressLabel => 'Address';

  @override
  String get farmlandAddressHint =>
      'Tap \'Use my location\' to auto-fill, or type';

  @override
  String get farmlandImageSection => 'Farmland Photo';

  @override
  String get farmlandRecommendedCrops => 'Recommended Crops';

  @override
  String get farmlandRecommendedVegetables => 'Vegetables';

  @override
  String get farmlandRecommendedFruits => 'Fruits';

  @override
  String get marketPrices => 'Market Prices';

  @override
  String get marketPricesEmpty => 'No market prices available';

  @override
  String get marketSearchHint => 'Search commodity...';

  @override
  String get marketLastUpdated => 'Last updated';

  @override
  String get marketNoResults => 'No commodities match your search';

  @override
  String get minPrice => 'Min Price';

  @override
  String get maxPrice => 'Max Price';

  @override
  String get avgPrice => 'Avg Price';

  @override
  String get cropInfoTitle => 'Crop Information';

  @override
  String get cropInfoSearchHint => 'Search crops...';

  @override
  String get cropInfoEmpty => 'No crop information available';

  @override
  String get cropInfoNoResults => 'No crops match your search';

  @override
  String get cropInfoBannerTitle => 'Crop Information';

  @override
  String get cropInfoBannerSubtitle => 'Learn how to grow your crops';

  @override
  String get cropInfoBannerExplore => 'Explore crops';

  @override
  String get drawerSectionMain => 'Main';

  @override
  String get drawerSectionServices => 'Services';

  @override
  String get modeFarmer => 'Farmer';

  @override
  String get modeVendor => 'Vendor';

  @override
  String get modeBuyer => 'Buyer';

  @override
  String get governmentServices => 'Government Services';

  @override
  String get homeServiceCentersTitle => 'Service Centers';

  @override
  String get homeServiceCentersSubtitle => 'Nearby government offices';

  @override
  String get homeServiceCentersBadge => 'Offices';

  @override
  String get homeSubsidiesTitle => 'Subsidies';

  @override
  String get homeSubsidiesSubtitle => 'View available subsidies';

  @override
  String get homeSubsidiesBadge => 'Grants';

  @override
  String get homeComplaintsTitle => 'Complaints';

  @override
  String get homeComplaintsSubtitle => 'Report an issue';

  @override
  String get homeComplaintsBadge => 'Report';

  @override
  String get homeSurveysTitle => 'Surveys';

  @override
  String get homeSurveysSubtitle => 'Share your feedback';

  @override
  String get homeSurveysBadge => 'Feedback';

  @override
  String get serviceCenters => 'Service Centers';

  @override
  String get listView => 'List';

  @override
  String get mapView => 'Map';

  @override
  String get filters => 'Filters';

  @override
  String get filtersAndSort => 'Filters & Sort';

  @override
  String get sortBy => 'Sort by';

  @override
  String get clearAll => 'Clear All';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get searchServiceCentersHint => 'Search service centers...';

  @override
  String get searchRadius => 'Search Radius';

  @override
  String get showFeaturedOnly => 'Show featured only';

  @override
  String get distance => 'Distance';

  @override
  String get name => 'Name';

  @override
  String get rating => 'Rating';

  @override
  String get newest => 'Newest';

  @override
  String get featured => 'Featured';

  @override
  String get top5ByDistance => 'Top 5 by Distance';

  @override
  String get top5ByName => 'Top 5 by Name';

  @override
  String get top5ByRating => 'Top 5 by Rating';

  @override
  String get top5Newest => 'Top 5 Newest';

  @override
  String get details => 'Details';

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get viewDetails => 'View Details';

  @override
  String get loadingRoute => 'Loading route...';

  @override
  String get routeLoaded => 'Route loaded';

  @override
  String get routeUnavailable => 'Route unavailable';

  @override
  String get directions => 'Directions';

  @override
  String get noServiceCentersFound => 'No service centers found';

  @override
  String get tryAdjustingFilters => 'Try adjusting your filters or search';

  @override
  String get serviceCenterNotFound => 'Service center not found';

  @override
  String get km => 'km';

  @override
  String get away => 'away';

  @override
  String get notApplicable => 'N/A';

  @override
  String wardNo(String no) {
    return 'Ward No: $no';
  }

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get phone => 'Phone';

  @override
  String get website => 'Website';

  @override
  String get contactPerson => 'Contact Person';

  @override
  String get operatingHours => 'Operating Hours';

  @override
  String get servicesOffered => 'Services Offered';

  @override
  String get basedOnUserReviews => 'Based on user reviews';

  @override
  String get ratingSingular => 'rating';

  @override
  String get ratingPlural => 'ratings';

  @override
  String get recentReviews => 'Recent Reviews';

  @override
  String get yourRating => 'Your Rating';

  @override
  String get helpOthersRate => 'Help others by rating this service center';

  @override
  String get addYourRating => 'Add Your Rating';

  @override
  String get editRating => 'Edit';

  @override
  String get rateServiceCenter => 'Rate Service Center';

  @override
  String get editYourRating => 'Edit Your Rating';

  @override
  String get writeReviewOptional => 'Write a review (optional)';

  @override
  String get shareYourExperienceHint => 'Share your experience...';

  @override
  String get submit => 'Submit';

  @override
  String get deleteRatingQuestion => 'Delete rating?';

  @override
  String get deleteRatingReviewConfirm =>
      'Are you sure you want to delete your rating and review? This cannot be undone.';

  @override
  String get ratingSubmittedSuccess => 'Rating submitted successfully!';

  @override
  String get ratingUpdatedSuccess => 'Rating updated successfully!';

  @override
  String get anonymous => 'Anonymous';

  @override
  String get ago => 'ago';

  @override
  String get commonMinuteUnit => 'min';

  @override
  String get commonHourUnit => 'hr';

  @override
  String get commonDayUnit => 'day';

  @override
  String get commonDaysUnit => 'days';

  @override
  String get commonWeekUnit => 'week';

  @override
  String get commonWeeksUnit => 'weeks';

  @override
  String get commonAll => 'All';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get ratingDeletedSuccess => 'Rating deleted successfully!';

  @override
  String get resetPasswordTitle => 'Reset Password';

  @override
  String get resetPasswordDesc => 'Create a new password for your account.';

  @override
  String get newPassword => 'New Password';

  @override
  String get inputPassword => 'Enter your password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get inputConfirmPassword => 'Re-enter your password';

  @override
  String get inputPasswordMsg => 'Please enter your password';

  @override
  String get passwordMismatch => 'Passwords do not match.';

  @override
  String get passwordResetSuccess =>
      'Your password has been reset successfully!';

  @override
  String get passwordResetFailed =>
      'Failed to reset password. Please try again.';
}
