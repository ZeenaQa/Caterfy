import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GlobalProvider extends ChangeNotifier {
  dynamic user;

  String locationText = 'Getting location...';
  bool isLoadingLocation = false;

  final String googleApiKey = 'AIzaSyCcEEVbxSZ6GRn53ISfBV96fiYWzzKBIoQ';

  void setUser(dynamic newUser) {
    user = newUser;
    notifyListeners();
  }

  void clear() {
    user = null;
    notifyListeners();
  }

  Future<void> fetchCurrentLocation() async {
    isLoadingLocation = true;
    notifyListeners();

    try {
      final position = await _determinePosition();
      final result = await _reverseGeocode(
        position.latitude,
        position.longitude,
      );
      locationText = result;
    } catch (e) {
      locationText = 'Failed to get location';
    } finally {
      isLoadingLocation = false;
      notifyListeners();
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> _reverseGeocode(double lat, double lng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleApiKey',
    );

    final response = await http.get(url);
    if (response.statusCode != 200)
      throw Exception('HTTP error: ${response.statusCode}');

    final data = json.decode(response.body);
    if (data['status'] != 'OK' || data['results'].isEmpty) {
      throw Exception('Google API returned ${data['status']}');
    }

    final components = data['results'][0]['address_components'];

    String city = '';
    String adminArea = '';

    for (var comp in components) {
      final types = List<String>.from(comp['types']);
      if (types.contains('locality')) city = comp['long_name'];
      if (types.contains('administrative_area_level_1'))
        adminArea = comp['long_name'];
    }

    final location = [city, adminArea].where((e) => e.isNotEmpty).join(', ');
    return location.isEmpty ? 'Unknown location' : location;
  }
}
