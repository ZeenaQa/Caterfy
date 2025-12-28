import 'package:caterfy/dummy_data.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:caterfy/vendors/vendor_widgets/vendor_no_orders.dart';
import 'package:caterfy/vendors/vendor_widgets/vendor_order_card.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VendorOrdersSection extends StatelessWidget {
  const VendorOrdersSection({super.key, this.removeTitle = false});
  final bool removeTitle;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final vendorProvider = Provider.of<LoggedVendorProvider>(context);
    final orders = vendorProvider.orders;
    // final orders = [];
    final isLoading = vendorProvider.isOrdersLoading;

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
                VendorNoOrders()
              else ...[
                if (!removeTitle) SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: isLoading
                        ? dummyVendorOrders.length
                        : orders.length,
                    itemBuilder: (context, index) {
                      final order = isLoading
                          ? dummyVendorOrders[index]
                          : orders[index];
                      if (index == orders.length - 1) {
                        return Column(
                          children: [
                            VendorOrderCard(order: order),
                            // CustomerOrderCard(order: order, dummyImage: isLoading),
                            SizedBox(height: 25),
                          ],
                        );
                      } else {
                        return VendorOrderCard(order: order);
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
