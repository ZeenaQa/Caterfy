import 'package:caterfy/models/order_item.dart';

class VendorOrder {
  final String customerId;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final List<OrderItem> items;
  final String note;
  final String? createdAt;

  VendorOrder({
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    this.customerPhone = '',
    List<OrderItem>? items,
    this.note = '',
    this.createdAt,
  }) : items = List.from(items ?? []);

  Map<String, dynamic> toMap() {
    return {
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'note': note,
      'items': items.map((e) => e.toMap()).toList(),
      'created_at': createdAt,
    };
  }

  factory VendorOrder.fromMap(Map<String, dynamic> map) {
    final order = VendorOrder(
      customerId: map['customer_id'],
      customerName: map['customer_name'] ?? "",
      customerEmail: map['customer_email'],
      customerPhone: map['customer_phone'] ?? "",
      createdAt: map['created_at'] ?? '',
      note: map['note'] ?? '',
    );

    order.items.addAll(
      (map['items'] as List).map(
        (e) => OrderItem.fromMap(Map<String, dynamic>.from(e)),
      ),
    );

    return order;
  }
}
