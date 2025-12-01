import 'package:caterfy/customers/customer_widgets/customer_no_orders.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/util/l10n_helper.dart';
import 'package:flutter/material.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: L10n.t.yourOrders),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [CustomerNoOrders()],
          ),
        ),
      ),
    );
  }
}
