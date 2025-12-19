import 'package:caterfy/shared_widgets.dart/cart_quantity_selector.dart';
import 'package:caterfy/customers/customer_widgets/product_drawer_content.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/order_item.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  const CartItem({super.key, required this.orderItem, this.isLastItem = false});

  final OrderItem orderItem;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => openDrawer(
        context,
        padding: EdgeInsets.only(bottom: 0),
        isStack: true,
        child: ProductDrawerContent(
          product: orderItem.snapshot,
          isInCart: true,
          orderItem: orderItem,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 13),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isLastItem ? Colors.transparent : colors.outline,
              ),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        orderItem.snapshot.name,
                        style: TextStyle(
                          color: colors.onPrimaryFixed,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 2),
                      if (orderItem.note.isNotEmpty) ...[
                        Text(
                          orderItem.note,
                          style: TextStyle(
                            color: colors.secondary,
                            fontSize: 12.5,
                          ),
                        ),
                        SizedBox(height: 7),
                      ],
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 6,
                        children: [
                          Icon(
                            FontAwesomeIcons.penToSquare,
                            color: colors.primary,
                            size: 14,
                          ),
                          Text(
                            "Edit",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                              color: colors.primary,
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Spacer(),
                      RichText(
                        text: TextSpan(
                          text: '${l10.jod} ',
                          style: TextStyle(
                            color: colors.onSurface,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  (orderItem.snapshot.price * orderItem.quantity).toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                SizedBox(
                  height: 130,
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.network(
                          orderItem.snapshot.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image);
                          },
                        ),
                      ),
                      Positioned(
                        top: 75,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            width: 130,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: CartQuantitySelector(
                                height: 40,
                                initialValue: orderItem.quantity,
                                deleteFunction: () =>
                                    customerProvider.deleteItemFromCart(
                                      orderItemId: orderItem.id,
                                    ),
                                onChanged: (val) {
                                  customerProvider.setItemQuantity(
                                    item: orderItem,
                                    newQuantity: val,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
