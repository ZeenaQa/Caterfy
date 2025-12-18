import 'package:caterfy/models/order_item.dart';

class Cart {
  final String? storeId;
  final List<OrderItem> items = [];

  Cart({this.storeId});

  void addItem({required OrderItem item}) {
    for (int i = 0; i < items.length; i++) {
      final orderItem = items[i];
      final bool isEqual =
          orderItem.productId == item.productId && orderItem.note == item.note;

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

  void setItemNote({required String orderItemId, required String note}) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == orderItemId) {
        items[i] = items[i].copyWith(note: note);
        return;
      }
    }
  }

  void setOrderItem({required OrderItem item}) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == item.id) {
        items[i] = item;
        return;
      }
    }
  }

  void deleteItem({required orderItemId}) {
    items.removeWhere((item) => item.id == orderItemId);
  }
}
