import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/customer_cart.dart';
import 'package:caterfy/shared_widgets.dart/outlined_icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final bool cartExists = customerProvider.cart?.storeId != null;

    return !cartExists
        ? SizedBox()
        : Stack(
            children: [
              OutlinedIconBtn(
                child: Icon(Icons.shopping_bag_rounded, size: 19),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomerCart()),
                  );
                },
              ),
              PositionedDirectional(
                bottom: 4,
                end: 2,
                child: IgnorePointer(
                  child: Container(
                    width: 21,
                    height: 21,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      border: Border.all(
                        color: colors.onInverseSurface,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        customerProvider.totalCartQuantity.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colors.onInverseSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
