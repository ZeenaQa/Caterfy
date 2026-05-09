import 'package:caterfy/models/order_item.dart';

class Order {
  final String id;
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
  final String? status;

  Order({
    this.id = '',
    required this.customerId,
    required this.storeId,
    required this.storeName,
    required this.name_ar,
    required this.deliveryPrice,
    this.walletTransaction = 0.00,
    this.storeLogo = '',
    this.status,
    List<OrderItem>? items,
    this.note = '',
    this.createdAt,
  }) : items = List.from(items ?? []);

  bool get isDelivered =>
      status?.toLowerCase() == 'delivered' ||
      status?.toLowerCase() == 'completed';

  bool get isActiveOrder => !isDelivered;

  double get subtotal {
    double total = 0;
    for (final item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  double get totalAmount => subtotal + deliveryPrice + 0.2;

  Order copyWith({String? status}) {
    return Order(
      id: id,
      customerId: customerId,
      storeId: storeId,
      storeName: storeName,
      name_ar: name_ar,
      deliveryPrice: deliveryPrice,
      walletTransaction: walletTransaction,
      storeLogo: storeLogo,
      status: status ?? this.status,
      items: items,
      note: note,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'store_id': storeId,
      'store_name': storeName,
      "name_ar": name_ar,
      'store_logo': storeLogo,
      'note': note,
      "delivery_price": deliveryPrice,
      'wallet_transaction': walletTransaction,
      'items': items.map((e) => e.toMap()).toList(),
      'status': status ?? 'pending',
      'created_at': createdAt,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    final order = Order(
      id: map['id'] ?? '',
      customerId: map['customer_id'],
      storeId: map['store_id'],
      storeName: map['store_name'] ?? "",
      name_ar: map['name_ar'] ?? '',
      storeLogo: map['store_logo'] ?? "",
      createdAt: map['created_at'] ?? '',
      note: map['note'] ?? '',
      deliveryPrice: (map['delivery_price'] as num).toDouble(),
      walletTransaction: (map['wallet_transaction'] as num).toDouble(),
      status: map['status'] as String?,
    );

    order.items.addAll(
      (map['items'] as List).map(
        (e) => OrderItem.fromMap(Map<String, dynamic>.from(e)),
      ),
    );

    return order;
  }
}
