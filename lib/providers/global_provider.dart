import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GlobalProvider extends ChangeNotifier {
  dynamic user;

  String deliveryLocation = 'Pick a Location';
  LatLng? lastPickedLocation;

  GlobalProvider() {
    loadLastLocation();
  }

  // Set location (address + coordinates)
  void setDeliveryLocation(String address, LatLng location) async {
    deliveryLocation = address;
    lastPickedLocation = location;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('deliveryLocation', address);
    await prefs.setDouble('last_latitude', location.latitude);
    await prefs.setDouble('last_longitude', location.longitude);
  }

  // Load last saved location
  Future<void> loadLastLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    deliveryLocation = prefs.getString('deliveryLocation') ?? 'Pick a Location';
    final lat = prefs.getDouble('last_latitude');
    final lng = prefs.getDouble('last_longitude');
    if (lat != null && lng != null) {
      lastPickedLocation = LatLng(lat, lng);
    }
    notifyListeners();
  }

  void setUser(dynamic newUser) {
    user = newUser;
    notifyListeners();
  }

  void clear() {
    user = null;
    notifyListeners();
  }
}
