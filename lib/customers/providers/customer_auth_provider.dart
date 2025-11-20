import 'package:caterfy/customers/customer_widgets/authenticated_customer.dart';
import 'package:caterfy/customers/screens/customer_signup/customer_email_token_screen.dart';
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
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Field can't be empty";
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return "Invalid email";
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Field can't be empty";
    }
    if (password.length < 8) {
      return "Must be at least 8 characters long";
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "Must include at least one uppercase letter";
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      return "Must include at least one number";
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
  }) async {
    nameError = name.isEmpty ? "Field can't be empty" : null;
    confirmPasswordError = confirmPassword.isEmpty
        ? "Field can't be empty"
        : null;
    emailError = validateEmail(email);
    passwordError = validatePassword(password);
    confirmPasswordError = password != confirmPassword
        ? "Passwords do not match"
        : null;

    notifyListeners();

    if (nameError != null ||
        emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      return {'success': false, 'message': "One or more fields are invalid"};
    }

    try {
      setLoading(true);

      await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'role': 'customer'},
      );

      return {
        'success': true,
        'message': "A verification code has been sent to your email",
      };
    } on AuthException catch (e) {
      if (e.code == 'user_already_exists') {
        emailError = "Email is already registered.";
        notifyListeners();
        return {'success': false, 'message': "Email is already registered"};
      } else if (e.code == "over_email_send_rate_limit") {
        final int? seconds = extractIntFromString(e.message);
        final errMsg = "Please try again in $seconds seconds.";
        emailError = errMsg;
        return {
          'success': false,
          'message': "Please try again in $seconds seconds.",
        };
      } else {
        setSignUpError(e.message);
      }
      return {'success': false, 'message': "Something went wrong"};
    } catch (e) {
      setSignUpError(e.toString());
      return {'success': false, 'message': "Something went wrong"};
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

  Future<String?> checkEmailExists(String email) async {
    if (email.isEmpty) {
      emailError = "Field can't be empty";
      notifyListeners();
      return emailError;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emailError = "Email is not valid";
      notifyListeners();
      return emailError;
    }

    try {
      final existing = await Supabase.instance.client
          .from('customers')
          .select('id')
          .eq('email', email)
          .maybeSingle();

      if (existing == null) {
        emailError = "No account found with this email";
      } else {
        emailError = null;
      }
      notifyListeners();
      return emailError;
    } catch (e) {
      emailError = "Error checking email";
      notifyListeners();
      return emailError;
    }
  }

  // ---------------- Log In ----------------
  Future<bool> logIn({
    required email,
    required String password,
    BuildContext? context,
  }) async {
    emailError = validateEmail(email);
    passwordError = password.isEmpty ? "Field can't be empty" : null;

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
        emailError = "Invalid email or password";
        passwordError = "Invalid email or password";
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
        );
        if (res['success'] && context!.mounted) {
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
      emailError = "Invalid email or password";
      passwordError = "Invalid email or password";
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<dynamic> sendForgotPasswordPassEmail({required String email}) async {
    try {
      // Validate email format
      final emailRes = validateEmail(email);
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
        emailError = "No account found with this email";
        notifyListeners();
        return {
          'success': false,
          'message': "No account found with this email",
        };
      }

      forgotPassLoading = true;
      notifyListeners();

      await supabase.auth.resetPasswordForEmail(email.trim());

      return {'success': true, 'message': "Email sent successfully"};
    } on AuthApiException catch (e) {
      if (e.code == "over_email_send_rate_limit") {
        final int? seconds = extractIntFromString(e.message);
        final errMsg = "Please try again in $seconds seconds.";
        emailError = errMsg;
        return {'success': false, 'message': errMsg};
      }
    } catch (e) {
      emailError = 'Something went wrong $e';
      notifyListeners();
      return {'success': false, 'message': "Something went wrong"};
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
  }) async {
    try {
      passwordError = validatePassword(password);
      confirmPasswordError = confirmPassword.isEmpty
          ? "Field can't be empty"
          : null;
      confirmPasswordError = password != confirmPassword
          ? "Passwords do not match"
          : null;

      if (passwordError != null || confirmPasswordError != null) {
        return {'success': false, 'message': 'mismatch'};
      }

      isLoading = true;
      notifyListeners();
      await supabase.auth.updateUser(UserAttributes(password: password));
      return {'success': true, 'message': 'Password reset successfully.'};
    } on AuthApiException {
      return {'success': false, 'message': 'Something went wrong.'};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- Phone ----------------

  Future<bool> signUpOrSignInWithPhone({required String phoneNumber}) async {
    if (phoneNumber.isEmpty) {
      phoneNumberError = "Field can't be empty";
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
          phoneNumberError = "Something went wrong";
          notifyListeners();
          return false;
        }
      }

      phoneNumberError = "Something went wrong";
      notifyListeners();
      return false;
    } catch (e) {
      phoneNumberError = "Something went wrong";
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> checkPhoneExistsCustomer({required String phoneNumber}) async {
    try {
      final customer = await supabase
          .from('customers')
          .select('id')
          .eq('phone', phoneNumber)
          .maybeSingle();

      return customer != null;
    } catch (_) {
      phoneNumberError = "There was an error with this phone number";
      notifyListeners();
      return false;
    }
  }

  /// ------------------------- Google Sign-in -------------------------
  Future<void> signInWithGoogle(BuildContext context) async {
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

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AuthenticatedCustomer()),
        );
      }
    } catch (e) {
      setLogInError("Google sign-in failed: $e");
    } finally {
      setGoogleLoading(false);
    }
  }

  // ---------------- Forgot Password ----------------
  Future<void> sendResetPasswordEmail(
    String email,
    BuildContext context,
  ) async {
    emailError = validateEmail(email);
    notifyListeners();
    if (emailError != null) return;

    setLoading(true);

    try {
      final existing = await supabase
          .from('customers')
          .select('id')
          .eq('email', email.trim())
          .maybeSingle();

      if (existing == null) {
        emailError = "No account found with this email";
        notifyListeners();
        setLoading(false);
        return;
      }
      await supabase.auth.resetPasswordForEmail(email.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset link sent successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    } finally {
      setLoading(false);
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
