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

  bool validatePersonalInfo({
    required String name,
    required String email,
    required String phoneNumber,
  }) {
    nameError = name.isEmpty ? "Field can't be empty" : null;

    if (email.isEmpty) {
      emailError = "Field can't be empty";
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emailError = "Invalid email";
    } else {
      emailError = null;
    }

    phoneError = phoneNumber.isEmpty ? "Field can't be empty" : null;

    notifyListeners();

    return nameError == null && emailError == null && phoneError == null;

    // --------------------------------------------------------
  }

  bool validateBusinessInfo({
    required String businessName,
    required String businessType,
  }) {
    businessNameError = businessName.isEmpty ? "Field can't be empty" : null;
    businessTypeError = businessType.isEmpty ? "Please select a type" : null;

    notifyListeners();

    return businessNameError == null && businessTypeError == null;
  }

  // --------------------------------------------------------

  bool validatePasswordInfo({
    required String password,
    required String confirmPassword,
  }) {
    passwordError = validatePassword(password);
    confirmPasswordError = password != confirmPassword
        ? "Passwords do not match"
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
  }) async {
    if (onlyPassword) {
      if (!validatePasswordInfo(
        password: password,
        confirmPassword: confirmPassword,
      )) {
        return false;
      }
    } else if (!validatePersonalInfo(
          email: email,
          name: name,
          phoneNumber: phoneNumber,
        ) ||
        !validateBusinessInfo(
          businessName: businessName,
          businessType: businessType,
        ) ||
        !validatePasswordInfo(
          password: password,
          confirmPassword: confirmPassword,
        )) {
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
          'phone_number': phoneNumber,
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

  // ---------------- Log In ----------------
  Future<bool> logIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
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
        emailError = "Invalid email or password";
        passwordError = "Invalid email or password";
        notifyListeners();
        return false;
      }

      return true;
    } on AuthApiException {
      emailError = "Invalid email or password";
      passwordError = "Invalid email or password";
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

  Future<String?> checkPhoneExistsVendor({required String phoneNumber}) async {
    if (phoneNumber.isEmpty) return null;

    try {
      final vendor = await supabase
          .from('vendors')
          .select('id')
          .eq('phone_number', phoneNumber)
          .maybeSingle();

      if (vendor != null) return 'vendor';

      final customer = await supabase
          .from('customers')
          .select('id')
          .eq('phone_number', phoneNumber)
          .maybeSingle();

      if (customer != null) return 'customer';

      return null;
    } catch (e) {
      setLogInError("Error checking phone: $e");
      return null;
    }
  }

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
          .from('vendors')
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

  int? extractIntFromString(String message) {
    final regex = RegExp(r'\d+');
    final match = regex.firstMatch(message);
    if (match != null) {
      return int.tryParse(match.group(0)!);
    }
    return null;
  }

  Future<dynamic> sendForgotPasswordPassEmail({required String email}) async {
    try {
      final emailRes = validateEmail(email);
      if (emailRes != null) {
        emailError = emailRes;
        notifyListeners();
        return {'success': false, 'message': emailRes};
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
        return {
          'success': false,
          'message': "Please try again in $seconds seconds.",
        };
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
