import 'package:caterfy/customers/customer_widgets/customer_no_orders.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CustomerOrdersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.orders,
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
