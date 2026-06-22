import 'package:caterfy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VendorAuthProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  bool isLoading = false;

  String? signUpError;
  String? logInError;
  String? successMessage;
  String? businessNameError = '';
  String? businessTypeError = '';
  String? nameError;
  String? emailError;
  String? phoneError;
  String? passwordError;
  String? confirmPasswordError;
  bool forgotPassLoading = false;
  bool tokenIsLoading = false;
  // Persisted selections during signup
  String? storeType;
  String? businessType;

  // ---------------- Setters ----------------
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // ---------------- Selection setters ----------------
  void setStoreType(String? value) {
    storeType = value;
    notifyListeners();
  }

  void setBusinessType(String? value) {
    businessType = value;
    notifyListeners();
  }

  void setSignUpError(String? value) {
    signUpError = value;
    notifyListeners();
  }

  void setLogInError(String? value) {
    logInError = value;
    notifyListeners();
  }

  void setSuccessMessage(String? value) {
    successMessage = value;
    notifyListeners();
  }

  // ---------------- Validation ----------------
  String? validateEmail(String email, AppLocalizations l10) {
    if (email.isEmpty) {
      return l10.emptyField;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return l10.invalidEmail;
    }
    return null;
  }

  String? validatePassword(String password, AppLocalizations l10) {
    if (password.isEmpty) {
      return l10.emptyField;
    }
    if (password.length < 8) {
      return l10.shortPassword;
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return l10.oneUppercase;
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      return l10.oneNumber;
    }
    return null;
  }

  // --------------------------------------------------------

  bool validatePersonalInfo({
    required String name,
    required String email,
    required String phoneNumber,
    required AppLocalizations l10,
  }) {
    nameError = name.isEmpty ? l10.emptyField : null;

    if (email.isEmpty) {
      emailError = l10.emptyField;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emailError = l10.invalidEmail;
    } else {
      emailError = null;
    }

    phoneError = phoneNumber.isEmpty ? l10.emptyField : null;

    notifyListeners();

    return nameError == null && emailError == null && phoneError == null;

    // --------------------------------------------------------
  }

  bool validateBusinessInfo({
    required String businessName,
    required String businessType,
    required AppLocalizations l10,
  }) {
    businessNameError = businessName.isEmpty ? l10.emptyField : null;
    businessTypeError = businessType.isEmpty ? l10.selectType : null;

    notifyListeners();

    return businessNameError == null && businessTypeError == null;
  }

  // --------------------------------------------------------

  bool validatePasswordInfo({
    required String password,
    required String confirmPassword,
    required AppLocalizations l10,
  }) {
    passwordError = validatePassword(password, l10);
    confirmPasswordError = password != confirmPassword
        ? l10.passwordsNoMatch
        : null;

    notifyListeners();

    return passwordError == null && confirmPasswordError == null;
  }

  // ---------------- Submit Application ----------------
  Future<bool> submitApplication({
    required String email,
    required String name,
    required String phoneNumber,
    required String businessName,
    required String businessType,
    required String storeType,
    required String password,
    required BuildContext context,
  }) async {
    final l10 = AppLocalizations.of(context);
    try {
      setLoading(true);
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'role': 'vendor',
          'business_name': businessName,
          'business_type': businessType,
          'store_type': storeType,
        },
      );

      final userID = response.user?.id;

      if (userID != null) {
        await supabase
            .from('vendors')
            .update({'phone': phoneNumber})
            .eq('id', userID);
      }

      return true;
    } catch (e) {
      debugPrint('❌ submitApplication error: $e');
      setSignUpError(l10.somethingWentWrong);
      return false;
    } finally {
      setLoading(false);
    }
  }

  // ---------------- Log In ----------------
  Future<bool> logIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final l10 = AppLocalizations.of(context);
    emailError = email.isEmpty ? l10.emptyField : null;
    passwordError = password.isEmpty ? l10.emptyField : null;

    notifyListeners();
    if (emailError != null || passwordError != null) {
      return false;
    }

    try {
      setLoading(true);

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        emailError = l10.invalidEmailOrPassword;
        passwordError = l10.invalidEmailOrPassword;
        notifyListeners();
        return false;
      }

      return true;
    } on AuthApiException {
      emailError = l10.invalidEmailOrPassword;
      passwordError = l10.invalidEmailOrPassword;
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
    }
  }

  // ---------------- Forgot Password ----------------

  void setTokenIsLoading(bool value) {
    tokenIsLoading = value;
    notifyListeners();
  }

  Future<dynamic> sendForgotPasswordPassEmail({
    required String email,
    required BuildContext context,
  }) async {
    final l10 = AppLocalizations.of(context);
    try {
      final emailRes = validateEmail(email, l10);
      if (emailRes != null) {
        emailError = emailRes;
        notifyListeners();
        return {'success': false, 'message': emailRes};
      }

      final response = await supabase
          .from('vendors')
          .select('id')
          .eq('email', email.trim())
          .maybeSingle();

      if (response == null) {
        emailError = l10.emailNotFound;
        notifyListeners();
        return {'success': false, 'message': l10.emailNotFound};
      }

      forgotPassLoading = true;
      notifyListeners();

      await supabase.auth.resetPasswordForEmail(email.trim());

      return {'success': true, 'message': 'Email sent successfully'};
    } on AuthApiException catch (e) {
      if (e.code == 'over_email_send_rate_limit') {
        final int? seconds = extractIntFromString(e.message);
        final errMsg = '${l10.tryAgainIn} $seconds ${l10.seconds}.';
        emailError = errMsg;
        notifyListeners();
        return {'success': false, 'message': errMsg};
      }
      emailError = l10.somethingWentWrong;
      notifyListeners();
      return {'success': false, 'message': l10.somethingWentWrong};
    } catch (e) {
      emailError = '${l10.somethingWentWrong} $e';
      notifyListeners();
      return {'success': false, 'message': l10.somethingWentWrong};
    } finally {
      forgotPassLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyResetPassEmail({
    required String email,
    required String token,
  }) async {
    try {
      tokenIsLoading = true;
      notifyListeners();
      await supabase.auth.verifyOTP(
        type: OtpType.recovery,
        token: token,
        email: email,
      );
      return true;
    } on AuthException {
      return false;
    } catch (e) {
      return false;
    } finally {
      tokenIsLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> resetPassword({
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    final l10 = AppLocalizations.of(context);
    try {
      passwordError = validatePassword(password, l10);
      confirmPasswordError = password != confirmPassword ? l10.passwordsNoMatch : null;

      if (passwordError != null || confirmPasswordError != null) {
        notifyListeners();
        return {'success': false, 'message': 'mismatch'};
      }

      isLoading = true;
      notifyListeners();
      await supabase.auth.updateUser(UserAttributes(password: password));
      return {'success': true, 'message': 'Password reset successfully.'};
    } on AuthApiException {
      return {'success': false, 'message': l10.somethingWentWrong};
    } catch (e) {
      return {'success': false, 'message': l10.somethingWentWrong};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- Phone ----------------
  int? extractIntFromString(String message) {
    final regex = RegExp(r'\d+');
    final match = regex.firstMatch(message);
    if (match != null) {
      return int.tryParse(match.group(0)!);
    }
    return null;
  }

  void clearErrors() {
    nameError = null;
    emailError = null;
    phoneError = null;
    passwordError = null;
    confirmPasswordError = null;
    signUpError = null;
    successMessage = null;
    businessNameError = null;
    businessTypeError = null;
    notifyListeners();
  }

  void clearEmailError() {
    if (emailError != null) {
      emailError = null;
      notifyListeners();
    }
  }

  void clearNameError() {
    if (nameError != null) {
      nameError = null;
      notifyListeners();
    }
  }

  void clearPhoneError() {
    if (phoneError != null) {
      phoneError = null;
      notifyListeners();
    }
  }

  void clearBusinessNameError() {
    if (businessNameError != null) {
      businessNameError = null;
      notifyListeners();
    }
  }

  void clearPassError() {
    if (passwordError != null) {
      passwordError = null;
      notifyListeners();
    }
  }

  void clearConfirmPassError() {
    if (confirmPasswordError != null) {
      confirmPasswordError = null;
      notifyListeners();
    }
  }

  void notifyLis() {
    notifyListeners();
  }
}
