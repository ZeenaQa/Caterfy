import 'package:caterfy/customers/customer_widgets/animated_quantity_selector.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/product.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProductDrawerContent extends StatefulWidget {
  const ProductDrawerContent({super.key, required this.product});

  final Product product;

  @override
  State<ProductDrawerContent> createState() => ProductDrawerContentState();
}

class ProductDrawerContentState extends State<ProductDrawerContent> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final Product product = widget.product;
    final provider = Provider.of<LoggedCustomerProvider>(context);

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                product.name,
                style: TextStyle(
                  color: colors.onPrimaryFixed,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
              SizedBox(height: 5),
              Text(
                product.description,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: TextStyle(color: colors.secondary, fontSize: 13.5),
              ),
              SizedBox(height: 28),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.message,
                    color: colors.onSurface,
                    size: 18,
                  ),
                  SizedBox(width: 14),
                  Text(
                    "Any special requests?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Add note",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  RollingQuantitySelector(
                    onChanged: (value) => setState(() {
                      quantity = value;
                    }),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: FilledBtn(
                      onPressed: () {},
                      innerHorizontalPadding: 20,
                      content: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          provider.setTotalPrice(product.price * quantity);
                          provider.setProductsNum(quantity);
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            Text(
                              'Add item',
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
