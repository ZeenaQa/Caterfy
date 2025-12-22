import 'package:caterfy/customers/customer_widgets/add_note.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:caterfy/shared_widgets.dart/quantity_selector.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/order_item.dart';
import 'package:caterfy/models/product.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProductDrawerContent extends StatefulWidget {
  const ProductDrawerContent({
    super.key,
    required this.product,
    this.isInCart = false,
    this.orderItem,
  });

  final Product product;
  final bool isInCart;
  final OrderItem? orderItem;

  @override
  State<ProductDrawerContent> createState() => ProductDrawerContentState();
}

class ProductDrawerContentState extends State<ProductDrawerContent> {
  int quantity = 1;
  String localNote = '';

  @override
  void initState() {
    super.initState();
    if (widget.orderItem == null) return;
    quantity = widget.orderItem!.quantity;
    localNote = widget.orderItem!.note;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final Product product = widget.product;
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);

    return Column(
      spacing: 15,
      children: [
        Container(
          height: 307,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
            image: DecorationImage(
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                product.name,
                style: TextStyle(
                  color: colors.onPrimaryFixed,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                product.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: TextStyle(color: colors.secondary, fontSize: 13.5),
              ),
            ),
            SizedBox(height: 28),
            TextButton(
              onPressed: () {
                openDrawer(
                  context,
                  showCloseBtn: false,
                  child: AddNote(
                    initialNote: localNote,
                    onCloseNote: (note) => setState(() {
                      localNote = note;
                    }),
                  ),
                  borderRadius: 0,
                  accountForKeyboard: true,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: colors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.message,
                      color: colors.onSurface,
                      size: 18,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Any special requests?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                          ),
                          if (localNote.trim().isNotEmpty)
                            Text(
                              localNote,
                              style: TextStyle(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      localNote.isEmpty ? "Add note" : "Edit",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: colors.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: [
                  QuantitySelector(
                    initialValue: widget.orderItem?.quantity ?? 1,
                    onChanged: (value) => setState(() {
                      quantity = value;
                    }),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: FilledBtn(
                      onPressed: () {
                        final bool isInCart =
                            widget.isInCart && widget.orderItem != null;

                        final OrderItem item = OrderItem(
                          id: isInCart ? widget.orderItem!.id : Uuid().v4(),
                          productId: product.id,
                          storeId: product.storeId,
                          name: product.name,
                          imageUrl: product.imageUrl,
                          price: product.price,
                          quantity: quantity,
                          note: localNote,
                        );

                        if (isInCart) {
                          customerProvider.setOrderItem(item: item);
                        } else {
                          customerProvider.addToCart(item: item);
                        }

                        Navigator.of(context).pop();
                      },
                      innerHorizontalPadding: 20,
                      content: Row(
                        children: [
                          Text(
                            widget.isInCart ? "Update" : 'Add item',
                            style: TextStyle(
                              color: colors.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.5,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '${l10.jod} ${(product.price * quantity).toString()}',
                            style: TextStyle(
                              color: colors.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
