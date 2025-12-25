import 'package:caterfy/customers/customer_widgets/customer_no_orders.dart';
import 'package:caterfy/customers/customer_widgets/order_card.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/dummy_data.dart';
import 'package:caterfy/l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomerOrdersSection extends StatelessWidget {
  const CustomerOrdersSection({super.key, this.removeTitle = false});
  final bool removeTitle;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final orders = customerProvider.orderHistory;
    // final orders = [];
    final isLoading = customerProvider.isOrderHistoryLoading;

    return SafeArea(
      child: Skeletonizer(
        enabled: isLoading,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!removeTitle)
                Skeleton.keep(
                  child: Text(
                    l10.orders,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              if (orders.isEmpty && !isLoading)
                CustomerNoOrders()
              else ...[
                if (!removeTitle) SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: isLoading ? dummyOrders.length : orders.length,
                    itemBuilder: (context, index) {
                      final order = isLoading
                          ? dummyOrders[index]
                          : orders[index];
                      if (index == orders.length - 1) {
                        return Column(
                          children: [
                            OrderCard(order: order, dummyImage: isLoading),
                            SizedBox(height: 25),
                          ],
                        );
                      } else {
                        return OrderCard(order: order, dummyImage: isLoading);
                      }
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16);
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
