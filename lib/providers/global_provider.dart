import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';


class GlobalProvider extends ChangeNotifier {
  dynamic user;
  final supabase = Supabase.instance.client;
  String? deliveryLocation;
  LatLng? lastPickedLocation;
  bool _notificationsEnabled = true;
  final Map<String, Map<String, dynamic>> _storeRatingsCache = {};

  bool get notificationsEnabled => _notificationsEnabled;

  GlobalProvider() {
    loadLastLocation();
    _loadNotificationsPreference();
    _loadNotificationsPreference();
  }
  
  Future<void> rateStore({
  required String storeId,
  required int rating,
}) async {
  try {
    final currentUser = supabase.auth.currentUser;

    if (currentUser == null) {
      throw Exception("User not logged in");
    }

    if (rating < 1 || rating > 5) {
      throw Exception("Rating must be between 1 and 5");
    }

    final existing = await supabase
        .from('store_ratings')
        .select()
        .eq('store_id', storeId)
        .eq('id', currentUser.id);

    if (existing.isNotEmpty) {
      // update rating
      await supabase
          .from('store_ratings')
          .update({'rating': rating})
          .eq('store_id', storeId)
          .eq('id', currentUser.id);
    } else {
      // insert new rating
      await supabase.from('store_ratings').insert({
        'store_id': storeId,
        'id': currentUser.id,
        'rating': rating,
      });
    }

    // refresh cache for this store so UI updates immediately
    await _refreshStoreRatingCache(storeId);
    notifyListeners();
  } catch (e) {
    print('Error rating store: $e');
    rethrow;
  }
}


  Future<Map<String, dynamic>> getStoreRatingDetails(String storeId) async {
    try {
      final response = await supabase
          .from('store_ratings')
          .select('rating')
          .eq('store_id', storeId);

      if (response.isEmpty) {
        return {'average': 0.0, 'count': 0};
      }

      double sum = 0;
      for (var r in response) {
        sum += r['rating'];
      }

      double average = sum / response.length;
      final result = {
        'average': double.parse(average.toStringAsFixed(1)),
        'count': response.length,
      };
      _storeRatingsCache[storeId] = result;
      return result;
    } catch (e) {
      print('Error getting store rating: $e');
      return {'average': 0.0, 'count': 0};
    }
  }

  Future<double> getStoreRating(String storeId) async {
    final details = await getStoreRatingDetails(storeId);
    return details['average'] ?? 0.0;
  }

  Future<int?> getUserRatingForStore(String storeId) async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) return null;

      final response = await supabase
          .from('store_ratings')
          .select('rating')
          .eq('store_id', storeId)
          .eq('id', currentUser.id);

      if (response.isEmpty) return null;
      return (response[0]['rating'] as int?);
    } catch (e) {
      print('Error getting user rating: $e');
      return null;
    }
  }

  Map<String, dynamic>? getCachedStoreRating(String storeId) {
    return _storeRatingsCache[storeId];
  }

  Future<void> _refreshStoreRatingCache(String storeId) async {
    try {
      final details = await getStoreRatingDetails(storeId);
      _storeRatingsCache[storeId] = details;
    } catch (e) {
      print('Error refreshing store rating cache: $e');
    }
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
    deliveryLocation = prefs.getString('deliveryLocation');

    final lat = prefs.getDouble('last_latitude');
    final lng = prefs.getDouble('last_longitude');

    if (lat != null && lng != null) {
      lastPickedLocation = LatLng(lat, lng);
    }
    notifyListeners();
  }

  double getDeliveryPrice(double? storeLat, double? storeLon) {
    if (lastPickedLocation == null || storeLat == null || storeLon == null) {
      return -1;
    }

    final userLat = lastPickedLocation?.latitude;
    final userLon = lastPickedLocation?.longitude;

    const double earthRadius = 6371;

    double toRad(double value) => value * pi / 180;

    final dLat = toRad(storeLat - userLat!);
    final dLon = toRad(storeLon - userLon!);

    final a =
        pow(sin(dLat / 2), 2) +
        cos(toRad(userLat)) * cos(toRad(storeLat)) * pow(sin(dLon / 2), 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final double distance = earthRadius * c;

    const double baseFee = .5;
    const double pricePerKm = 0.15;
    const double minPrice = .5;
    const double maxPrice = 10.0;

    final price = baseFee + distance * pricePerKm;

    return (price.clamp(minPrice, maxPrice) * 10).floorToDouble() / 10;
  }

  String getDeliveryTime(double? storeLat, double? storeLon) {
    if (lastPickedLocation == null || storeLat == null || storeLon == null) {
      return "20";
    }

    final userLat = lastPickedLocation?.latitude;
    final userLon = lastPickedLocation?.longitude;

    const double earthRadius = 6371;

    double toRad(double value) => value * pi / 180;

    final dLat = toRad(storeLat - userLat!);
    final dLon = toRad(storeLon - userLon!);

    final a =
        pow(sin(dLat / 2), 2) +
        cos(toRad(userLat)) * cos(toRad(storeLat)) * pow(sin(dLon / 2), 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final double distance = earthRadius * c;
    final int averageSpeedKmH = 30;
    final int minTime = 18; //in minutes
    final int maxTime = 59;

    final timeHours = distance / averageSpeedKmH;
    final timeMinutes = (timeHours * 60).toInt();
    final int finalTime = min((minTime + timeMinutes), maxTime);
    return '${finalTime - 5} - $finalTime';
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
