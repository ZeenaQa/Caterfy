import 'package:caterfy/customers/customer_widgets/cart_item.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerCart extends StatelessWidget {
  const CustomerCart({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final items = customerProvider.cart?.items ?? const [];

    return Scaffold(
      appBar: CustomAppBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cart",
              style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold),
            ),
            Text(
              "Burger Makers",
              style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return CartItem(
                  orderItem: items[index],
                  isLastItem: index == items.length - 1,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
