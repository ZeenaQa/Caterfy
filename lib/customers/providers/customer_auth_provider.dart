import 'package:caterfy/customers/screens/customer_signup/customer_email_token_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerAuthProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  bool isLoading = false;
  bool tokenIsLoading = false;
  bool forgotPassLoading = false;
  bool isGoogleLoading = false;

  String? signUpError;
  String? logInError;
  String? successMessage;
  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? phoneNumberError;

  // ---------------- Setters ----------------
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setGoogleLoading(bool val) {
    isGoogleLoading = val;
    notifyListeners();
  }

  void setTokenIsLoading(bool val) {
    tokenIsLoading = val;
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

  int? extractIntFromString(String message) {
    final regex = RegExp(r'\d+');
    final match = regex.firstMatch(message);
    if (match != null) {
      return int.tryParse(match.group(0)!);
    }
    return null;
  }

  // ---------------- Sign Up ----------------
  Future<dynamic> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    final l10 = AppLocalizations.of(context);
    nameError = name.isEmpty ? l10.emptyField : null;
    confirmPasswordError = confirmPassword.isEmpty ? l10.emptyField : null;
    emailError = validateEmail(email, l10);
    passwordError = validatePassword(password, l10);
    confirmPasswordError = password != confirmPassword
        ? l10.passwordsNoMatch
        : null;

    notifyListeners();

    if (nameError != null ||
        emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      return {'success': false, 'message': l10.invalidFields};
    }

    try {
      setLoading(true);

      await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'role': 'customer'},
      );

      return {'success': true, 'message': l10.verifCodeSent};
    } on AuthException catch (e) {
      if (e.code == 'user_already_exists') {
        emailError = '${l10.emailInUse}.';
        notifyListeners();
        return {'success': false, 'message': '${l10.emailInUse}.'};
      } else if (e.code == "over_email_send_rate_limit") {
        final int? seconds = extractIntFromString(e.message);
        final errMsg = '${l10.tryAgainIn} $seconds ${l10.seconds}.';
        emailError = errMsg;
        return {
          'success': false,
          'message': '${l10.tryAgainIn} $seconds ${l10.seconds}.',
        };
      } else {
        setSignUpError(e.message);
      }
      return {'success': false, 'message': l10.somethingWentWrong};
    } catch (e) {
      setSignUpError(e.toString());
      return {'success': false, 'message': l10.somethingWentWrong};
    } finally {
      setLoading(false);
    }
  }

  Future<bool> verifySignupToken({
    required String email,
    required String token,
  }) async {
    try {
      tokenIsLoading = true;
      notifyListeners();
      await supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.signup,
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

  // ---------------- Log In ----------------
  Future<bool> logIn({
    required email,
    required String password,
    required BuildContext context,
  }) async {
    final l10 = AppLocalizations.of(context);
    emailError = validateEmail(email, l10);
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
    } on AuthApiException catch (e) {
      if (e.code == "email_not_confirmed") {
        clearErrors();
        final res = await signUp(
          name: '1',
          email: email.trim(),
          password: password,
          confirmPassword: password,
          context: context,
        );
        if (res['success'] && context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CustomerSignupTokenScreen(email: email, password: password),
            ),
          );
        }
        return false;
      }
      emailError = l10.invalidEmailOrPassword;
      passwordError = l10.invalidEmailOrPassword;
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<dynamic> sendForgotPasswordPassEmail({
    required String email,
    required BuildContext context,
  }) async {
    final l10 = AppLocalizations.of(context);
    try {
      // Validate email format
      final emailRes = validateEmail(email, l10);
      if (emailRes != null) {
        emailError = emailRes;
        notifyListeners();
        return {'success': false, 'message': emailRes};
      }

      // Check if email exists in customers table
      final response = await supabase
          .from('customers')
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

      return {'success': true, 'message': "Email sent successfully"};
    } on AuthApiException catch (e) {
      if (e.code == "over_email_send_rate_limit") {
        final int? seconds = extractIntFromString(e.message);
        final errMsg = '${l10.tryAgainIn} $seconds ${l10.seconds}.';
        emailError = errMsg;
        return {'success': false, 'message': errMsg};
      }
    } catch (e) {
      emailError = '${l10.somethingWentWrong} $e';
      notifyListeners();
      return {'success': false, 'message': l10.somethingWentWrong};
    } finally {
      forgotPassLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> verifyResetPassEmail({
    required String token,
    required String email,
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
      confirmPasswordError = confirmPassword.isEmpty ? l10.emptyField : null;
      confirmPasswordError = password != confirmPassword
          ? l10.passwordsNoMatch
          : null;

      if (passwordError != null || confirmPasswordError != null) {
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

  Future<bool> signUpOrSignInWithPhone({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    final l10 = AppLocalizations.of(context);
    if (phoneNumber.isEmpty) {
      phoneNumberError = l10.emptyField;
      notifyListeners();
      return false;
    }

    try {
      setLoading(true);
      await supabase.auth.signUp(
        phone: phoneNumber,
        password: "12345678",
        data: {'role': 'customer'},
      );
      phoneNumberError = null;
      notifyListeners();
      return true;
    } on AuthApiException catch (e) {
      if (e.code == "user_already_exists") {
        try {
          await supabase.auth.signInWithOtp(phone: phoneNumber);
          phoneNumberError = null;
          notifyListeners();
          return true;
        } catch (e) {
          phoneNumberError = l10.somethingWentWrong;
          notifyListeners();
          return false;
        }
      }

      phoneNumberError = l10.somethingWentWrong;
      notifyListeners();
      return false;
    } catch (e) {
      phoneNumberError = l10.somethingWentWrong;
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// ------------------------- Google Sign-in -------------------------
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            '1066228950684-3skki6ts1uct5tg4t3ikhsd971cjddbl.apps.googleusercontent.com',
      );
      await googleSignIn.signOut();
      setGoogleLoading(true);
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) {
        setLogInError("Google sign-in cancelled");
        setGoogleLoading(false);
        return;
      }

      final GoogleSignInAuthentication auth = await account.authentication;

      final String? idToken = auth.idToken;
      final String? accessToken = auth.accessToken;

      if (idToken == null) {
        setLogInError("No ID token found");
        return;
      }

      final AuthResponse res = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final user = res.user;
      if (user == null) {
        setLogInError("Failed to log in with Supabase");
        return;
      }

      final existing = await supabase
          .from('customers')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (existing == null || existing.isEmpty) {
        await supabase.from('customers').insert({
          'id': user.id,
          'email': user.email,
          'name': user.userMetadata?['full_name'] ?? 'New User',
        });
      }
    } catch (e) {
      setLogInError("Google sign-in failed: $e");
    } finally {
      setGoogleLoading(false);
    }
  }

  void clearErrors() {
    nameError = null;
    emailError = null;
    passwordError = null;
    confirmPasswordError = null;
    signUpError = null;
    successMessage = null;
    phoneNumberError = null;
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
