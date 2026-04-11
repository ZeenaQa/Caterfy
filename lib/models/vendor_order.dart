import 'package:caterfy/models/order_item.dart';

class VendorOrder {
  final String id;
  final String customerId;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final List<OrderItem> items;
  final String note;
  final String? createdAt;
  final String? status;

  VendorOrder({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    this.customerPhone = '',
    this.status,
    List<OrderItem>? items,
    this.note = '',
    this.createdAt,
  }) : items = List.from(items ?? []);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'status': status,
      'note': note,
      'items': items.map((e) => e.toMap()).toList(),
      'created_at': createdAt,
    };
  }

  factory VendorOrder.fromMap(Map<String, dynamic> map) {
    final order = VendorOrder(
      id: map['id'] ?? '',
      customerId: map['customer_id'],
      customerName: map['customer_name'] ?? "",
      customerEmail: map['customer_email'],
      customerPhone: map['customer_phone'] ?? "",
      status: map['status'] as String?,
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
