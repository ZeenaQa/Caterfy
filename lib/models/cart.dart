import 'package:caterfy/models/order_item.dart';

class Cart {
  final String customerId;
  final String? storeId;
  List<OrderItem> items = [];
  String _note = '';

  Cart({required this.customerId, this.storeId});

  get note => _note;

  void setItems(List<OrderItem> newList) {
    items = newList;
  }

  void setNote(String newNote) {
    _note = newNote;
  }

  void addItem({required OrderItem item}) {
    for (int i = 0; i < items.length; i++) {
      final orderItem = items[i];
      final bool isEqual =
          orderItem.productId == item.productId &&
          orderItem.note.trim() == item.note.trim();

      if (isEqual) {
        items[i] = orderItem.copyWith(
          quantity: orderItem.quantity + item.quantity,
        );
        return;
      }
    }

    items.add(item);
  }

  void setItemQuantity({required OrderItem item, required int newQuantity}) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == item.id) {
        items[i] = item.copyWith(quantity: newQuantity);
        return;
      }
    }
  }

  void setOrderItem({required OrderItem item}) {
    int itemIndex = -1;
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == item.id) {
        itemIndex = i;
      }
      if ((items[i].note.trim() == item.note.trim()) &&
          (items[i].id != item.id) &&
          (items[i].productId == item.productId)) {
        items[i] = items[i].copyWith(
          quantity: items[i].quantity + item.quantity,
        );
        deleteItem(orderItemId: item.id);
        return;
      }
    }
    if (itemIndex > -1) {
      items[itemIndex] = item;
    }
  }

  void deleteItem({required orderItemId}) {
    items.removeWhere((item) => item.id == orderItemId);
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'storeId': storeId,
      'note': _note,
      'items': items.map((e) => e.toMap()).toList(),
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    final cart = Cart(customerId: map['customerId'], storeId: map['storeId']);

    cart._note = map['note'] ?? '';

    cart.items.addAll(
      (map['items'] as List).map(
        (e) => OrderItem.fromMap(Map<String, dynamic>.from(e)),
      ),
    );

    return cart;
  }
}
