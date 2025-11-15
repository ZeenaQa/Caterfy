import 'package:caterfy/customers/customer_widgets/authenticated_customer.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerAuthProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  bool isLoading = false;

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
      return " is not valid";
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return "Field can't be empty";
    }
    if (password.length < 8) {
      return " must be at least 8 characters long";
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "must include at least one uppercase letter";
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      return "must include at least one number";
    }
    return null;
  }

  // ---------------- Sign Up ----------------
  Future<bool> signUp({
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
      return false;
    }

    try {
      setLoading(true);

      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': name},
      );

      if (response.user != null) {
        await supabase.from('customers').insert({
          'id': response.user!.id,
          'name': name,
          'email': email,
        });
      }

      return true;
    } on AuthException catch (e) {
      if (e.code == 'user_already_exists') {
        emailError = " is already registered.";
        notifyListeners();
      } else {
        setSignUpError(e.message);
      }
      return false;
    } catch (e) {
      setSignUpError(e.toString());
      return false;
    } finally {
      setLoading(false);
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
  Future<bool> logIn({required email, required String password}) async {
    emailError = email.isEmpty ? "Field can't be empty" : null;
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
        emailError = "or password is incorrect";
        passwordError = "or Email is incorrect";
        notifyListeners();
        return false;
      }
      return true;
    } on AuthApiException {
      emailError = "or password is incorrect";
      passwordError = "or Email is incorrect";
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
    }
  }

  // ---------------- Phone ----------------
  Future<bool> sendPhoneOtp({required String phoneNumber}) async {
    if (phoneNumber.isEmpty) {
      setLogInError("Please enter a valid phone number");
      return false;
    }

    try {
      setLoading(true);
      await supabase.auth.signInWithOtp(phone: phoneNumber);
      setLogInError(null);
      return true;
    } catch (e) {
      setLogInError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<String?> checkPhoneExistsCustomer({
    required String phoneNumber,
  }) async {
    try {
      final customerID = await supabase
          .from('customeString phoneNumberrs')
          .select('id')
          .eq('phone_number', phoneNumber)
          .maybeSingle();

      if (customerID != null) return customerID.toString();

      return null;
    } catch (e) {
      setLogInError("Error checking phone: $e");
      return null;
    }
  }

  /// ------------------------- Google Sign-in -------------------------
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      setLoading(true);

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId:
            '27106899976-dpo0vu9f0eamcqv60v28nq8n60r9309a.apps.googleusercontent.com',
      );
      await googleSignIn.signOut();

      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) {
        setLogInError("Google sign-in cancelled");
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
        setLogInError("Failed to sign in with Supabase");
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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthenticatedCustomer()),
      );
    } catch (e) {
      setLogInError("Google sign-in failed: $e");
    } finally {
      setLoading(false);
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
