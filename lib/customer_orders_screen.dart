import 'package:caterfy/customer_no_orders.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:flutter/material.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Orders",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              CustomerNoOrders(),
            ],
          ),
        ),
      ),
    );
  }
}
