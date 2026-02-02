import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/customer_cart.dart';
import 'package:caterfy/customers/screens/customer_order_details_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/order.dart';
import 'package:caterfy/shared_widgets.dart/outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

const url =
    'https://marketplace.canva.com/EAGMppVJ_aY/1/0/1600w/canva-dark-green-cute-and-playful-kitchen-restaurant-logo-S2LGeYCK5eM.jpg';

class CustomerOrderCard extends StatelessWidget {
  const CustomerOrderCard({
    super.key,
    required this.order,
    this.dummyImage = false,
  });

  final Order order;
  final bool dummyImage;

  @override
  Widget build(BuildContext context) {
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
      return totalPrice + order.deliveryPrice + 0.2;
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
                  l10.delivered,
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: dummyImage
                          ? Image.asset(
                              'assets/images/app_icon.png',
                              fit: BoxFit.cover,
                              width: 55,
                              height: 55,
                            )
                          : Image.network(
                              order.storeLogo,
                              height: 55,
                              width: 55,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image);
                              },
                            ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.storeName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${order.items.length} items',
                            style: TextStyle(
                              height: 1.2,
                              color: colors.onSurface,
                            ),
                          ),
                        ],
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
                          text: '${l10.jod} ',
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
                Skeleton.ignore(
                  child: OutlinedBtn(
                    onPressed: () {
                      context.read<LoggedCustomerProvider>().orderAgain(
                        order: order,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CustomerCart()),
                      );
                    },
                    title: l10.orderAgain,
                    innerVerticalPadding: 10,
                    innerHorizontalPadding: 18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Row(
              spacing: 16,
              children: [
                Text("Rate", style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                Icon(
                  FontAwesomeIcons.star,
                  size: 18,
                  color: colors.outlineVariant,
                ),
                Icon(
                  FontAwesomeIcons.star,
                  size: 18,
                  color: colors.outlineVariant,
                ),
                Icon(
                  FontAwesomeIcons.star,
                  size: 18,
                  color: colors.outlineVariant,
                ),
                Icon(
                  FontAwesomeIcons.star,
                  size: 18,
                  color: colors.outlineVariant,
                ),
                Icon(
                  FontAwesomeIcons.star,
                  size: 18,
                  color: colors.outlineVariant,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
