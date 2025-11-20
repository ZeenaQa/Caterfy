import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomerNoOrders extends StatelessWidget {
  const CustomerNoOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            SvgPicture.asset(
              'assets/icons/no_orders.svg',
              height: 130,
              width: 130,
            ),
            SizedBox(height: 15),
            Text(
              "No orders yet",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            Text(
              "When you place your first order, it will appear here.",
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
