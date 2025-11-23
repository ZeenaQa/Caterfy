import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Caterfy'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Caterfy'**
  String get welcome;

  /// No description provided for @heyThere.
  ///
  /// In en, this message translates to:
  /// **'Hey there!'**
  String get heyThere;

  /// No description provided for @welcomeInstruction.
  ///
  /// In en, this message translates to:
  /// **'Log in or sign up to start ordering with Caterfy!'**
  String get welcomeInstruction;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhoneNumber;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Continue with phone number'**
  String get continueWithPhoneNumber;

  /// No description provided for @continueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with email'**
  String get continueWithEmail;

  /// No description provided for @continueAsVendor.
  ///
  /// In en, this message translates to:
  /// **'Continue as vendor'**
  String get continueAsVendor;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @becomeVendor.
  ///
  /// In en, this message translates to:
  /// **'Become a vendor'**
  String get becomeVendor;

  /// No description provided for @enterCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your email'**
  String get enterCodeSent;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code?'**
  String get didntReceiveCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @cancelVerificationQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the verification process?'**
  String get cancelVerificationQuestion;

  /// No description provided for @confirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get confirmCancel;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @joinCaterfy.
  ///
  /// In en, this message translates to:
  /// **'Join Caterfy'**
  String get joinCaterfy;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordRequirementTitle.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters and should include:'**
  String get passwordRequirementTitle;

  /// No description provided for @passwordRequirementUppercase.
  ///
  /// In en, this message translates to:
  /// **'• 1 uppercase letter (A-Z)'**
  String get passwordRequirementUppercase;

  /// No description provided for @passwordRequirementLowercase.
  ///
  /// In en, this message translates to:
  /// **'• 1 lowercase letter (a-z)'**
  String get passwordRequirementLowercase;

  /// No description provided for @passwordRequirementNumber.
  ///
  /// In en, this message translates to:
  /// **'• 1 number (0-9)'**
  String get passwordRequirementNumber;

  /// No description provided for @invalidOrExpiredCode.
  ///
  /// In en, this message translates to:
  /// **'The verification code is invalid or has expired'**
  String get invalidOrExpiredCode;

  /// No description provided for @emailVerified.
  ///
  /// In en, this message translates to:
  /// **'Email verified successfully'**
  String get emailVerified;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset, sign in with the new password!'**
  String get passwordResetSuccess;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get somethingWentWrong;

  /// No description provided for @cancelPasswordResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel password reset'**
  String get cancelPasswordResetTitle;

  /// No description provided for @cancelPasswordResetMessage.
  ///
  /// In en, this message translates to:
  /// **'This will cancel the password reset process'**
  String get cancelPasswordResetMessage;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @businessInformation.
  ///
  /// In en, this message translates to:
  /// **'Business Information'**
  String get businessInformation;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get businessName;

  /// No description provided for @enterBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Enter your business name'**
  String get enterBusinessName;

  /// No description provided for @businessType.
  ///
  /// In en, this message translates to:
  /// **'Business Type'**
  String get businessType;

  /// No description provided for @setYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Set Your Password'**
  String get setYourPassword;

  /// No description provided for @restaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurant;

  /// No description provided for @cafe.
  ///
  /// In en, this message translates to:
  /// **'Cafe'**
  String get cafe;

  /// No description provided for @bakery.
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get bakery;

  /// No description provided for @grocery.
  ///
  /// In en, this message translates to:
  /// **'Grocery'**
  String get grocery;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search Caterfy'**
  String get search;

  /// No description provided for @deliverTo.
  ///
  /// In en, this message translates to:
  /// **'Deliver to'**
  String get deliverTo;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account info'**
  String get accountInfo;

  /// No description provided for @savedAddresses.
  ///
  /// In en, this message translates to:
  /// **'Saved addresses'**
  String get savedAddresses;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get changeEmail;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @logOutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logOutConfirmation;

  /// No description provided for @yourOrders.
  ///
  /// In en, this message translates to:
  /// **'Your orders'**
  String get yourOrders;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @vouchers.
  ///
  /// In en, this message translates to:
  /// **'Vouchers'**
  String get vouchers;

  /// No description provided for @getHelp.
  ///
  /// In en, this message translates to:
  /// **'Get help'**
  String get getHelp;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About app'**
  String get aboutApp;

  /// No description provided for @caterfyPay.
  ///
  /// In en, this message translates to:
  /// **'Caterfy pay'**
  String get caterfyPay;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @firstLastName.
  ///
  /// In en, this message translates to:
  /// **'First and last name'**
  String get firstLastName;

  /// No description provided for @jd.
  ///
  /// In en, this message translates to:
  /// **'jd'**
  String get jd;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrdersYet;

  /// No description provided for @noOrdersTip.
  ///
  /// In en, this message translates to:
  /// **'When you place your first order, it will appear here.'**
  String get noOrdersTip;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @invalidEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidEmailOrPassword;

  /// No description provided for @emptyField.
  ///
  /// In en, this message translates to:
  /// **'Field can\'t be empty'**
  String get emptyField;

  /// No description provided for @shortPassword.
  ///
  /// In en, this message translates to:
  /// **'Must be at least 8 characters long'**
  String get shortPassword;

  /// No description provided for @oneUppercase.
  ///
  /// In en, this message translates to:
  /// **'Must include at least one uppercase letter'**
  String get oneUppercase;

  /// No description provided for @oneNumber.
  ///
  /// In en, this message translates to:
  /// **'Must include at least one number'**
  String get oneNumber;

  /// No description provided for @passwordsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsNoMatch;

  /// No description provided for @invalidFields.
  ///
  /// In en, this message translates to:
  /// **'One or more fields are invalid'**
  String get invalidFields;

  /// No description provided for @verifCodeSent.
  ///
  /// In en, this message translates to:
  /// **'A verification code has been sent to your email'**
  String get verifCodeSent;

  /// No description provided for @emailInUse.
  ///
  /// In en, this message translates to:
  /// **'Email is already registered'**
  String get emailInUse;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @tryAgainIn.
  ///
  /// In en, this message translates to:
  /// **'Please try again in'**
  String get tryAgainIn;

  /// No description provided for @emailNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email'**
  String get emailNotFound;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Please select a type'**
  String get selectType;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
