import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerAuthProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  String email = '';
  String password = '';
  String confirmPassword = '';
  String name = '';
  bool isLoading = false;

  String? signUpError;
  String? logInError;
  String? successMessage;

  // ---------------- Setters ----------------
  void setEmail(String value) {
    email = value.trim();
    notifyListeners();
  }

  void setPassword(String value) {
    password = value.trim();
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    confirmPassword = value.trim();
    notifyListeners();
  }

  void setName(String value) {
    name = value.trim();
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
  bool validateEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    final minLength = 8;
    final hasUppercase = RegExp(r'[A-Z]');
    final hasLowercase = RegExp(r'[a-z]');
    final hasDigit = RegExp(r'\d');

    return password.length >= minLength &&
        hasUppercase.hasMatch(password) &&
        hasLowercase.hasMatch(password) &&
        hasDigit.hasMatch(password);
  }

  // ---------------- Sign Up ----------------
  Future<bool> signUp() async {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setSignUpError("Please fill all fields");
      return false;
    }

    if (password != confirmPassword) {
      setSignUpError("Passwords do not match");
      return false;
    }

    if (!isValidPassword(password)) {
      setSignUpError(
        "Password must be at least 8 characters, include upper & lower case letters and a number",
      );
      return false;
    }

    if (!validateEmail(email)) {
      setSignUpError("Enter a valid email address");
      return false;
    }

    try {
      isLoading = true;
      notifyListeners();

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

        setSuccessMessage("Please check your email to confirm your account");
        setSignUpError(null);
        return true;
      }

      return false;
    } on AuthException catch (e) {
      if (e.code == 'user_already_exists') {
        setSignUpError(
          "This email is already registered. Please log in instead.",
        );
      } else {
        setSignUpError(e.message);
      }
      return false;
    } catch (e) {
      setSignUpError(e.toString());
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------------- Log In ----------------
  Future<bool> logIn() async {
    if (email.isEmpty || password.isEmpty) {
      setLogInError("Please enter email and password");
      return false;
    }

    try {
      isLoading = true;
      notifyListeners();

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        setLogInError("Email or password is incorrect");
        return false;
      }

      setLogInError(null);

      final data = await supabase
          .from('customers')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      if (data != null) {
        name = data['name'] ?? '';
        email = data['email'] ?? '';
      }

      return true;
    } on AuthApiException {
      setLogInError("Email or password is incorrect");
      return false;
    } catch (e) {
      setLogInError(e.toString());
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
