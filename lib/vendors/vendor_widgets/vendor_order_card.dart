import 'package:caterfy/customers/screens/customer_order_details_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/vendor_order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

const url =
    'https://marketplace.canva.com/EAGMppVJ_aY/1/0/1600w/canva-dark-green-cute-and-playful-kitchen-restaurant-logo-S2LGeYCK5eM.jpg';

class VendorOrderCard extends StatelessWidget {
  const VendorOrderCard({super.key, required this.order});

  final VendorOrder order;

  @override
  Widget build(BuildContext context) {
    String getInitial(String name) {
      if (name.isEmpty) return '';
      return name[0].toUpperCase();
    }

    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final orderDate = order.createdAt != null
        ? DateFormat(
            "MMM d - h:mm a",
          ).format(DateTime.parse(order.createdAt!).toLocal())
        : '';

    double getTotalPrice() {
      double totalPrice = 0;
      for (int i = 0; i < order.items.length; i++) {
        final price = order.items[i].price;
        final quantity = order.items[i].quantity;
        totalPrice += price * quantity;
      }
      return totalPrice;
    }

    return Container(
      width: double.infinity,
      // height: 100,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.outline)),
            ),
            child: Row(
              spacing: 13,
              children: [
                Text(
                  "Delivered",
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  orderDate,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.onPrimaryContainer,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          getInitial(order.customerName ?? ''),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        order.customerName ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: 'JOD ',
                          style: TextStyle(
                            color: colors.onSurface,
                            fontWeight: FontWeight.normal,
                          ),
                          children: [
                            TextSpan(
                              text: getTotalPrice().toStringAsFixed(2),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CustomerOrderDetailScreen(),
                          ),
                        ),
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          l10.viewDetails,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: colors.onSurface,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
