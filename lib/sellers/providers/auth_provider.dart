import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SellerAuthProvider extends ChangeNotifier {
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String name = '';
  bool isLoading = false;
  String? _signUpError;
  String? _logInError;

  final supabase = Supabase.instance.client;

  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  String? get Serror => _signUpError;
  String? get Lerror => _logInError;

  void setEmail(String value) {
    _email = value.trim();
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value.trim();
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value.trim();
    notifyListeners();
  }

  void setName(String value) {
    name = value.trim();
    notifyListeners();
  }

  void setSignUpError(String? value) {
    _signUpError = value;
    notifyListeners();
  }

  void setLogInError(String? value) {
    _logInError = value;
    notifyListeners();
  }

  bool validateEmail(String email) {
    return email.contains('@') && email.endsWith('.com');
  }

  bool isValidPassword(String password) {
    final minLength = 8;
    final hasUppercase = RegExp(r'[A-Z]');
    final hasLowercase = RegExp(r'[a-z]');
    final hasDigit = RegExp(r'\d');
    if (password.length < minLength) return false;
    if (!hasUppercase.hasMatch(password)) return false;
    if (!hasLowercase.hasMatch(password)) return false;
    if (!hasDigit.hasMatch(password)) return false;
    return true;
  }

  Future<bool> signUp() async {
    if (name.isEmpty ||
        _email.isEmpty ||
        _password.isEmpty ||
        _confirmPassword.isEmpty) {
      setSignUpError("Please fill all fields");
      return false;
    }

    if (_password != _confirmPassword) {
      setSignUpError("Passwords do not match");
      return false;
    }

    if (!isValidPassword(_password)) {
      setSignUpError(
        "Password must be at least 8 characters, include upper & lower case letters and a number",
      );
      return false;
    }

    if (!validateEmail(_email)) {
      setSignUpError("Enter a valid email address");
      return false;
    }

    try {
      isLoading = true;
      notifyListeners();

      final response = await supabase.auth.signUp(
        email: _email,
        password: _password,
      );

      if (response.user != null) {
        final userId = response.user!.id;

        await supabase.from('sellers').insert({
          'id': userId,
          'name': name,
          'email': _email,
        });

        setSignUpError(null);
        return true;
      }

      return false;
    } catch (e) {
      if (e is AuthApiException && e.code == 'user_already_exists') {
        setSignUpError("This email is already registered");
      } else {
        setSignUpError(e.toString());
        print(e);
      }
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logIn() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await supabase.auth.signInWithPassword(
        email: _email,
        password: _password,
      );

      if (response.session == null) {
        setLogInError("Email or password is incorrect");
        return false;
      }

      setLogInError(null);

      final data = await supabase
          .from('sellers')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();
      if (data != null) {
        name = data['name'] ?? '';
        _email = data['email'] ?? '';
      }

      return true;
    } catch (e) {
      setLogInError(e.toString());
      print(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
