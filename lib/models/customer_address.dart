import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomerAddress {
  final String id;
  final String customerId;
  final String type; // home, apartment, work, other
  final String? building;
  final String? floor;
  final String? apartment;
  final String? street;
  final String? directions;
  final String? area; // reverse-geocoded area name
  final double latitude;
  final double longitude;
  final bool isDefault;

  CustomerAddress({
    required this.id,
    required this.customerId,
    required this.type,
    this.building,
    this.floor,
    this.apartment,
    this.street,
    this.directions,
    this.area,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
  });

  LatLng get latLng => LatLng(latitude, longitude);

  /// Human-readable title shown in lists (e.g. "Home", "Work").
  String get typeLabel {
    switch (type) {
      case 'apartment': return 'Apartment';
      case 'work': return 'Work';
      case 'other': return 'Other';
      default: return 'Home';
    }
  }

  /// Short subtitle shown under the type label.
  String get subtitle {
    final parts = <String>[
      if (building != null && building!.isNotEmpty) building!,
      if (floor != null && floor!.isNotEmpty) 'Floor $floor',
      if (apartment != null && apartment!.isNotEmpty) 'Apt $apartment',
      if (street != null && street!.isNotEmpty) street!,
      if (area != null && area!.isNotEmpty) area!,
    ];
    return parts.join(', ');
  }

  factory CustomerAddress.fromMap(Map<String, dynamic> map) {
    return CustomerAddress(
      id: map['id'],
      customerId: map['customer_id'],
      type: map['type'] ?? 'home',
      building: map['building'],
      floor: map['floor'],
      apartment: map['apartment'],
      street: map['street'],
      directions: map['directions'],
      area: map['area'],
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      isDefault: map['is_default'] ?? false,
    );
  }

  CustomerAddress copyWith({bool? isDefault}) {
    return CustomerAddress(
      id: id,
      customerId: customerId,
      type: type,
      building: building,
      floor: floor,
      apartment: apartment,
      street: street,
      directions: directions,
      area: area,
      latitude: latitude,
      longitude: longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
