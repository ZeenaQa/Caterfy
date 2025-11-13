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
  String? businessNameError = '';
  String? businessTypeError = '';
  String? nameError;
  String? emailError;
  String? phoneError;
  String? passwordError;
  String? confirmPasswordError;

  // ---------------- Setters ----------------
  void setPhoneNumber(String value) {
    _phoneNumber = value;
    passwordError = null;
    notifyListeners();
  }

  void setBusinessName(String name) {
    businessName = name.trim();
    businessNameError = null;
    notifyListeners();
  }

  void setBusinessType(String type) {
    businessType = type;
    businessTypeError = null;
    notifyListeners();
  }

  void clearName() {
    name = '';
    notifyListeners();
  }

  void setEmail(String value) {
    email = value.trim();
    emailError = null;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value.trim();
    passwordError = null;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    confirmPassword = value.trim();
    confirmPasswordError = null;
    notifyListeners();
  }

  void setName(String value) {
    name = value.trim();
    nameError = null;
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

  // --------------------------------------------------------

  bool validatePersonalInfo() {
    nameError = name.isEmpty ? "Field can't be empty" : null;

    if (email.isEmpty) {
      emailError = "Field can't be empty";
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emailError = "Invalid email";
    } else {
      emailError = null;
    }

    phoneError = _phoneNumber.isEmpty ? "Field can't be empty" : null;

    notifyListeners();

    return nameError == null && emailError == null && phoneError == null;

    // --------------------------------------------------------
  }

  bool validateBusinessInfo() {
    businessNameError = businessName.isEmpty ? "Field can't be empty" : null;
    businessTypeError = businessType.isEmpty ? "Please select a type" : null;

    notifyListeners();

    return businessNameError == null && businessTypeError == null;
  }

  // --------------------------------------------------------

  bool validatePasswordInfo() {
    passwordError = validatePassword(password);
    confirmPasswordError = password != confirmPassword
        ? "Passwords do not match"
        : null;

    notifyListeners();

    return passwordError == null && confirmPasswordError == null;
  }

  // ---------------- Sign Up ----------------
  Future<bool> signUp({bool onlyPassword = false}) async {
    if (onlyPassword) {
      if (!validatePasswordInfo()) return false;
    } else if (!validatePersonalInfo() ||
        !validateBusinessInfo() ||
        !validatePasswordInfo())
      return false;
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
          'business_name': businessName,
          'business_type': businessType,
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
    phoneError = null;
    passwordError = null;
    confirmPasswordError = null;
    signUpError = null;
    successMessage = null;
    businessNameError = null;
    businessTypeError = null;
    notifyListeners();
  }
}
