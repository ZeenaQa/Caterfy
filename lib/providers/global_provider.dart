import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GlobalProvider extends ChangeNotifier {
  dynamic user;

  String deliveryLocation = 'Pick a Location';
  LatLng? lastPickedLocation;
    bool _notificationsEnabled = true;

    bool get notificationsEnabled => _notificationsEnabled;

  GlobalProvider() {
    loadLastLocation();
    _loadNotificationsPreference();
     _loadNotificationsPreference();
  }

  // ---------- LOCATION ----------
  void setDeliveryLocation(String address, LatLng location) async {
    deliveryLocation = address;
    lastPickedLocation = location;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('deliveryLocation', address);
    await prefs.setDouble('last_latitude', location.latitude);
    await prefs.setDouble('last_longitude', location.longitude);
  }

  Future<void> loadLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    deliveryLocation = prefs.getString('deliveryLocation') ?? 'Pick a Location';

    final lat = prefs.getDouble('last_latitude');
    final lng = prefs.getDouble('last_longitude');

    if (lat != null && lng != null) {
      lastPickedLocation = LatLng(lat, lng);
    }
    notifyListeners();
  }

  // ---------- NOTIFICATIONS ----------
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

  // ---------- USER ----------
  void setUser(dynamic newUser) {
    user = newUser;
    notifyListeners();
  }

  void clear() {
    user = null;
    notifyListeners();
  }
}
