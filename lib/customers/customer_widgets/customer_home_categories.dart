import 'package:caterfy/customers/screens/customer_category_screen.dart';
import 'package:caterfy/customers/screens/location_picker_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerHomeCategories extends StatelessWidget {
  final double topMargin;
  const CustomerHomeCategories({super.key, this.topMargin = 130});

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final globalProvider = Provider.of<GlobalProvider>(context);
    final location = globalProvider.lastPickedLocation;

    void navigateToCategory({required String category}) {
      if (location == null) {
        showCustomDialog(
          context,
          title: l10.location,
          content: l10.pickLocationRequired,
          confirmText: l10.pickLocation,
          cancelText: l10.cancel,
          onConfirmAsync: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
            );
          },
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CategoryScreen(category: category)),
      );
    }

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
              onTap: () => navigateToCategory(category: "food"),
            ),
            CategoryBox(
              title: l10.ceemart,
              image: 'assets/images/caterfy_mart_icon.png',
              onTap: () => navigateToCategory(category: "ceemart"),
            ),
            CategoryBox(
              title: l10.groceries,
              image: 'assets/images/grocery_icon.png',
              onTap: () => navigateToCategory(category: "groceries"),
            ),
            CategoryBox(
              title: l10.electronics,
              image: 'assets/images/electronics_icon.png',
              onTap: () => navigateToCategory(category: "electronics"),
            ),
            CategoryBox(
              title: l10.pharmacy,
              image: 'assets/images/pharmacy_icon.png',
              onTap: () => navigateToCategory(category: "pharmacy"),
            ),

            CategoryBox(
              title: l10.toysAndKids,
              image: 'assets/images/toys2_icon.png',
            ),

            CategoryBox(
              onTap: () => {},
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
              color: colors.onPrimaryFixedVariant,
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
