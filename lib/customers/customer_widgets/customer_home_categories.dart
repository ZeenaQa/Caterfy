import 'package:caterfy/customers/screens/customer_category_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomerHomeCategories extends StatelessWidget {
  final double topMargin;
  const CustomerHomeCategories({super.key, this.topMargin = 130});

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(top: topMargin + 30),
      child: Align(
        alignment: Alignment.topCenter,
        child: Wrap(
          spacing: 10,
          runSpacing: 15,
          children: [
            CategoryBox(
              title: l10.food,
              image: 'assets/images/burger_icon.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryScreen(category: 'food'),
                  ),
                );
              },
            ),
            CategoryBox(
              title: l10.ceemart,
              image: 'assets/images/caterfy_mart_icon.png',
                 onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryScreen(category: 'ceemart'),
                  ),
                );
              },
            ),
            CategoryBox(
              title: l10.groceries,
              image: 'assets/images/grocery_icon.png',
                 onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryScreen(category: 'groceries'),
                  ),
                );
              },
            ),
            CategoryBox(
              title: l10.electronics,
              image: 'assets/images/electronics_icon.png',
                 onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryScreen(category: 'electronics'),
                  ),
                );
              },
            ),
            CategoryBox(
              title: l10.pharmacy,
              image: 'assets/images/pharmacy_icon.png',
                 onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryScreen(category: 'pharmacy'),
                  ),
                );
              },
            ),

            CategoryBox(
              title: l10.toysAndKids,
              image: 'assets/images/toys2_icon.png',
            ),

            CategoryBox(
              title: l10.healthAndBeauty,
              image: 'assets/images/health_and_beauty_icon.png',
            ),
            CategoryBox(title: l10.pets, image: 'assets/images/pets_icon.png'),
          ],
        ),
      ),
    );
  }
}

class CategoryBox extends StatelessWidget {
  const CategoryBox({
    super.key,
    required this.title,
    this.image = '',
    this.onTap,
  });

  final String title;
  final String image;
  final GestureCancelCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      spacing: 7,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              borderRadius: BorderRadius.circular(13),
            ),
            width: 85,
            height: 85,
            padding: EdgeInsets.all(20),
            child: image.isNotEmpty ? Image.asset(image) : null,
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
