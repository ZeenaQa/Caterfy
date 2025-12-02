import 'package:caterfy/shared_widgets.dart/overlap_heart_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomerStoreListItem extends StatelessWidget {
  const CustomerStoreListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 90,
      width: double.infinity,
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 113,
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
              OverlapHeartButton(size: 15),
            ],
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.solidCircleCheck,
                      size: 13,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: const Text(
                        'Burger shop',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.locationDot,
                      size: 13,
                      color: colors.onSecondary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: const Text(
                        'Amman',
                        style: TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    // spacing: 6,
                    children: [
                      Icon(
                        FontAwesomeIcons.solidStar,
                        size: 13,
                        color: colors.secondaryContainer,
                      ),
                      SizedBox(width: 6),
                      Text('5.3 (1k+) ', style: TextStyle(fontSize: 13)),
                      Text(
                        '• 15-20 mins • JOD 1.0',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
