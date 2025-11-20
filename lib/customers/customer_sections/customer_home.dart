import 'package:caterfy/util/wavy_border_shape.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomerHomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130,
        backgroundColor: colors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        shape: WavyShapeBorder(waveHeight: 4),
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 21,
              bottom: 16,
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
                      color: colors.surface,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Deliver to ',
                        style: TextStyle(
                          color: colors.surface,
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
                        'Search Caterfy',
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
        ),
      ),
      body: Center(child: Text('Home content here')),
    );
  }
}
