import 'package:caterfy/customers/customer_widgets/cart_button.dart';
import 'package:caterfy/customers/screens/location_picker_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CustomerGlobalTopBar extends StatelessWidget {
  final double height;

  const CustomerGlobalTopBar({this.height = 130, super.key});

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.locationDot,
                      size: 16,
                      color: colors.onPrimary,
                    ),
                    SizedBox(width: 6),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LocationPickerScreen(),
                          ),
                        );
                      },
                      child: Consumer<GlobalProvider>(
                        builder: (_, provider, __) {
                          return RichText(
                            text: TextSpan(
                              text: '${l10.deliverTo} ',
                              style: TextStyle(
                                color: colors.onPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                              children: [
                                TextSpan(
                                  text: provider.deliveryLocation,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                PositionedDirectional(end: 0, top: -15, child: CartButton()),
              ],
            ),
            SizedBox(height: 19),
            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.symmetric(vertical: 9, horizontal: 20),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.search, color: Color(0xff9d9d9d), size: 21),
                  SizedBox(width: 10),
                  Text(
                    l10.search,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff9d9d9d),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
