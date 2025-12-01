import 'package:caterfy/util/l10n_helper.dart';
import 'package:caterfy/util/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CustomerNoOrders extends StatelessWidget {
  const CustomerNoOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final isDark = themeController.themeMode == ThemeMode.dark;
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            SvgPicture.asset(
              'assets/icons/${isDark ? 'no_orders_dark.svg' : 'no_orders.svg'}',
              height: 130,
              width: 130,
            ),
            SizedBox(height: 15),
            Text(
              L10n.t.noOrdersYet,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            Text(
              L10n.t.noOrdersTip,
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
