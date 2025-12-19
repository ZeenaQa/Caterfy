import 'package:caterfy/models/order_item.dart';

class Cart {
  final String? storeId;
  final List<OrderItem> items = [];

  Cart({this.storeId});

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
}
