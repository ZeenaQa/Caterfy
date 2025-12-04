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
  final bool? isFavorite;

  Store({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.description,
    this.storeArea,
    this.logoUrl,
    this.bannerUrl,
    this.tags,
    this.latitude = 0,
    this.longitude = 0, 
     this.isFavorite,
  });

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'],
      vendorId: map['vendor_id'],
      name: map['name'],
      description: map['description'],
      storeArea: map['store_area'],
      logoUrl: map['logo_url'],
      bannerUrl: map['banner_url'],
      tags: (map['tags'] as List<dynamic>).map((e) => e.toString()).toList(),
      latitude: map['latitude'] != null
          ? (map['latitude'] as num).toDouble()
          : 0,
      longitude: map['longitude'] != null
          ? (map['longitude'] as num).toDouble()
          : 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vendor_id': vendorId,
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
