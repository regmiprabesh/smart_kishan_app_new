// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get appTitle => 'Smart Kishan';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguage => 'कृपया आफूलाई उपयुक्त भाषा छनोट गर्नुहोस्।';

  @override
  String get next => 'अर्को';

  @override
  String get skip => 'स्किप गर्नुहोस्';

  @override
  String get getStarted => 'सुरु गर्नुहोस्';

  @override
  String get onboardingFarmingTitle => 'अब कृषि अझ सजिलो';

  @override
  String get onboardingFarmingDescription =>
      'तपाईंको कृषि व्यवस्थापनलाई सहज बनाउन डिजाइन गरिएका उपकरणहरूको प्रयोग गरी सजिलै सफल बन्नुहोस्।';

  @override
  String get onboardingFarmlandTitle => 'धेरै खेतबारी व्यवस्थापन गर्नुहोस्';

  @override
  String get onboardingFarmlandDescription =>
      'विभिन्न खेतबारीहरूको विवरण सुरक्षित राख्नुहोस् र प्रत्येक जमिनको लागि छुट्टाछुट्टै व्यवस्थापन गर्नुहोस्।';

  @override
  String get onboardingStockTitle =>
      'फार्म स्टक प्रभावकारी रूपमा व्यवस्थापन गर्नुहोस्';

  @override
  String get onboardingStockDescription =>
      'सबै कृषि सामग्री र स्टकको अवस्थाको स्पष्ट अभिलेख एकै ठाउँमा राख्नुहोस्।';

  @override
  String get onboardingNotesTitle => 'छिटो सम्झनका लागि नोटहरू';

  @override
  String get onboardingNotesDescription =>
      'महत्त्वपूर्ण कामहरू वा विचारहरू तुरुन्त टिपोट गर्नुहोस् र आफ्नो फार्मका आवश्यकताहरू व्यवस्थित राख्नुहोस्।';

  @override
  String get errorNoInternet =>
      'इन्टरनेटमा जडान हुन सकेन। कृपया आफ्नो इन्टरनेट जाँच गरी पुनः प्रयास गर्नुहोस्।';

  @override
  String get errorGeneric =>
      'केही समस्या उत्पन्न भयो। कृपया फेरि प्रयास गर्नुहोस्।';

  @override
  String get authWelcomeBack => 'फेरि स्वागत छ!';

  @override
  String get authLoginDescription => 'जारी राख्न कृपया साइन इन गर्नुहोस्।';

  @override
  String get authLoginButton => 'लगइन गर्नुहोस्';

  @override
  String get authForgotPassword => 'पासवर्ड बिर्सनुभयो ?';

  @override
  String get authNoAccount => 'खाता छैन ?';

  @override
  String get authRegisterNow => 'नयाँ खाता खोल्नुहोस्';

  @override
  String get authInvalidCredentials => 'गलत फोन नम्बर वा पासवर्ड।';

  @override
  String get phoneNumber => 'फोन नम्बर';

  @override
  String get phoneNumberHint => 'आफ्नो फोन नम्बर प्रविष्ट गर्नुहोस्';

  @override
  String get phoneNumberRequired => 'कृपया आफ्नो फोन नम्बर प्रविष्ट गर्नुहोस्';

  @override
  String get phoneNumberInvalid => 'कृपया मान्य फोन नम्बर प्रविष्ट गर्नुहोस्';

  @override
  String get password => 'पासवर्ड';

  @override
  String get passwordHint => 'आफ्नो पासवर्ड प्रविष्ट गर्नुहोस्';

  @override
  String get passwordRequired => 'कृपया आफ्नो पासवर्ड प्रविष्ट गर्नुहोस्';

  @override
  String get orDividerText => 'अथवा';

  @override
  String get authRegisterTitle => 'नयाँ खाता सिर्जना गर्नुहोस्';

  @override
  String get authRegisterDescription =>
      'जारी राख्न कृपया आफ्नो फोन नम्बर प्रविष्ट गर्नुहोस्। हामी तपाईंको खाताको प्रमाणीकरणका लागि OTP कोड पठाउनेछौँ।';

  @override
  String get authRequestOtpButton => 'OTP अनुरोध गर्नुहोस्';

  @override
  String get authAlreadyHaveAccount => 'पहिले नै खाता छ?';

  @override
  String get authSignInNow => 'लगइन गर्नुहोस्';

  @override
  String get authOtpSent => 'OTP कोड तपाईंको फोन नम्बरमा पठाइएको छ।';

  @override
  String get authPhoneAlreadyRegistered =>
      'यो फोन नम्बर पहिले नै दर्ता भइसकेको छ।';

  @override
  String get authPhoneNotRegistered => 'यो फोन नम्बर दर्ता भएको छैन।';

  @override
  String authOtpThrottled(Object seconds) {
    return 'कृपया पुनः कोड पठाउनु अघि $seconds सेकेन्ड पर्खनुहोस्।';
  }

  @override
  String get authOtpSendFailed => 'OTP पठाउन सकिएन।';

  @override
  String get authOtpInvalid => 'प्रमाणीकरण कोड गलत छ।';

  @override
  String get authOtpResent => 'OTP कोड पुनः तपाईंको फोन नम्बरमा पठाइएको छ।';

  @override
  String get authOtpTitle => 'प्रमाणीकरण कोड';

  @override
  String authOtpDescription(Object phoneNumber) {
    return 'कृपया $phoneNumber मा पठाइएको ६ अङ्कको प्रमाणीकरण कोड प्रविष्ट गर्नुहोस्।';
  }

  @override
  String get authVerificationExpired =>
      'तपाईंको प्रमाणीकरण समाप्त भयो। कृपया आफ्नो नम्बर फेरि प्रमाणित गर्नुहोस्।';

  @override
  String get authVerifyButton => 'प्रमाणित गर्नुहोस्';

  @override
  String get authDidNotReceiveOtp => 'OTP प्राप्त भएन ?';

  @override
  String authResendInSeconds(Object seconds) {
    return 'कृपया पुनः प्रयास गर्न $seconds सेकेन्ड पर्खनुहोस्।';
  }

  @override
  String get authResendButton => 'पुनः पठाउनुहोस्';

  @override
  String get authOtpTooManyAttempts =>
      'धेरै पटक गलत OTP प्रविष्ट गरिएको छ। कृपया नयाँ OTP अनुरोध गरी पुनः प्रयास गर्नुहोस्।';

  @override
  String get authOtpExpired =>
      'OTP कोडको म्याद समाप्त भएको छ। कृपया नयाँ OTP अनुरोध गर्नुहोस्।';

  @override
  String get authCreateAccountTitle => 'खाता सिर्जना गर्नुहोस्';

  @override
  String get authCreateAccountDescription =>
      'तलका विवरणहरू भरी आफ्नो Smart Kishan खाता सिर्जना गर्नुहोस् र सेवाहरूको प्रयोग सुरु गर्नुहोस्।';

  @override
  String get authAccountCreated => 'तपाईंको खाता सफलतापूर्वक सिर्जना गरिएको छ!';

  @override
  String get authForgotPasswordTitle => 'पासवर्ड बिर्सनुभयो?';

  @override
  String get authForgotPasswordDescription =>
      'पासवर्ड रिसेट गर्न OTP कोड प्राप्त गर्न आफ्नो फोन नम्बर प्रविष्ट गर्नुहोस्।';

  @override
  String get authRememberedPassword => 'पासवर्ड सम्झनुभयो?';

  @override
  String get fullNameLabel => 'पूरा नाम';

  @override
  String get fullNameHint => 'आफ्नो पूरा नाम प्रविष्ट गर्नुहोस्';

  @override
  String get fullNameRequired => 'कृपया आफ्नो पूरा नाम प्रविष्ट गर्नुहोस्';

  @override
  String get fullNameInvalid =>
      'कृपया मान्य पूरा नाम प्रविष्ट गर्नुहोस् (कम्तीमा ३ अक्षर)।';

  @override
  String get emailLabel => 'ईमेल ठेगाना';

  @override
  String get emailHint => 'आफ्नो ईमेल ठेगाना प्रविष्ट गर्नुहोस्';

  @override
  String get emailInvalid => 'कृपया मान्य ईमेल ठेगाना प्रविष्ट गर्नुहोस्।';

  @override
  String get passwordTooShort => 'पासवर्ड कम्तीमा ८ अक्षर लामो हुनुपर्छ।';

  @override
  String get confirmPasswordLabel => 'पासवर्ड पुष्टि गर्नुहोस्';

  @override
  String get confirmPasswordHint => 'पुनः आफ्नो पासवर्ड प्रविष्ट गर्नुहोस्';

  @override
  String get confirmPasswordRequired => 'कृपया पासवर्ड पुष्टि गर्नुहोस्।';

  @override
  String get confirmPasswordInvalid => 'पासवर्ड मेल खाएन।';

  @override
  String get authCreateAccountButton => 'खाता सिर्जना गर्नुहोस्';

  @override
  String get authBackToLogin => 'लगइन पृष्ठमा फर्कनुहोस्';

  @override
  String get authEmailAlreadyRegistered =>
      'यो ईमेल ठेगाना पहिले नै दर्ता भएको छ।';

  @override
  String get authInvalidRegistrationData =>
      'प्रदान गरिएको दर्ता विवरण मान्य छैन। कृपया आफ्नो विवरण जाँच गरी पुनः प्रयास गर्नुहोस्।';

  @override
  String get inventory => 'मौज्दात';

  @override
  String get dailyActivities => 'दैनिक गतिविधिहरू';

  @override
  String get farmLands => 'खेतबारी';

  @override
  String get notes => 'टिपोटहरू';

  @override
  String get crops => 'बालीहरू';

  @override
  String get kalimatiPrice => 'कालीमाटी मूल्य सूची';

  @override
  String get users => 'प्रयोगकर्ताहरू';

  @override
  String get subsidies => 'अनुदानहरू';

  @override
  String get weatherPesticideRecommended =>
      'आज विषादी प्रयोग गर्न उपयुक्त दिन हो।';

  @override
  String get weatherPesticideNotRecommended =>
      'आज विषादी प्रयोग गर्न उपयुक्त दिन होइन।';

  @override
  String get weatherHumidity => 'आर्द्रता';

  @override
  String get weatherThunderstorm => 'चट्याङ';

  @override
  String get weatherDrizzle => 'सिमसिम वर्षा';

  @override
  String get weatherRain => 'वर्षा';

  @override
  String get weatherSnow => 'हिमपात';

  @override
  String get weatherClear => 'सफा आकाश';

  @override
  String get weatherClouds => 'बदली';

  @override
  String get weatherMist => 'तुवाँलो';

  @override
  String get weatherHaze => 'धुम्म';

  @override
  String get weatherFog => 'कुहिरो';

  @override
  String get navigationHome => 'गृहपृष्ठ';

  @override
  String get navigationChart => 'चार्ट';

  @override
  String get navigationUsers => 'प्रयोगकर्ताहरू';

  @override
  String get navigationProfile => 'प्रोफाइल';

  @override
  String get marketplaceBuyerMode => 'खरिदकर्ता मोड';

  @override
  String get marketplaceSellerMode => 'विक्रेता मोड';

  @override
  String get authLogout => 'लगआउट गर्नुहोस्';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get profileEdit => 'प्रोफाइल सम्पादन गर्नुहोस्';

  @override
  String get profileUpdate => 'प्रोफाइल अद्यावधिक गर्नुहोस्';

  @override
  String get profileUpdatedSuccessfully =>
      'प्रोफाइल सफलतापूर्वक अद्यावधिक गरियो।';

  @override
  String get profileUpdateFailed => 'प्रोफाइल अद्यावधिक गर्न सकिएन।';

  @override
  String get profileChangePassword => 'पासवर्ड परिवर्तन गर्नुहोस्';

  @override
  String get profileUpdateLocation => 'स्थान अद्यावधिक गर्नुहोस्';

  @override
  String get confirmLogout => 'लगआउट पुष्टि गर्नुहोस्';

  @override
  String get confirmLogoutMessage =>
      'के तपाईं निश्चित रूपमा लगआउट गर्न चाहनुहुन्छ?';

  @override
  String get notesSearchHint => 'नोटहरू खोज्नुहोस्';

  @override
  String get notesNoResults => 'कुनै नोट भेटिएन';

  @override
  String get notesAdd => 'नोट थप्नुहोस्';

  @override
  String get notesUpdate => 'नोट अद्यावधिक गर्नुहोस्';

  @override
  String get notesAddedSuccessfully => 'नोट सफलतापूर्वक थपियो।';

  @override
  String get notesUpdatedSuccessfully => 'नोट सफलतापूर्वक अद्यावधिक गरियो।';

  @override
  String get notesTitleLabel => 'नोट शीर्षक';

  @override
  String get notesTitleHint => 'नोटको शीर्षक प्रविष्ट गर्नुहोस्';

  @override
  String get notesTitleRequired => 'नोटको शीर्षक आवश्यक छ।';

  @override
  String get notesTitleInvalid => 'नोटको शीर्षक कम्तीमा ३ अक्षर लामो हुनुपर्छ।';

  @override
  String get notesDescriptionLabel => 'नोट विवरण';

  @override
  String get notesDescriptionHint => 'नोटको विवरण प्रविष्ट गर्नुहोस्';

  @override
  String get notesPriorityLabel => 'नोट प्राथमिकता';

  @override
  String get notesPriorityHint => 'नोटको प्राथमिकता प्रविष्ट गर्नुहोस्';

  @override
  String get notesDeleteConfirmTitle => 'मेटाउने पुष्टि गर्नुहोस्';

  @override
  String get notesDeleteConfirmMessage =>
      'के तपाईं यो नोट मेटाउन निश्चित हुनुहुन्छ? यो कार्य पूर्ववत गर्न सकिँदैन।';

  @override
  String get notesEmpty => 'तपाईंसँग हाल कुनै नोट छैन !';

  @override
  String get notesEmptyDescription =>
      'आफ्ना महत्त्वपूर्ण विचार र जानकारी सुरक्षित राख्न नोटहरू थप्नुहोस्।';

  @override
  String get commonAdd => 'थप्नुहोस्';

  @override
  String get commonUpdate => 'अद्यावधिक गर्नुहोस्';

  @override
  String get commonDelete => 'मेटाउनुहोस्';

  @override
  String get commonRefresh => 'रिफ्रेस गर्नुहोस्';

  @override
  String get commonCancel => 'रद्द गर्नुहोस्';

  @override
  String get commonEdit => 'सम्पादन गर्नुहोस्';

  @override
  String get commonSearch => 'खोज्नुहोस्';

  @override
  String get commonNoResults => 'कुनै नतिजा भेटिएन';

  @override
  String get commonDocument => 'कागजात';

  @override
  String get commonPdfError => 'कागजात लोड गर्न सकिएन';

  @override
  String get income => 'आम्दानी';

  @override
  String get expense => 'खर्च';

  @override
  String get quickActions => 'द्रुत कार्यहरू';

  @override
  String get inventoryItemAdd => 'जिन्सी सामान थप्नुहोस्';

  @override
  String get inventoryItemUpdate => 'जिन्सी सामान अद्यावधिक गर्नुहोस्';

  @override
  String get inventoryItemEmpty => 'तपाईंसँग हाल कुनै जिन्सी सामान छैन!';

  @override
  String get inventoryItemEmptyDescription =>
      'नयाँ जिन्सी सामान थप्न तलको बटनमा क्लिक गर्नुहोस्।';

  @override
  String get inventoryItemNameLabel => 'जिन्सी सामानको नाम';

  @override
  String get inventoryItemNameHint => 'जिन्सी सामानको नाम प्रविष्ट गर्नुहोस्';

  @override
  String get inventoryItemNameRequired => 'जिन्सी सामानको नाम आवश्यक छ।';

  @override
  String get inventoryItemNameInvalid =>
      'जिन्सी सामानको नाम कम्तीमा ३ अक्षर लामो हुनुपर्छ।';

  @override
  String get inventoryItemStockLabel => 'मौज्दात';

  @override
  String get inventoryItemStockHint => 'मौज्दात प्रविष्ट गर्नुहोस्';

  @override
  String get inventoryItemStockRequired => 'मौज्दात आवश्यक छ।';

  @override
  String get inventoryItemUnitLabel => 'एकाइ';

  @override
  String get inventoryItemUnitRequired => 'कृपया एकाइ चयन गर्नुहोस्।';

  @override
  String get inventoryItemDescriptionLabel => 'जिन्सी सामानको विवरण';

  @override
  String get inventoryItemDescriptionHint =>
      'जिन्सी सामानको विवरण प्रविष्ट गर्नुहोस्';

  @override
  String get inventoryItemTradeOptionLabel => 'खरिद/बिक्री विकल्प';

  @override
  String get inventoryItemBuy => 'खरिद';

  @override
  String get inventoryItemSell => 'बिक्री';

  @override
  String get inventoryItemBoth => 'दुवै';

  @override
  String get inventoryItemDeleteConfirmTitle => 'मेटाउने पुष्टि गर्नुहोस्';

  @override
  String get inventoryItemDeleteConfirmMessage =>
      'के तपाईं यो जिन्सी सामान मेटाउन निश्चित हुनुहुन्छ?';

  @override
  String get inventoryItemAddedSuccessfully =>
      'जिन्सी सामान सफलतापूर्वक थपियो।';

  @override
  String get inventoryItemUpdatedSuccessfully =>
      'जिन्सी सामान सफलतापूर्वक अद्यावधिक गरियो।';

  @override
  String get dailyActivityAdd => 'गतिविधि थप्नुहोस्';

  @override
  String get dailyActivityUpdate => 'गतिविधि अद्यावधिक गर्नुहोस्';

  @override
  String get dailyActivityAddedSuccessfully => 'गतिविधि सफलतापूर्वक थपियो।';

  @override
  String get dailyActivityUpdatedSuccessfully =>
      'गतिविधि सफलतापूर्वक अद्यावधिक गरियो।';

  @override
  String get dailyActivityEmpty => 'तपाईंसँग हाल कुनै गतिविधि छैन!';

  @override
  String get dailyActivityEmptyDescription =>
      'आफ्ना दैनिक खरिद, बिक्री तथा अन्य खेतीसम्बन्धी गतिविधिहरू यहाँ अभिलेख गर्नुहोस्।';

  @override
  String get dailyActivityTitleLabel => 'गतिविधि शीर्षक';

  @override
  String get dailyActivityTitleHint => 'गतिविधि शीर्षक लेख्नुहोस्';

  @override
  String get dailyActivityTitleRequired => 'कृपया गतिविधिको शीर्षक लेख्नुहोस्।';

  @override
  String get dailyActivityDescriptionLabel => 'विवरण';

  @override
  String get dailyActivityDescriptionHint => 'विवरण लेख्नुहोस्';

  @override
  String get dailyActivityTypeLabel => 'गतिविधिको प्रकार';

  @override
  String get dailyActivityBuy => 'खरिद';

  @override
  String get dailyActivitySell => 'बिक्री';

  @override
  String get dailyActivityOther => 'अन्य';

  @override
  String get dailyActivityInventoryItemLabel => 'जिन्सी सामान';

  @override
  String get dailyActivityInventoryItemHint => 'जिन्सी सामान छान्नुहोस्';

  @override
  String get dailyActivityInventoryItemRequired =>
      'कृपया जिन्सी सामान छान्नुहोस्।';

  @override
  String get dailyActivityQuantityLabel => 'परिमाण';

  @override
  String get dailyActivityQuantityHint => 'परिमाण लेख्नुहोस्';

  @override
  String get dailyActivityQuantityRequired => 'कृपया परिमाण लेख्नुहोस्।';

  @override
  String get dailyActivitySalePriceLabel => 'बिक्री मूल्य';

  @override
  String get dailyActivityCostPriceLabel => 'लागत मूल्य';

  @override
  String get dailyActivityAmountHint => '०.००';

  @override
  String get dailyActivityAmountRequired => 'कृपया रकम लेख्नुहोस्।';

  @override
  String get dailyActivityDeleteConfirmTitle => 'गतिविधि मेटाउनुहोस्';

  @override
  String get dailyActivityDeleteConfirmMessage =>
      'के तपाईं यो गतिविधि मेटाउन निश्चित हुनुहुन्छ? यो कार्य फिर्ता गर्न सकिँदैन।';

  @override
  String get currencySymbol => 'रु.';

  @override
  String get dailyActivityExpenseLabel => 'खर्च (छ भने)';

  @override
  String get dailyActivityIncomeLabel => 'आम्दानी (छ भने)';

  @override
  String get myIncome => 'मेरो आम्दानी';

  @override
  String get myExpense => 'मेरो खर्च';

  @override
  String get financialRecords => 'आर्थिक अभिलेख';

  @override
  String get financialRecordsEmpty => 'यस अवधिमा कुनै अभिलेख फेला परेन।';

  @override
  String get chartScreenTitle => 'लेखा चार्ट';

  @override
  String get chartIncomeAnalysis => 'आम्दानी विश्लेषण';

  @override
  String get chartExpenseAnalysis => 'खर्च विश्लेषण';

  @override
  String get chartIncomeEmpty => 'अहिलेसम्म कुनै आम्दानी रेकर्ड छैन।';

  @override
  String get chartExpenseEmpty => 'अहिलेसम्म कुनै खर्च रेकर्ड छैन।';

  @override
  String get chartFilterDaily => 'दैनिक';

  @override
  String get chartFilterMonthly => 'मासिक';

  @override
  String get chartFilterYearly => 'वार्षिक';

  @override
  String get chartLast7Days => 'पछिल्लो ७ दिन';

  @override
  String get chartLast7Months => 'पछिल्लो ७ महिना';

  @override
  String get chartLast5Years => 'पछिल्लो ५ वर्ष';

  @override
  String get chartNoDateFound => 'मिति फेला परेन।';

  @override
  String chartIncomeTitle(Object period) {
    return '$period आम्दानी चार्ट';
  }

  @override
  String chartExpenseTitle(Object period) {
    return '$period खर्च चार्ट';
  }

  @override
  String chartIncomeExpenseTitle(Object period) {
    return '$period आम्दानी/खर्च चार्ट';
  }

  @override
  String get farmlandAdd => 'खेतबारी थप्नुहोस्';

  @override
  String get farmlandUpdate => 'खेतबारी अद्यावधिक गर्नुहोस्';

  @override
  String get farmlandAddedSuccessfully => 'खेतबारी सफलतापूर्वक थपियो।';

  @override
  String get farmlandUpdatedSuccessfully =>
      'खेतबारी सफलतापूर्वक अद्यावधिक गरियो।';

  @override
  String get farmlandEmpty => 'तपाईंसँग हाल कुनै खेतबारी छैन!';

  @override
  String get farmlandEmptyDescription =>
      'आफ्नो खेतबारी स्थान र माटोको विवरणसहित थप्नुहोस्।';

  @override
  String get farmlandAddImage => 'खेतबारीको फोटो थप्नुहोस्';

  @override
  String get farmlandNameLabel => 'खेतबारीको नाम';

  @override
  String get farmlandNameHint => 'खेतबारीको नाम लेख्नुहोस्';

  @override
  String get farmlandNameRequired => 'कृपया खेतबारीको नाम लेख्नुहोस्।';

  @override
  String get farmlandNameInvalid =>
      'खेतबारीको नाम कम्तीमा ३ अक्षर लामो हुनुपर्छ।';

  @override
  String get farmlandDescriptionLabel => 'विवरण';

  @override
  String get farmlandDescriptionHint => 'विवरण लेख्नुहोस्';

  @override
  String get farmlandLocationSection => 'स्थान';

  @override
  String get farmlandUseMyLocation => 'मेरो स्थान प्रयोग गर्नुहोस्';

  @override
  String get farmlandLatLabel => 'अक्षांश';

  @override
  String get farmlandLatHint => 'अक्षांश लेख्नुहोस्';

  @override
  String get farmlandLngLabel => 'देशान्तर';

  @override
  String get farmlandLngHint => 'देशान्तर लेख्नुहोस्';

  @override
  String get farmlandCoordinatesRequired =>
      'कृपया पहिले अक्षांश र देशान्तर लेख्नुहोस्।';

  @override
  String get farmlandSoilSection => 'माटोको गुण';

  @override
  String get farmlandAutoFetch => 'स्वतः प्राप्त गर्नुहोस्';

  @override
  String get farmlandSoilFetchFailed => 'माटोको डाटा प्राप्त गर्न सकिएन।';

  @override
  String get farmlandNitrogen => 'नाइट्रोजन (%)';

  @override
  String get farmlandOrganicMatter => 'जैविक पदार्थ (%)';

  @override
  String get farmlandPhosphate => 'फस्फेट (किलोग्राम/हेक्टर)';

  @override
  String get farmlandPotassium => 'पोटासियम';

  @override
  String get farmlandPH => 'पीएच';

  @override
  String get farmlandLocationChip => 'स्थान';

  @override
  String get farmlandSoilChip => 'माटो';

  @override
  String get farmlandDeleteConfirmTitle => 'खेतबारी मेटाउनुहोस्';

  @override
  String get farmlandDeleteConfirmMessage =>
      'के तपाईं यो खेतबारी मेटाउन निश्चित हुनुहुन्छ? यो कार्य फिर्ता गर्न सकिँदैन।';

  @override
  String get imageUploadAdd => 'फोटो थप्नुहोस्';

  @override
  String get mediaPickerTitle => 'स्रोत छान्नुहोस्';

  @override
  String get mediaPickerCamera => 'क्यामेरा';

  @override
  String get mediaPickerGallery => 'ग्यालेरी';

  @override
  String get mediaPickerFiles => 'फाइलहरू';

  @override
  String get farmlandBasicInfoSection => 'आधारभूत जानकारी';

  @override
  String get farmlandAddressLabel => 'ठेगाना';

  @override
  String get farmlandAddressHint =>
      'स्वतः भर्न \'मेरो स्थान प्रयोग गर्नुहोस्\' थिच्नुहोस्, वा टाइप गर्नुहोस्';

  @override
  String get farmlandImageSection => 'खेतबारीको फोटो';

  @override
  String get farmlandRecommendedCrops => 'सिफारिश गरिएका बाली';

  @override
  String get farmlandRecommendedVegetables => 'तरकारीहरू';

  @override
  String get farmlandRecommendedFruits => 'फलफूलहरू';

  @override
  String get marketPrices => 'बजार मूल्य';

  @override
  String get marketPricesEmpty => 'कुनै बजार मूल्य उपलब्ध छैन';

  @override
  String get marketSearchHint => 'वस्तु खोज्नुहोस्...';

  @override
  String get marketLastUpdated => 'अन्तिम अद्यावधिक';

  @override
  String get marketNoResults => 'तपाईंको खोजसँग मिल्ने कुनै वस्तु छैन';

  @override
  String get minPrice => 'न्यूनतम मूल्य';

  @override
  String get maxPrice => 'अधिकतम मूल्य';

  @override
  String get avgPrice => 'औसत मूल्य';

  @override
  String get cropInfoTitle => 'बाली सम्बन्धी जानकारी';

  @override
  String get cropInfoSearchHint => 'बाली खोज्नुहोस्...';

  @override
  String get cropInfoEmpty => 'कुनै बाली जानकारी उपलब्ध छैन';

  @override
  String get cropInfoNoResults => 'तपाईंको खोजसँग मिल्ने बाली छैन';

  @override
  String get cropInfoBannerTitle => 'बाली जानकारी';

  @override
  String get cropInfoBannerSubtitle => 'आफ्ना बाली कसरी उब्जाउने जान्नुहोस्';

  @override
  String get cropInfoBannerExplore => 'बालीहरू हेर्नुहोस्';

  @override
  String get drawerSectionMain => 'मुख्य';

  @override
  String get drawerSectionServices => 'सेवाहरू';

  @override
  String get modeFarmer => 'किसान';

  @override
  String get modeVendor => 'विक्रेता';

  @override
  String get modeBuyer => 'क्रेता';

  @override
  String get governmentServices => 'सरकारी सेवाहरू';

  @override
  String get homeServiceCentersTitle => 'सेवा केन्द्रहरू';

  @override
  String get homeServiceCentersSubtitle => 'नजिकका सरकारी कार्यालयहरू';

  @override
  String get homeServiceCentersBadge => 'कार्यालय';

  @override
  String get homeSubsidiesTitle => 'अनुदान';

  @override
  String get homeSubsidiesSubtitle => 'उपलब्ध अनुदानहरू हेर्नुहोस्';

  @override
  String get homeSubsidiesBadge => 'अनुदान';

  @override
  String get homeComplaintsTitle => 'गुनासो';

  @override
  String get homeComplaintsSubtitle => 'समस्या रिपोर्ट गर्नुहोस्';

  @override
  String get homeComplaintsBadge => 'रिपोर्ट';

  @override
  String get homeSurveysTitle => 'सर्वेक्षण';

  @override
  String get homeSurveysSubtitle => 'आफ्नो प्रतिक्रिया दिनुहोस्';

  @override
  String get homeSurveysBadge => 'प्रतिक्रिया';

  @override
  String get serviceCenters => 'सेवा केन्द्रहरू';

  @override
  String get listView => 'सूची';

  @override
  String get mapView => 'नक्सा';

  @override
  String get filters => 'फिल्टर';

  @override
  String get filtersAndSort => 'फिल्टर र क्रमबद्धता';

  @override
  String get sortBy => 'क्रमबद्ध गर्नुहोस्';

  @override
  String get clearAll => 'सबै हटाउनुहोस्';

  @override
  String get applyFilters => 'फिल्टर लागू गर्नुहोस्';

  @override
  String get searchServiceCentersHint => 'सेवा केन्द्र खोज्नुहोस्...';

  @override
  String get searchRadius => 'खोज दायरा';

  @override
  String get showFeaturedOnly => 'केवल विशेष देखाउनुहोस्';

  @override
  String get distance => 'दूरी';

  @override
  String get name => 'नाम';

  @override
  String get rating => 'रेटिङ';

  @override
  String get newest => 'नवीनतम';

  @override
  String get featured => 'विशेष';

  @override
  String get top5ByDistance => 'दूरी अनुसार शीर्ष ५';

  @override
  String get top5ByName => 'नाम अनुसार शीर्ष ५';

  @override
  String get top5ByRating => 'रेटिङ अनुसार शीर्ष ५';

  @override
  String get top5Newest => 'नवीनतम शीर्ष ५';

  @override
  String get details => 'विवरण';

  @override
  String get viewOnMap => 'नक्सामा हेर्नुहोस्';

  @override
  String get viewDetails => 'विवरण हेर्नुहोस्';

  @override
  String get loadingRoute => 'मार्ग लोड हुँदैछ...';

  @override
  String get routeLoaded => 'मार्ग लोड भयो';

  @override
  String get routeUnavailable => 'मार्ग उपलब्ध छैन';

  @override
  String get directions => 'दिशानिर्देश';

  @override
  String get noServiceCentersFound => 'कुनै सेवा केन्द्र भेटिएन';

  @override
  String get tryAdjustingFilters => 'फिल्टर वा खोज परिवर्तन गरी हेर्नुहोस्';

  @override
  String get serviceCenterNotFound => 'सेवा केन्द्र भेटिएन';

  @override
  String get km => 'कि.मि.';

  @override
  String get away => 'टाढा';

  @override
  String get notApplicable => 'लागू हुँदैन';

  @override
  String wardNo(String no) {
    return 'वडा नं: $no';
  }

  @override
  String get contactInformation => 'सम्पर्क जानकारी';

  @override
  String get phone => 'फोन';

  @override
  String get website => 'वेबसाइट';

  @override
  String get contactPerson => 'सम्पर्क व्यक्ति';

  @override
  String get operatingHours => 'खुल्ने समय';

  @override
  String get servicesOffered => 'उपलब्ध सेवाहरू';

  @override
  String get basedOnUserReviews => 'प्रयोगकर्ता समीक्षामा आधारित';

  @override
  String get ratingSingular => 'रेटिङ';

  @override
  String get ratingPlural => 'रेटिङहरू';

  @override
  String get recentReviews => 'हालका समीक्षाहरू';

  @override
  String get yourRating => 'तपाईंको रेटिङ';

  @override
  String get helpOthersRate =>
      'यो सेवा केन्द्रलाई रेटिङ दिएर अरूलाई सहयोग गर्नुहोस्';

  @override
  String get addYourRating => 'रेटिङ थप्नुहोस्';

  @override
  String get editRating => 'सम्पादन';

  @override
  String get rateServiceCenter => 'सेवा केन्द्रलाई रेटिङ दिनुहोस्';

  @override
  String get editYourRating => 'आफ्नो रेटिङ सम्पादन गर्नुहोस्';

  @override
  String get writeReviewOptional => 'समीक्षा लेख्नुहोस् (वैकल्पिक)';

  @override
  String get shareYourExperienceHint => 'आफ्नो अनुभव साझा गर्नुहोस्...';

  @override
  String get submit => 'पेश गर्नुहोस्';

  @override
  String get deleteRatingQuestion => 'रेटिङ हटाउने?';

  @override
  String get deleteRatingReviewConfirm =>
      'के तपाईं आफ्नो रेटिङ र समीक्षा हटाउन निश्चित हुनुहुन्छ? यो कार्य फिर्ता गर्न सकिँदैन।';

  @override
  String get ratingSubmittedSuccess => 'रेटिङ सफलतापूर्वक पेश भयो!';

  @override
  String get ratingUpdatedSuccess => 'रेटिङ सफलतापूर्वक अद्यावधिक भयो!';

  @override
  String get anonymous => 'अज्ञात';

  @override
  String get ago => 'अघि';

  @override
  String get commonMinuteUnit => 'मिनेट';

  @override
  String get commonHourUnit => 'घण्टा';

  @override
  String get commonDayUnit => 'दिन';

  @override
  String get commonDaysUnit => 'दिन';

  @override
  String get commonWeekUnit => 'हप्ता';

  @override
  String get commonWeeksUnit => 'हप्ता';

  @override
  String get commonAll => 'सबै';

  @override
  String get basicInformation => 'आधारभूत जानकारी';

  @override
  String get ratingDeletedSuccess => 'रेटिङ सफलतापूर्वक हटाइयो!';

  @override
  String get resetPasswordTitle => 'पासवर्ड रिसेट गर्नुहोस्';

  @override
  String get resetPasswordDesc => 'आफ्नो खाताको लागि नयाँ पासवर्ड बनाउनुहोस्।';

  @override
  String get newPassword => 'नयाँ पासवर्ड';

  @override
  String get inputPassword => 'आफ्नो पासवर्ड प्रविष्ट गर्नुहोस्';

  @override
  String get confirmPassword => 'पासवर्ड पुष्टि गर्नुहोस्';

  @override
  String get inputConfirmPassword => 'आफ्नो पासवर्ड पुनः प्रविष्ट गर्नुहोस्';

  @override
  String get inputPasswordMsg => 'कृपया आफ्नो पासवर्ड प्रविष्ट गर्नुहोस्';

  @override
  String get passwordMismatch => 'पासवर्डहरू मिलेनन्।';

  @override
  String get passwordResetSuccess => 'तपाईंको पासवर्ड सफलतापूर्वक रिसेट भयो!';

  @override
  String get passwordResetFailed =>
      'पासवर्ड रिसेट गर्न असफल भयो। कृपया पुनः प्रयास गर्नुहोस्।';

  @override
  String get subsidyUntitled => 'शीर्षकविहीन';

  @override
  String get subsidyActive => 'सक्रिय';

  @override
  String get subsidyApplied => 'आवेदन दिइएको';

  @override
  String get subsidyApplyNow => 'आवेदन दिनुहोस्';

  @override
  String get subsidyAlreadyApplied => 'पहिले नै आवेदन दिइएको';

  @override
  String get subsidyExpired => 'म्याद सकियो';

  @override
  String get subsidyDeadline => 'अन्तिम मिति';

  @override
  String get subsidyEligibility => 'योग्यता मापदण्ड';

  @override
  String get subsidyTargetSector => 'लक्षित बाली/क्षेत्र';

  @override
  String get subsidyLocationLevel => 'स्तर';

  @override
  String get subsidyNoInfo => 'उपलब्ध छैन';

  @override
  String get subsidyMore => 'थप';

  @override
  String get subsidyLess => 'कम';

  @override
  String get subsidyNoneAvailable => 'हाल कुनै सब्सिडी उपलब्ध छैन';

  @override
  String get subsidyMyApplications => 'मेरा आवेदनहरू';

  @override
  String get subsidyRequestSubsidy => 'सब्सिडी अनुरोध';

  @override
  String get subsidyLocationRequired => 'स्थान आवश्यक';

  @override
  String get subsidyLocationRequiredDescription =>
      'तपाईंको क्षेत्रका सब्सिडीहरू हेर्न, पहिले आफ्नो प्रोफाइलमा स्थान थप्नुहोस्।';

  @override
  String get subsidyAddLocation => 'स्थान थप्नुहोस्';

  @override
  String get subsidyTypeFertilizer => 'मल';

  @override
  String get subsidyTypeEquipment => 'उपकरण';

  @override
  String get subsidyTypeTraining => 'तालिम';

  @override
  String get subsidyTypeIrrigation => 'सिँचाइ';

  @override
  String get subsidyTypeLivestock => 'पशुपन्छी';

  @override
  String get subsidyTypeSeeds => 'बीउ';

  @override
  String get subsidyTypeInsurance => 'बीमा';

  @override
  String get subsidyTypeLoan => 'ऋण';

  @override
  String get subsidyTypeOrganic => 'जैविक';

  @override
  String get subsidyTypeGeneral => 'सामान्य';

  @override
  String get subsidyLevelCentral => 'केन्द्रीय';

  @override
  String get subsidyLevelProvince => 'प्रदेश';

  @override
  String get subsidyLevelDistrict => 'जिल्ला';

  @override
  String get subsidyLevelMunicipality => 'नगरपालिका';

  @override
  String get subsidyLevelWard => 'वडा';

  @override
  String get subsidyDetails => 'सब्सिडी विवरण';

  @override
  String get subsidyDescription => 'विवरण';

  @override
  String get subsidyFiscalYear => 'आर्थिक वर्ष';

  @override
  String get subsidyExpectedBeneficiaries => 'अपेक्षित लाभग्राही';

  @override
  String get subsidyBudgetPerBeneficiary => 'प्रति लाभग्राही बजेट';

  @override
  String get subsidyTotalBudget => 'कुल बजेट';

  @override
  String get subsidyRequiredDocuments => 'आवश्यक कागजातहरू';

  @override
  String get subsidyAdminDocuments => 'सम्बन्धित कागजातहरू';

  @override
  String get subsidyLocationDetails => 'स्थान विवरण';

  @override
  String get subsidyProvince => 'प्रदेश';

  @override
  String get subsidyDistrict => 'जिल्ला';

  @override
  String get subsidyMunicipality => 'नगरपालिका';

  @override
  String get subsidyWard => 'वडा';

  @override
  String get subsidyDocRequired => 'अनिवार्य';

  @override
  String get subsidyDocOptional => 'वैकल्पिक';

  @override
  String get subsidyApplyTitle => 'सब्सिडीको लागि आवेदन';

  @override
  String get subsidyApplicationDetails => 'आवेदन विवरण';

  @override
  String get subsidyApplicationNotes => 'थप टिप्पणी';

  @override
  String get subsidyApplicationNotesHint =>
      'थप्न चाहनुभएको कुनै कुरा (वैकल्पिक)';

  @override
  String get subsidySubmitApplication => 'आवेदन पेश गर्नुहोस्';

  @override
  String get subsidyApplicationSuccess => 'आवेदन सफलतापूर्वक पेश गरियो';

  @override
  String get subsidyDocumentMissing =>
      'कृपया सबै आवश्यक कागजातहरू अपलोड गर्नुहोस्';

  @override
  String get subsidyInvalidFileType => 'अमान्य फाइल प्रकार';

  @override
  String get subsidyFileTooLarge => 'फाइल धेरै ठूलो छ';

  @override
  String get subsidyFieldRequired => 'यो फिल्ड आवश्यक छ';

  @override
  String get subsidyInvalidEmail => 'मान्य इमेल प्रविष्ट गर्नुहोस्';

  @override
  String get subsidyInvalidNumber => 'मान्य संख्या प्रविष्ट गर्नुहोस्';

  @override
  String get subsidyInvalidValue => 'अमान्य मान';

  @override
  String get subsidyApplyingFor => 'यसको लागि आवेदन';

  @override
  String get subsidyUploadFile => 'फाइल अपलोड गर्नुहोस्';

  @override
  String get subsidyChangeFile => 'फाइल परिवर्तन गर्नुहोस्';

  @override
  String get subsidyApplyReviewNotice =>
      'तपाईंको आवेदन समीक्षा गरिनेछ। कृपया सबै विवरण सही भएको सुनिश्चित गर्नुहोस्।';

  @override
  String get subsidyMaxSize => 'अधिकतम';

  @override
  String get subsidyPreview => 'पूर्वावलोकन';

  @override
  String get subsidyPreviewUnavailable =>
      'यो फाइल प्रकारको पूर्वावलोकन उपलब्ध छैन';

  @override
  String subsidyPleaseEnter(String field) {
    return '$field प्रविष्ट गर्नुहोस्';
  }

  @override
  String subsidyPleaseSelect(String field) {
    return '$field छान्नुहोस्';
  }

  @override
  String subsidyFieldRequiredNamed(String field) {
    return '$field आवश्यक छ';
  }

  @override
  String subsidyUploadingPercent(String percent) {
    return 'अपलोड हुँदै $percent%';
  }

  @override
  String get subsidyUploadingPleaseWait => 'अपलोड तयार गर्दै…';
}
