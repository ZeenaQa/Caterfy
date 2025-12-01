import 'package:caterfy/util/l10n_helper.dart';
import 'package:flutter/material.dart';

class CustomerHomeCategories extends StatelessWidget {
  final double topMargin;
  const CustomerHomeCategories({super.key, this.topMargin = 130});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topMargin + 30),
      child: Align(
        alignment: Alignment.topCenter, // horizontally centered only
        child: Wrap(
          spacing: 10,
          runSpacing: 15,
          children: [
            CategoryBox(
              title: L10n.t.food,
              image: 'assets/images/burger_icon.png',
            ),
            CategoryBox(
              title: L10n.t.ceemart,
              image: 'assets/images/caterfy_mart_icon.png',
            ),
            CategoryBox(
              title: L10n.t.groceries,
              image: 'assets/images/grocery_icon.png',
            ),
            CategoryBox(
              title: L10n.t.electronics,
              image: 'assets/images/electronics_icon.png',
            ),
            CategoryBox(
              title: L10n.t.pharmacy,
              image: 'assets/images/pharmacy_icon.png',
            ),

            CategoryBox(
              title: L10n.t.toysAndKids,
              image: 'assets/images/toys2_icon.png',
            ),

            CategoryBox(
              title: L10n.t.healthAndBeauty,
              image: 'assets/images/health_and_beauty_icon.png',
            ),
            CategoryBox(
              title: L10n.t.pets,
              image: 'assets/images/pets_icon.png',
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryBox extends StatelessWidget {
  const CategoryBox({super.key, required this.title, this.image = ''});

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      spacing: 7,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.circular(13),
          ),
          width: 85,
          height: 85,
          padding: EdgeInsets.all(20),
          child: image.isNotEmpty ? Image.asset(image) : null,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
