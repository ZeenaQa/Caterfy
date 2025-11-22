import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  ThemeController() {
    _loadTheme();
  }

  Future<void> setLight() async {
    themeMode = ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', false);
    notifyListeners();
  }

  /// Set to DARK
  Future<void> setDark() async {
    themeMode = ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', true);
    notifyListeners();
  }

  void toggleTheme() async {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', themeMode == ThemeMode.dark);

    notifyListeners();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;

    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
