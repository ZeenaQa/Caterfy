class OrderItem {
  final String id;
  final String productId;
  final String storeId;
  final String name;
  final String? imageUrl;
  final double price;
  final int quantity;
  final String note;

  OrderItem({
    required this.id,
    required this.productId,
    required this.storeId,
    required this.name,
    this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.note = '',
  });

  OrderItem copyWith({
    String? productId,
    String? storeId,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
    String? note,
  }) {
    return OrderItem(
      id: id,
      productId: productId ?? this.productId,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'store_id': storeId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'note': note,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      productId: map['product_id'],
      storeId: map['store_id'],
      name: map['name'],
      imageUrl: map['image_url'],
      price: map['price'],
      quantity: map['quantity'] ?? 1,
      note: map['note'] ?? '',
    );
  }
}
