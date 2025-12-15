class Product {
  final String id;
  final String storeId;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String foodCategory;
  final String subCategoryId;


  Product({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.foodCategory = '', 
    required this.subCategoryId,
    
  });

  // FROM SUPABASE (Map → Product)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      storeId: map['store_id'],
      name: map['name'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      imageUrl: map['image_url'],
      subCategoryId: map['sub_category_id'],

    );
  }

  // TO SUPABASE (Product → Map)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'sub_category_id': subCategoryId,

    };
  }
}
