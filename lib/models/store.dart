class Store {
  final String id;
  final String name;
  final String description;
  final String? logoUrl;
  final String? bannerUrl;
  final String? storeArea;
  final String vendorId;
  final List<String>? tags;
  final double latitude;
  final double longitude;

  Store({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.description,
    this.storeArea,
    this.logoUrl,
    this.bannerUrl,
    this.tags,
    required this.latitude,
    required this.longitude,
  });

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'],
      vendorId: map['owner_id'],
      name: map['name'],
      description: map['description'],
      storeArea: map['store_area'],
      logoUrl: map['logo_url'],
      bannerUrl: map['banner_url'],
      tags: (map['tags'] as List<dynamic>).map((e) => e.toString()).toList(),
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner_id': vendorId,
      'name': name,
      'description': description,
      'store_area': storeArea,
      'logo_url': logoUrl,
      'banner_url': bannerUrl,
      'tags': tags,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
