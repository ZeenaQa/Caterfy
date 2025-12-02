

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  bool _notificationsEnabled = true;

  Locale get locale => _locale;
  bool get notificationsEnabled => _notificationsEnabled;

  LocaleProvider() {
    _loadLocale();
    _loadNotificationsPreference();
  }


  void setLocale(Locale locale) {
    if (!['en', 'ar'].contains(locale.languageCode)) return;

    _locale = locale;
    _saveLocale(locale);
    notifyListeners();
  }

  void toggleLocale() {
    if (_locale.languageCode == 'en') {
      setLocale(const Locale('ar'));
    } else {
      setLocale(const Locale('en'));
    }
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
  }

  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    _saveNotificationsPreference(value);
    notifyListeners();
  }

  void toggleNotifications() {
    setNotificationsEnabled(!_notificationsEnabled);
  }

  Future<void> _loadNotificationsPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    notifyListeners();
  }

  Future<void> _saveNotificationsPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
  }
}
