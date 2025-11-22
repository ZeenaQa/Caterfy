// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Caterfy';

  @override
  String get welcome => 'Welcome to Caterfy';

  @override
  String get heyThere => 'Hey there!';

  @override
  String get welcomeInstruction =>
      'Log in or sign up to start ordering with Caterfy!';

  @override
  String get or => 'OR';

  @override
  String get login => 'Log in';

  @override
  String get signup => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithPhoneNumber => 'Continue with phone number';

  @override
  String get continueWithEmail => 'Continue with email';

  @override
  String get continueAsVendor => 'Continue as vendor';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light theme';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get createAccount => 'Create Account';

  @override
  String get enterCodeSent => 'Enter the code sent to your email';

  @override
  String get didntReceiveCode => 'Didn’t receive code?';

  @override
  String get resend => 'Resend';

  @override
  String get verification => 'Verification';

  @override
  String get cancelVerificationQuestion =>
      'Are you sure you want to cancel the verification process?';

  @override
  String get confirmCancel => 'Cancel';

  @override
  String get stay => 'Stay';

  @override
  String get name => 'Name';
  @override
  String get joinCaterfy => 'Join Caterfy';
  @override
  String get confirmPassword => 'Confirm Password';
  @override
  String get passwordRequirementTitle =>
      'Password must be at least 8 characters and should include:';

  @override
  String get passwordRequirementUppercase => '• 1 uppercase letter (A-Z)';

  @override
  String get passwordRequirementLowercase => '• 1 lowercase letter (a-z)';

  @override
  String get passwordRequirementNumber => '• 1 number (0-9)';
}
