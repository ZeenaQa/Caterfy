import 'package:caterfy/models/store.dart';
import 'package:caterfy/shared_widgets.dart/outlined_icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.network(
                store.bannerUrl!,
                height: 218,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SafeArea(
                child: Column(
                  spacing: 33,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: Row(
                        children: [
                          OutlinedIconBtn(
                            child: Icon(FontAwesomeIcons.arrowLeft, size: 15),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Spacer(),
                          OutlinedIconBtn(
                            child: Icon(FontAwesomeIcons.heart, size: 16),
                          ),
                          OutlinedIconBtn(
                            child: Icon(
                              FontAwesomeIcons.magnifyingGlass,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(13),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        border: BoxBorder.all(color: colors.outline),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 11,
                            children: [
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(store.logoUrl!),
                                    fit: BoxFit.cover,
                                  ),
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        store.name,
                                        style: TextStyle(
                                          fontSize: 16.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        FontAwesomeIcons.arrowsTurnRight,
                                        size: 17,
                                      ),
                                    ],
                                  ),
                                  // Text(store.tags?[0] ?? 'f'),
                                  if (store.tags != null &&
                                      store.tags!.isNotEmpty)
                                    Text(
                                      store.tags!.join(', '),
                                      style: TextStyle(
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
