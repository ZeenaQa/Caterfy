import 'package:caterfy/customers/customer_widgets/customer_no_orders.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';

import 'package:flutter/material.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: l10.yourOrders),
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
