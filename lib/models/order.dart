import 'package:caterfy/models/order_item.dart';

class Order {
  final String customerId;
  final String storeId;
  final String storeName;
  final String name_ar;
  final String storeLogo;
  final List<OrderItem> items;
  final String note;
  final String? createdAt;
  final double deliveryPrice;
  final double walletTransaction;

  Order({
    required this.customerId,
    required this.storeId,
    required this.storeName,
    required this.name_ar,
    required this.deliveryPrice,
    this.walletTransaction = 0.00,
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
      "name_ar": name_ar,
      'store_logo': storeLogo,
      'note': note,
      "delivery_price": deliveryPrice,
      'wallet_transaction': walletTransaction,
      'items': items.map((e) => e.toMap()).toList(),
      'created_at': createdAt,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    final order = Order(
      customerId: map['customer_id'],
      storeId: map['store_id'],
      storeName: map['store_name'] ?? "",
      name_ar: map['name_ar'] ?? '',
      storeLogo: map['store_logo'] ?? "",
      createdAt: map['created_at'] ?? '',
      note: map['note'] ?? '',
      deliveryPrice: map['delivery_price'],
      walletTransaction: map['wallet_transaction'],
    );

    order.items.addAll(
      (map['items'] as List).map(
        (e) => OrderItem.fromMap(Map<String, dynamic>.from(e)),
      ),
    );

    return order;
  }
}
