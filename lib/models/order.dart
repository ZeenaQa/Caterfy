import 'package:caterfy/models/order_item.dart';

class Order {
  final String customerId;
  final String storeId;
  final String storeName;
  final String storeLogo;
  final List<OrderItem> items;
  final String note;
  final String? createdAt;
  final double deliveryPrice;

  Order({
    required this.customerId,
    required this.storeId,
    required this.storeName,
    required this.deliveryPrice,
    this.storeLogo = '',
    List<OrderItem>? items,
    this.note = '',
    this.createdAt,
  }) : items = List.from(items ?? []);

  Map<String, dynamic> toMap() {
    return {
      'customer_id': customerId,
      'store_id': storeId,
      'store_name': storeName,
      'store_logo': storeLogo,
      'note': note,
      "delivery_price": deliveryPrice,
      'items': items.map((e) => e.toMap()).toList(),
      'created_at': createdAt,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    final order = Order(
      customerId: map['customer_id'],
      storeId: map['store_id'],
      storeName: map['store_name'] ?? "",
      storeLogo: map['store_logo'] ?? "",
      createdAt: map['created_at'] ?? '',
      note: map['note'] ?? '',
      deliveryPrice: map['delivery_price'],
    );

    order.items.addAll(
      (map['items'] as List).map(
        (e) => OrderItem.fromMap(Map<String, dynamic>.from(e)),
      ),
    );

    return order;
  }
}
