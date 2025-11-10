import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VendorAuthProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  String email = '';
  String password = '';
  String confirmPassword = '';
  String name = '';
  bool isLoading = false;

  String? signUpError;
  String? logInError;
  String? successMessage;
  String _phoneNumber = '';
  String businessName = '';
  String businessType = '';
  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  // ---------------- Setters ----------------
  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void setBusinessName(String name) {
    businessName = name;
    notifyListeners();
  }

  void setBusinessType(String type) {
    businessType = type;
    notifyListeners();
  }

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
  Future<bool> signUp() async {
    nameError = name.isEmpty ? "Field can't be empty" : null;
    emailError = await checkEmailAvailability(email);
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
        await supabase.from('vendors').insert({
          'id': response.user!.id,
          'name': name,
          'email': email,
          'phone_number': _phoneNumber,
        });
      }

      return true;
    } on AuthException catch (e) {
      if (e.code == 'user_already_exists') {
        emailError = "is already registered.";
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

  Future<String?> checkEmailAvailability(String email) async {
    if (email.isEmpty) {
      return "Field can't be empty";
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return "is not valid";
    }

    try {
      final existing = await supabase
          .from('vendors')
          .select('id')
          .eq('email', email)
          .maybeSingle();

      if (existing != null) {
        return "is already registered";
      }
    } catch (e) {
      return "error checking email";
    }

    return null;
  }

  // ---------------- Log In ----------------
  Future<bool> logIn() async {
    if (email.isEmpty || password.isEmpty) {
      setLogInError("Please enter email and password");
      return false;
    }

    try {
      setLoading(true);

      final isEmail = email.contains('@');

      final response = await supabase.auth.signInWithPassword(
        email: isEmail ? email : null,
        password: password,
      );

      if (response.session == null) {
        setLogInError("Email or password is incorrect");
        return false;
      }

      setLogInError(null);

      final data = await supabase
          .from('vendors')
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
      setLoading(false);
    }
  }

  // ---------------- Phone ----------------
  Future<bool> sendPhoneOtp() async {
    if (_phoneNumber.isEmpty) {
      setLogInError("Please enter a valid phone number");
      return false;
    }

    try {
      setLoading(true);
      await supabase.auth.signInWithOtp(phone: _phoneNumber);
      setLogInError(null);
      return true;
    } catch (e) {
      setLogInError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<String?> checkPhoneExistsVendor() async {
    if (_phoneNumber.isEmpty) return null;

    try {
      final vendor = await supabase
          .from('vendors')
          .select('id')
          .eq('phone_number', _phoneNumber)
          .maybeSingle();

      if (vendor != null) return 'vendor';

      final customer = await supabase
          .from('customers')
          .select('id')
          .eq('phone_number', _phoneNumber)
          .maybeSingle();

      if (customer != null) return 'customer';

      return null;
    } catch (e) {
      setLogInError("Error checking phone: $e");
      return null;
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
}
