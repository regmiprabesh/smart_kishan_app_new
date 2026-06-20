import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ne.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ne'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Kishan'**
  String get appTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Please select your preferred language'**
  String get selectLanguage;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboardingFarmingTitle.
  ///
  /// In en, this message translates to:
  /// **'Farming Made Easier'**
  String get onboardingFarmingTitle;

  /// No description provided for @onboardingFarmingDescription.
  ///
  /// In en, this message translates to:
  /// **'Simplify farm management with tools designed to help you grow and succeed effortlessly.'**
  String get onboardingFarmingDescription;

  /// No description provided for @onboardingFarmlandTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Multiple Farmlands'**
  String get onboardingFarmlandTitle;

  /// No description provided for @onboardingFarmlandDescription.
  ///
  /// In en, this message translates to:
  /// **'Store and track data from different farmlands, customized for each plot.'**
  String get onboardingFarmlandDescription;

  /// No description provided for @onboardingStockTitle.
  ///
  /// In en, this message translates to:
  /// **'Organize Farm Stock Efficiently'**
  String get onboardingStockTitle;

  /// No description provided for @onboardingStockDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep a clear record of all farm supplies and stock levels in one place.'**
  String get onboardingStockDescription;

  /// No description provided for @onboardingNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Notes for Fast Reminders'**
  String get onboardingNotesTitle;

  /// No description provided for @onboardingNotesDescription.
  ///
  /// In en, this message translates to:
  /// **'Note down important tasks or ideas instantly to stay organized and stay on top of your farm\'s needs.'**
  String get onboardingNotesDescription;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect. Please check your internet connection and try again.'**
  String get errorNoInternet;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @authWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get authWelcomeBack;

  /// No description provided for @authLoginDescription.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue.'**
  String get authLoginDescription;

  /// No description provided for @authLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLoginButton;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password ?'**
  String get authForgotPassword;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account ?'**
  String get authNoAccount;

  /// No description provided for @authRegisterNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get authRegisterNow;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'गलत फोन नम्बर वा पासवर्ड।'**
  String get authInvalidCredentials;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneNumberHint;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get phoneNumberRequired;

  /// No description provided for @phoneNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneNumberInvalid;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// No description provided for @orDividerText.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDividerText;

  /// No description provided for @authRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authRegisterTitle;

  /// No description provided for @authRegisterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number to continue. We will send a verification code to verify your account.'**
  String get authRegisterDescription;

  /// No description provided for @authRequestOtpButton.
  ///
  /// In en, this message translates to:
  /// **'Request OTP'**
  String get authRequestOtpButton;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account ?'**
  String get authAlreadyHaveAccount;

  /// No description provided for @authSignInNow.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignInNow;

  /// No description provided for @authOtpSent.
  ///
  /// In en, this message translates to:
  /// **'The OTP code has been sent to your phone number.'**
  String get authOtpSent;

  /// No description provided for @authPhoneAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This phone number is already registered.'**
  String get authPhoneAlreadyRegistered;

  /// No description provided for @authPhoneNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'This phone number is not registered.'**
  String get authPhoneNotRegistered;

  /// No description provided for @authOtpThrottled.
  ///
  /// In en, this message translates to:
  /// **'Please wait {seconds} seconds before requesting another code.'**
  String authOtpThrottled(Object seconds);

  /// No description provided for @authOtpSendFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP.'**
  String get authOtpSendFailed;

  /// No description provided for @authOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'The verification code is incorrect.'**
  String get authOtpInvalid;

  /// No description provided for @authOtpResent.
  ///
  /// In en, this message translates to:
  /// **'The OTP code has been resent to your phone number.'**
  String get authOtpResent;

  /// No description provided for @authOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get authOtpTitle;

  /// No description provided for @authOtpDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6-digit verification code sent to {phoneNumber}.'**
  String authOtpDescription(Object phoneNumber);

  /// No description provided for @authVerificationExpired.
  ///
  /// In en, this message translates to:
  /// **'Your verification expired. Please verify your number again.'**
  String get authVerificationExpired;

  /// No description provided for @authVerifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get authVerifyButton;

  /// No description provided for @authDidNotReceiveOtp.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the OTP ?'**
  String get authDidNotReceiveOtp;

  /// No description provided for @authResendInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Try again in {seconds} seconds.'**
  String authResendInSeconds(Object seconds);

  /// No description provided for @authResendButton.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get authResendButton;

  /// No description provided for @authOtpTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many incorrect OTP attempts. Please request a new OTP and try again.'**
  String get authOtpTooManyAttempts;

  /// No description provided for @authOtpExpired.
  ///
  /// In en, this message translates to:
  /// **'OTP code expired, Please request a new one.'**
  String get authOtpExpired;

  /// No description provided for @authCreateAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccountTitle;

  /// No description provided for @authCreateAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete the details below to create your Smart Kishan account and get started.'**
  String get authCreateAccountDescription;

  /// No description provided for @authAccountCreated.
  ///
  /// In en, this message translates to:
  /// **'Your account has been created successfully!'**
  String get authAccountCreated;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get authForgotPasswordTitle;

  /// No description provided for @authForgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to receive an OTP code for password reset.'**
  String get authForgotPasswordDescription;

  /// No description provided for @authRememberedPassword.
  ///
  /// In en, this message translates to:
  /// **'Remembered your password?'**
  String get authRememberedPassword;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get fullNameRequired;

  /// No description provided for @fullNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid full name (at least 3 characters).'**
  String get fullNameInvalid;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get emailHint;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get emailInvalid;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long.'**
  String get passwordTooShort;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPasswordHint;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password.'**
  String get confirmPasswordRequired;

  /// No description provided for @confirmPasswordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get confirmPasswordInvalid;

  /// No description provided for @authCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccountButton;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get authBackToLogin;

  /// No description provided for @authEmailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email address is already registered.'**
  String get authEmailAlreadyRegistered;

  /// No description provided for @authInvalidRegistrationData.
  ///
  /// In en, this message translates to:
  /// **'The provided registration information is invalid. Please review your details and try again.'**
  String get authInvalidRegistrationData;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @dailyActivities.
  ///
  /// In en, this message translates to:
  /// **'Daily Activities'**
  String get dailyActivities;

  /// No description provided for @farmLands.
  ///
  /// In en, this message translates to:
  /// **'Farm Lands'**
  String get farmLands;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @crops.
  ///
  /// In en, this message translates to:
  /// **'Crops'**
  String get crops;

  /// No description provided for @kalimatiPrice.
  ///
  /// In en, this message translates to:
  /// **'Kalimati Price'**
  String get kalimatiPrice;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @subsidies.
  ///
  /// In en, this message translates to:
  /// **'Subsidies'**
  String get subsidies;

  /// No description provided for @weatherPesticideRecommended.
  ///
  /// In en, this message translates to:
  /// **'Today is a good day to apply pesticides.'**
  String get weatherPesticideRecommended;

  /// No description provided for @weatherPesticideNotRecommended.
  ///
  /// In en, this message translates to:
  /// **'Today is not a good day to apply pesticides.'**
  String get weatherPesticideNotRecommended;

  /// No description provided for @weatherHumidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get weatherHumidity;

  /// No description provided for @weatherThunderstorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get weatherThunderstorm;

  /// No description provided for @weatherDrizzle.
  ///
  /// In en, this message translates to:
  /// **'Drizzle'**
  String get weatherDrizzle;

  /// No description provided for @weatherRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get weatherRain;

  /// No description provided for @weatherSnow.
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get weatherSnow;

  /// No description provided for @weatherClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get weatherClear;

  /// No description provided for @weatherClouds.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get weatherClouds;

  /// No description provided for @weatherMist.
  ///
  /// In en, this message translates to:
  /// **'Mist'**
  String get weatherMist;

  /// No description provided for @weatherHaze.
  ///
  /// In en, this message translates to:
  /// **'Haze'**
  String get weatherHaze;

  /// No description provided for @weatherFog.
  ///
  /// In en, this message translates to:
  /// **'Fog'**
  String get weatherFog;

  /// No description provided for @navigationHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navigationHome;

  /// No description provided for @navigationChart.
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get navigationChart;

  /// No description provided for @navigationUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get navigationUsers;

  /// No description provided for @navigationProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navigationProfile;

  /// No description provided for @marketplaceBuyerMode.
  ///
  /// In en, this message translates to:
  /// **'Buyer Mode'**
  String get marketplaceBuyerMode;

  /// No description provided for @marketplaceSellerMode.
  ///
  /// In en, this message translates to:
  /// **'Seller Mode'**
  String get marketplaceSellerMode;

  /// No description provided for @authLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get authLogout;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEdit;

  /// No description provided for @profileUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get profileUpdate;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile.'**
  String get profileUpdateFailed;

  /// No description provided for @profileChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get profileChangePassword;

  /// No description provided for @profileUpdateLocation.
  ///
  /// In en, this message translates to:
  /// **'Update Location'**
  String get profileUpdateLocation;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// No description provided for @confirmLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirmLogoutMessage;

  /// No description provided for @notesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search notes'**
  String get notesSearchHint;

  /// No description provided for @notesNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matching notes'**
  String get notesNoResults;

  /// No description provided for @notesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get notesAdd;

  /// No description provided for @notesUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update Note'**
  String get notesUpdate;

  /// No description provided for @notesAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Note added successfully.'**
  String get notesAddedSuccessfully;

  /// No description provided for @notesUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Note updated successfully.'**
  String get notesUpdatedSuccessfully;

  /// No description provided for @notesTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Note Title'**
  String get notesTitleLabel;

  /// No description provided for @notesTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter note title'**
  String get notesTitleHint;

  /// No description provided for @notesTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Note title is required.'**
  String get notesTitleRequired;

  /// No description provided for @notesTitleInvalid.
  ///
  /// In en, this message translates to:
  /// **'Note title must be at least 3 characters.'**
  String get notesTitleInvalid;

  /// No description provided for @notesDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Note Description'**
  String get notesDescriptionLabel;

  /// No description provided for @notesDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter note description'**
  String get notesDescriptionHint;

  /// No description provided for @notesPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Note Priority'**
  String get notesPriorityLabel;

  /// No description provided for @notesPriorityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter note priority'**
  String get notesPriorityHint;

  /// No description provided for @notesDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get notesDeleteConfirmTitle;

  /// No description provided for @notesDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this note? This action cannot be undone.'**
  String get notesDeleteConfirmMessage;

  /// No description provided for @notesEmpty.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any notes yet !'**
  String get notesEmpty;

  /// No description provided for @notesEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Add notes to keep your important thoughts and information safe.'**
  String get notesEmptyDescription;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get commonUpdate;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get commonRefresh;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @inventoryItemAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Inventory Item'**
  String get inventoryItemAdd;

  /// No description provided for @inventoryItemUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update Inventory Item'**
  String get inventoryItemUpdate;

  /// No description provided for @inventoryItemEmpty.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any inventory items yet!'**
  String get inventoryItemEmpty;

  /// No description provided for @inventoryItemEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Click the button below to add a new inventory item.'**
  String get inventoryItemEmptyDescription;

  /// No description provided for @inventoryItemNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Inventory Item Name'**
  String get inventoryItemNameLabel;

  /// No description provided for @inventoryItemNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter inventory item name'**
  String get inventoryItemNameHint;

  /// No description provided for @inventoryItemNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Inventory item name is required.'**
  String get inventoryItemNameRequired;

  /// No description provided for @inventoryItemNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Inventory item name must be at least 3 characters.'**
  String get inventoryItemNameInvalid;

  /// No description provided for @inventoryItemStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get inventoryItemStockLabel;

  /// No description provided for @inventoryItemStockHint.
  ///
  /// In en, this message translates to:
  /// **'Enter stock quantity'**
  String get inventoryItemStockHint;

  /// No description provided for @inventoryItemStockRequired.
  ///
  /// In en, this message translates to:
  /// **'Stock is required.'**
  String get inventoryItemStockRequired;

  /// No description provided for @inventoryItemUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get inventoryItemUnitLabel;

  /// No description provided for @inventoryItemUnitRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a unit.'**
  String get inventoryItemUnitRequired;

  /// No description provided for @inventoryItemDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Inventory Item Description'**
  String get inventoryItemDescriptionLabel;

  /// No description provided for @inventoryItemDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter inventory item description'**
  String get inventoryItemDescriptionHint;

  /// No description provided for @inventoryItemTradeOptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Buy/Sell Option'**
  String get inventoryItemTradeOptionLabel;

  /// No description provided for @inventoryItemBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get inventoryItemBuy;

  /// No description provided for @inventoryItemSell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get inventoryItemSell;

  /// No description provided for @inventoryItemBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get inventoryItemBoth;

  /// No description provided for @inventoryItemDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get inventoryItemDeleteConfirmTitle;

  /// No description provided for @inventoryItemDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this inventory item?'**
  String get inventoryItemDeleteConfirmMessage;

  /// No description provided for @inventoryItemAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Inventory item added successfully.'**
  String get inventoryItemAddedSuccessfully;

  /// No description provided for @inventoryItemUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Inventory item updated successfully.'**
  String get inventoryItemUpdatedSuccessfully;

  /// No description provided for @dailyActivityAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Activity'**
  String get dailyActivityAdd;

  /// No description provided for @dailyActivityUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update Activity'**
  String get dailyActivityUpdate;

  /// No description provided for @dailyActivityAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Activity added successfully.'**
  String get dailyActivityAddedSuccessfully;

  /// No description provided for @dailyActivityUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Activity updated successfully.'**
  String get dailyActivityUpdatedSuccessfully;

  /// No description provided for @dailyActivityEmpty.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any activities yet!'**
  String get dailyActivityEmpty;

  /// No description provided for @dailyActivityEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Record your daily purchases, sales, and other farming activities here.'**
  String get dailyActivityEmptyDescription;

  /// No description provided for @dailyActivityTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity Title'**
  String get dailyActivityTitleLabel;

  /// No description provided for @dailyActivityTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter activity title'**
  String get dailyActivityTitleHint;

  /// No description provided for @dailyActivityTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Activity title is required.'**
  String get dailyActivityTitleRequired;

  /// No description provided for @dailyActivityDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get dailyActivityDescriptionLabel;

  /// No description provided for @dailyActivityDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get dailyActivityDescriptionHint;

  /// No description provided for @dailyActivityTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity Type'**
  String get dailyActivityTypeLabel;

  /// No description provided for @dailyActivityBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get dailyActivityBuy;

  /// No description provided for @dailyActivitySell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get dailyActivitySell;

  /// No description provided for @dailyActivityOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get dailyActivityOther;

  /// No description provided for @dailyActivityInventoryItemLabel.
  ///
  /// In en, this message translates to:
  /// **'Inventory Item'**
  String get dailyActivityInventoryItemLabel;

  /// No description provided for @dailyActivityInventoryItemHint.
  ///
  /// In en, this message translates to:
  /// **'Select inventory item'**
  String get dailyActivityInventoryItemHint;

  /// No description provided for @dailyActivityInventoryItemRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select an inventory item.'**
  String get dailyActivityInventoryItemRequired;

  /// No description provided for @dailyActivityQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get dailyActivityQuantityLabel;

  /// No description provided for @dailyActivityQuantityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter quantity'**
  String get dailyActivityQuantityHint;

  /// No description provided for @dailyActivityQuantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Quantity is required.'**
  String get dailyActivityQuantityRequired;

  /// No description provided for @dailyActivitySalePriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Sale Price'**
  String get dailyActivitySalePriceLabel;

  /// No description provided for @dailyActivityCostPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Cost Price'**
  String get dailyActivityCostPriceLabel;

  /// No description provided for @dailyActivityAmountHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get dailyActivityAmountHint;

  /// No description provided for @dailyActivityAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Amount is required.'**
  String get dailyActivityAmountRequired;

  /// No description provided for @dailyActivityDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Activity'**
  String get dailyActivityDeleteConfirmTitle;

  /// No description provided for @dailyActivityDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this activity? This action cannot be undone.'**
  String get dailyActivityDeleteConfirmMessage;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'Rs.'**
  String get currencySymbol;

  /// No description provided for @dailyActivityExpenseLabel.
  ///
  /// In en, this message translates to:
  /// **'Expense (if any)'**
  String get dailyActivityExpenseLabel;

  /// No description provided for @dailyActivityIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Income (if any)'**
  String get dailyActivityIncomeLabel;

  /// No description provided for @myIncome.
  ///
  /// In en, this message translates to:
  /// **'My Income'**
  String get myIncome;

  /// No description provided for @myExpense.
  ///
  /// In en, this message translates to:
  /// **'My Expense'**
  String get myExpense;

  /// No description provided for @financialRecords.
  ///
  /// In en, this message translates to:
  /// **'Financial Records'**
  String get financialRecords;

  /// No description provided for @financialRecordsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No records found for this period.'**
  String get financialRecordsEmpty;

  /// No description provided for @chartScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Charts'**
  String get chartScreenTitle;

  /// No description provided for @chartIncomeAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Income Analysis'**
  String get chartIncomeAnalysis;

  /// No description provided for @chartExpenseAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Expense Analysis'**
  String get chartExpenseAnalysis;

  /// No description provided for @chartIncomeEmpty.
  ///
  /// In en, this message translates to:
  /// **'No income records found yet.'**
  String get chartIncomeEmpty;

  /// No description provided for @chartExpenseEmpty.
  ///
  /// In en, this message translates to:
  /// **'No expense records found yet.'**
  String get chartExpenseEmpty;

  /// No description provided for @chartFilterDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get chartFilterDaily;

  /// No description provided for @chartFilterMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get chartFilterMonthly;

  /// No description provided for @chartFilterYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get chartFilterYearly;

  /// No description provided for @chartLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get chartLast7Days;

  /// No description provided for @chartLast7Months.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Months'**
  String get chartLast7Months;

  /// No description provided for @chartLast5Years.
  ///
  /// In en, this message translates to:
  /// **'Last 5 Years'**
  String get chartLast5Years;

  /// No description provided for @chartNoDateFound.
  ///
  /// In en, this message translates to:
  /// **'No date found.'**
  String get chartNoDateFound;

  /// No description provided for @chartIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'{period} Income Chart'**
  String chartIncomeTitle(Object period);

  /// No description provided for @chartExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'{period} Expense Chart'**
  String chartExpenseTitle(Object period);

  /// No description provided for @chartIncomeExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'{period} Income/Expense Chart'**
  String chartIncomeExpenseTitle(Object period);

  /// No description provided for @farmlandAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Farmland'**
  String get farmlandAdd;

  /// No description provided for @farmlandUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update Farmland'**
  String get farmlandUpdate;

  /// No description provided for @farmlandAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Farmland added successfully.'**
  String get farmlandAddedSuccessfully;

  /// No description provided for @farmlandUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Farmland updated successfully.'**
  String get farmlandUpdatedSuccessfully;

  /// No description provided for @farmlandEmpty.
  ///
  /// In en, this message translates to:
  /// **'No farmlands yet!'**
  String get farmlandEmpty;

  /// No description provided for @farmlandEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Add your farmland with its location and soil details.'**
  String get farmlandEmptyDescription;

  /// No description provided for @farmlandAddImage.
  ///
  /// In en, this message translates to:
  /// **'Add Farmland Photo'**
  String get farmlandAddImage;

  /// No description provided for @farmlandNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Farmland Name'**
  String get farmlandNameLabel;

  /// No description provided for @farmlandNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter farmland name'**
  String get farmlandNameHint;

  /// No description provided for @farmlandNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Farmland name is required.'**
  String get farmlandNameRequired;

  /// No description provided for @farmlandNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Farmland name must be at least 3 characters.'**
  String get farmlandNameInvalid;

  /// No description provided for @farmlandDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get farmlandDescriptionLabel;

  /// No description provided for @farmlandDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get farmlandDescriptionHint;

  /// No description provided for @farmlandLocationSection.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get farmlandLocationSection;

  /// No description provided for @farmlandUseMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use My Location'**
  String get farmlandUseMyLocation;

  /// No description provided for @farmlandLatLabel.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get farmlandLatLabel;

  /// No description provided for @farmlandLatHint.
  ///
  /// In en, this message translates to:
  /// **'Enter latitude'**
  String get farmlandLatHint;

  /// No description provided for @farmlandLngLabel.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get farmlandLngLabel;

  /// No description provided for @farmlandLngHint.
  ///
  /// In en, this message translates to:
  /// **'Enter longitude'**
  String get farmlandLngHint;

  /// No description provided for @farmlandCoordinatesRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter latitude and longitude first.'**
  String get farmlandCoordinatesRequired;

  /// No description provided for @farmlandSoilSection.
  ///
  /// In en, this message translates to:
  /// **'Soil Properties'**
  String get farmlandSoilSection;

  /// No description provided for @farmlandAutoFetch.
  ///
  /// In en, this message translates to:
  /// **'Auto-fetch'**
  String get farmlandAutoFetch;

  /// No description provided for @farmlandSoilFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t fetch soil data.'**
  String get farmlandSoilFetchFailed;

  /// No description provided for @farmlandNitrogen.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (%)'**
  String get farmlandNitrogen;

  /// No description provided for @farmlandOrganicMatter.
  ///
  /// In en, this message translates to:
  /// **'Organic Matter (%)'**
  String get farmlandOrganicMatter;

  /// No description provided for @farmlandPhosphate.
  ///
  /// In en, this message translates to:
  /// **'Phosphate (kg/ha)'**
  String get farmlandPhosphate;

  /// No description provided for @farmlandPotassium.
  ///
  /// In en, this message translates to:
  /// **'Potassium'**
  String get farmlandPotassium;

  /// No description provided for @farmlandPH.
  ///
  /// In en, this message translates to:
  /// **'pH'**
  String get farmlandPH;

  /// No description provided for @farmlandLocationChip.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get farmlandLocationChip;

  /// No description provided for @farmlandSoilChip.
  ///
  /// In en, this message translates to:
  /// **'Soil'**
  String get farmlandSoilChip;

  /// No description provided for @farmlandDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Farmland'**
  String get farmlandDeleteConfirmTitle;

  /// No description provided for @farmlandDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this farmland? This action cannot be undone.'**
  String get farmlandDeleteConfirmMessage;

  /// No description provided for @imageUploadAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get imageUploadAdd;

  /// No description provided for @mediaPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a source'**
  String get mediaPickerTitle;

  /// No description provided for @mediaPickerCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get mediaPickerCamera;

  /// No description provided for @mediaPickerGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get mediaPickerGallery;

  /// No description provided for @mediaPickerFiles.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get mediaPickerFiles;

  /// No description provided for @farmlandBasicInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get farmlandBasicInfoSection;

  /// No description provided for @farmlandAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get farmlandAddressLabel;

  /// No description provided for @farmlandAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Use my location\' to auto-fill, or type'**
  String get farmlandAddressHint;

  /// No description provided for @farmlandImageSection.
  ///
  /// In en, this message translates to:
  /// **'Farmland Photo'**
  String get farmlandImageSection;

  /// No description provided for @farmlandRecommendedCrops.
  ///
  /// In en, this message translates to:
  /// **'Recommended Crops'**
  String get farmlandRecommendedCrops;

  /// No description provided for @farmlandRecommendedVegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get farmlandRecommendedVegetables;

  /// No description provided for @farmlandRecommendedFruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get farmlandRecommendedFruits;

  /// No description provided for @marketPrices.
  ///
  /// In en, this message translates to:
  /// **'Market Prices'**
  String get marketPrices;

  /// No description provided for @marketPricesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No market prices available'**
  String get marketPricesEmpty;

  /// No description provided for @marketSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search commodity...'**
  String get marketSearchHint;

  /// No description provided for @marketLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get marketLastUpdated;

  /// No description provided for @marketNoResults.
  ///
  /// In en, this message translates to:
  /// **'No commodities match your search'**
  String get marketNoResults;

  /// No description provided for @minPrice.
  ///
  /// In en, this message translates to:
  /// **'Min Price'**
  String get minPrice;

  /// No description provided for @maxPrice.
  ///
  /// In en, this message translates to:
  /// **'Max Price'**
  String get maxPrice;

  /// No description provided for @avgPrice.
  ///
  /// In en, this message translates to:
  /// **'Avg Price'**
  String get avgPrice;

  /// No description provided for @cropInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop Information'**
  String get cropInfoTitle;

  /// No description provided for @cropInfoSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search crops...'**
  String get cropInfoSearchHint;

  /// No description provided for @cropInfoEmpty.
  ///
  /// In en, this message translates to:
  /// **'No crop information available'**
  String get cropInfoEmpty;

  /// No description provided for @cropInfoNoResults.
  ///
  /// In en, this message translates to:
  /// **'No crops match your search'**
  String get cropInfoNoResults;

  /// No description provided for @cropInfoBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop Information'**
  String get cropInfoBannerTitle;

  /// No description provided for @cropInfoBannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn how to grow your crops'**
  String get cropInfoBannerSubtitle;

  /// No description provided for @cropInfoBannerExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore crops'**
  String get cropInfoBannerExplore;

  /// No description provided for @drawerSectionMain.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get drawerSectionMain;

  /// No description provided for @drawerSectionServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get drawerSectionServices;

  /// No description provided for @modeFarmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get modeFarmer;

  /// No description provided for @modeVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get modeVendor;

  /// No description provided for @modeBuyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get modeBuyer;

  /// No description provided for @governmentServices.
  ///
  /// In en, this message translates to:
  /// **'Government Services'**
  String get governmentServices;

  /// No description provided for @homeServiceCentersTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Centers'**
  String get homeServiceCentersTitle;

  /// No description provided for @homeServiceCentersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby government offices'**
  String get homeServiceCentersSubtitle;

  /// No description provided for @homeServiceCentersBadge.
  ///
  /// In en, this message translates to:
  /// **'Offices'**
  String get homeServiceCentersBadge;

  /// No description provided for @homeSubsidiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Subsidies'**
  String get homeSubsidiesTitle;

  /// No description provided for @homeSubsidiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View available subsidies'**
  String get homeSubsidiesSubtitle;

  /// No description provided for @homeSubsidiesBadge.
  ///
  /// In en, this message translates to:
  /// **'Grants'**
  String get homeSubsidiesBadge;

  /// No description provided for @homeComplaintsTitle.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get homeComplaintsTitle;

  /// No description provided for @homeComplaintsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Report an issue'**
  String get homeComplaintsSubtitle;

  /// No description provided for @homeComplaintsBadge.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get homeComplaintsBadge;

  /// No description provided for @homeSurveysTitle.
  ///
  /// In en, this message translates to:
  /// **'Surveys'**
  String get homeSurveysTitle;

  /// No description provided for @homeSurveysSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your feedback'**
  String get homeSurveysSubtitle;

  /// No description provided for @homeSurveysBadge.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get homeSurveysBadge;

  /// No description provided for @serviceCenters.
  ///
  /// In en, this message translates to:
  /// **'Service Centers'**
  String get serviceCenters;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get listView;

  /// No description provided for @mapView.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapView;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @filtersAndSort.
  ///
  /// In en, this message translates to:
  /// **'Filters & Sort'**
  String get filtersAndSort;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @searchServiceCentersHint.
  ///
  /// In en, this message translates to:
  /// **'Search service centers...'**
  String get searchServiceCentersHint;

  /// No description provided for @searchRadius.
  ///
  /// In en, this message translates to:
  /// **'Search Radius'**
  String get searchRadius;

  /// No description provided for @showFeaturedOnly.
  ///
  /// In en, this message translates to:
  /// **'Show featured only'**
  String get showFeaturedOnly;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @top5ByDistance.
  ///
  /// In en, this message translates to:
  /// **'Top 5 by Distance'**
  String get top5ByDistance;

  /// No description provided for @top5ByName.
  ///
  /// In en, this message translates to:
  /// **'Top 5 by Name'**
  String get top5ByName;

  /// No description provided for @top5ByRating.
  ///
  /// In en, this message translates to:
  /// **'Top 5 by Rating'**
  String get top5ByRating;

  /// No description provided for @top5Newest.
  ///
  /// In en, this message translates to:
  /// **'Top 5 Newest'**
  String get top5Newest;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @loadingRoute.
  ///
  /// In en, this message translates to:
  /// **'Loading route...'**
  String get loadingRoute;

  /// No description provided for @routeLoaded.
  ///
  /// In en, this message translates to:
  /// **'Route loaded'**
  String get routeLoaded;

  /// No description provided for @routeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Route unavailable'**
  String get routeUnavailable;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @noServiceCentersFound.
  ///
  /// In en, this message translates to:
  /// **'No service centers found'**
  String get noServiceCentersFound;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search'**
  String get tryAdjustingFilters;

  /// No description provided for @serviceCenterNotFound.
  ///
  /// In en, this message translates to:
  /// **'Service center not found'**
  String get serviceCenterNotFound;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// No description provided for @away.
  ///
  /// In en, this message translates to:
  /// **'away'**
  String get away;

  /// No description provided for @notApplicable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notApplicable;

  /// No description provided for @wardNo.
  ///
  /// In en, this message translates to:
  /// **'Ward No: {no}'**
  String wardNo(String no);

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @contactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get contactPerson;

  /// No description provided for @operatingHours.
  ///
  /// In en, this message translates to:
  /// **'Operating Hours'**
  String get operatingHours;

  /// No description provided for @servicesOffered.
  ///
  /// In en, this message translates to:
  /// **'Services Offered'**
  String get servicesOffered;

  /// No description provided for @basedOnUserReviews.
  ///
  /// In en, this message translates to:
  /// **'Based on user reviews'**
  String get basedOnUserReviews;

  /// No description provided for @ratingSingular.
  ///
  /// In en, this message translates to:
  /// **'rating'**
  String get ratingSingular;

  /// No description provided for @ratingPlural.
  ///
  /// In en, this message translates to:
  /// **'ratings'**
  String get ratingPlural;

  /// No description provided for @recentReviews.
  ///
  /// In en, this message translates to:
  /// **'Recent Reviews'**
  String get recentReviews;

  /// No description provided for @yourRating.
  ///
  /// In en, this message translates to:
  /// **'Your Rating'**
  String get yourRating;

  /// No description provided for @helpOthersRate.
  ///
  /// In en, this message translates to:
  /// **'Help others by rating this service center'**
  String get helpOthersRate;

  /// No description provided for @addYourRating.
  ///
  /// In en, this message translates to:
  /// **'Add Your Rating'**
  String get addYourRating;

  /// No description provided for @editRating.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editRating;

  /// No description provided for @rateServiceCenter.
  ///
  /// In en, this message translates to:
  /// **'Rate Service Center'**
  String get rateServiceCenter;

  /// No description provided for @editYourRating.
  ///
  /// In en, this message translates to:
  /// **'Edit Your Rating'**
  String get editYourRating;

  /// No description provided for @writeReviewOptional.
  ///
  /// In en, this message translates to:
  /// **'Write a review (optional)'**
  String get writeReviewOptional;

  /// No description provided for @shareYourExperienceHint.
  ///
  /// In en, this message translates to:
  /// **'Share your experience...'**
  String get shareYourExperienceHint;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @deleteRatingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete rating?'**
  String get deleteRatingQuestion;

  /// No description provided for @deleteRatingReviewConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your rating and review? This cannot be undone.'**
  String get deleteRatingReviewConfirm;

  /// No description provided for @ratingSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Rating submitted successfully!'**
  String get ratingSubmittedSuccess;

  /// No description provided for @ratingUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Rating updated successfully!'**
  String get ratingUpdatedSuccess;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @ago.
  ///
  /// In en, this message translates to:
  /// **'ago'**
  String get ago;

  /// No description provided for @commonMinuteUnit.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get commonMinuteUnit;

  /// No description provided for @commonHourUnit.
  ///
  /// In en, this message translates to:
  /// **'hr'**
  String get commonHourUnit;

  /// No description provided for @commonDayUnit.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get commonDayUnit;

  /// No description provided for @commonDaysUnit.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get commonDaysUnit;

  /// No description provided for @commonWeekUnit.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get commonWeekUnit;

  /// No description provided for @commonWeeksUnit.
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get commonWeeksUnit;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @ratingDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Rating deleted successfully!'**
  String get ratingDeletedSuccess;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a new password for your account.'**
  String get resetPasswordDesc;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @inputPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get inputPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @inputConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get inputConfirmPassword;

  /// No description provided for @inputPasswordMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get inputPasswordMsg;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordMismatch;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your password has been reset successfully!'**
  String get passwordResetSuccess;

  /// No description provided for @passwordResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset password. Please try again.'**
  String get passwordResetFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ne'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ne':
      return AppLocalizationsNe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
