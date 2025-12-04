import 'package:caterfy/customers/customer_widgets/customer_no_orders.dart';
import 'package:caterfy/l10n/app_localizations.dart';

import 'package:flutter/material.dart';

class CustomerOrdersSection extends StatelessWidget {
  const CustomerOrdersSection({super.key, this.removeTitle = false});
  final bool removeTitle;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!removeTitle)
              Text(
                l10.orders,
                style: TextStyle(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            CustomerNoOrders(),
          ],
        ),
      ),
    );
  }
}
