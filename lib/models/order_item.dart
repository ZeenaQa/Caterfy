import 'package:caterfy/models/product.dart';

class OrderItem {
  final String id;
  final String productId;
  final Product snapshot;
  final int quantity;
  final String note;

  OrderItem({
    required this.id,
    required this.snapshot,
    required this.productId,
    this.quantity = 1,
    this.note = '',
  });

  OrderItem copyWith({
    String? productId,
    Product? snapshot,
    int? quantity,
    String? note,
  }) {
    return OrderItem(
      id: id,
      productId: productId ?? this.productId,
      snapshot: snapshot ?? this.snapshot,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }
}
