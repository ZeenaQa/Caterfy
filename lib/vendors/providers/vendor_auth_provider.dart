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

  // ---------------- Setters ----------------
  void setLoading(bool value) {
    isLoading = value;
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

  // ---------------- Sign Up ----------------
  Future<bool> signUp({
    bool onlyPassword = false,
    required String email,
    required String name,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    required String businessName,
    required String businessType,
    required BuildContext context,
  }) async {
    final l10 = AppLocalizations.of(context);
    try {
      final isPasswordValid = validatePasswordInfo(
        password: password,
        confirmPassword: confirmPassword,
        l10: l10,
      );

      final isPersonalInfoValid = validatePersonalInfo(
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        l10: l10,
      );

      final isBusinessInfoValid = validateBusinessInfo(
        businessName: businessName,
        businessType: businessType,
        l10: l10,
      );

      if (onlyPassword) {
        if (!isPasswordValid) {
          return false;
        }
      } else if (!isPersonalInfoValid ||
          !isBusinessInfoValid ||
          !isPasswordValid) {
        return false;
      }
      setLoading(true);
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'role': 'vendor',
          'business_name': businessName,
          'business_type': businessType,
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
    } on AuthException catch (e) {
      print('errrrrrorrrrrrrrrrrr $e');
      if (e.code == 'user_already_exists') {
        emailError = l10.emailInUse;
        notifyListeners();
      } else {
        setSignUpError(e.message);
      }
      return false;
    } catch (e) {
      print('errrrrrorrrrrrrrrrrr $e');
      setSignUpError(e.toString());
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
