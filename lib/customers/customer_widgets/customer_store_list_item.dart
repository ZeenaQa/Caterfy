import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/overlap_heart_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomerStoreListItem extends StatelessWidget {
  const CustomerStoreListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 90,
      width: double.infinity,
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://img.freepik.com/free-photo/burger-with-fries-tomato-sauce_114579-3697.jpg?semt=ais_hybrid&w=740&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                children: [SizedBox(width: 65), OverlapHeartButton(size: 15)],
              ),
            ],
          ),
          SizedBox(width: 13),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Row(
                spacing: 6,
                children: [
                  Icon(
                    FontAwesomeIcons.solidCircleCheck,
                    size: 13,
                    color: colors.primary,
                  ),
                  Text(
                    'Burger shop',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Row(
                spacing: 6,
                children: [
                  Icon(
                    FontAwesomeIcons.locationDot,
                    size: 13,
                    color: colors.onSecondary,
                  ),
                  Text('Amman', style: TextStyle(fontSize: 14)),
                ],
              ),
              Row(
                spacing: 6,
                children: [
                  Icon(
                    FontAwesomeIcons.solidStar,
                    size: 13,
                    color: colors.secondaryContainer,
                  ),
                  Text(
                    '5.3 (1k+) • 15-20 mins • JOD 1.00',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
