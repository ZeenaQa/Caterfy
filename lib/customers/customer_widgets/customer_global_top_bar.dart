import 'package:caterfy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomerGlobalTopBar extends StatelessWidget {
  final double height;

  const CustomerGlobalTopBar({this.height = 130, super.key});

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          // top: 21,
          // bottom: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 6,
              children: [
                Icon(
                  FontAwesomeIcons.locationDot,
                  size: 16,
                  color: colors.onPrimary,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Deliver to ',
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text: 'Hashimate University',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 17),
            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.symmetric(vertical: 9, horizontal: 20),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  Icon(Icons.search, color: Color(0xff9d9d9d), size: 21),
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
