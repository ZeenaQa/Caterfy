class Store {
  final String id;
  final String name;
  final String name_ar;
  final String category;
  final String vendorId;
  final String? logoUrl;
  final String? bannerUrl;
  final String? storeArea;
  final List<String>? tags;
  final double latitude;
  final double longitude;

  Store({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.name_ar,
    required this.category,
    this.storeArea,
    this.logoUrl,
    this.bannerUrl,
    this.tags,
    this.latitude = 0,
    this.longitude = 0,
  });

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'],
      vendorId: map['vendor_id'],
      name: map['name'],
      name_ar: map['name_ar'],
      category: map['category'],
      storeArea: map['store_area'],
      logoUrl: map['logo_url'],
      bannerUrl: map['banner_url'],
      tags: map['tags'] != null
          ? List<String>.from(map['tags'])
          : null,
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'name_ar': name_ar,
      'category': category,
      'store_area': storeArea,
      'logo_url': logoUrl,
      'banner_url': bannerUrl,
      'tags': tags,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
