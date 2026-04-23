import 'package:caterfy/customers/customer_widgets/customer_home_ads_carousel.dart';
import 'package:caterfy/customers/screens/customer_category_screen.dart';
import 'package:caterfy/customers/screens/laundry_screen.dart';
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

    final List<Map> regularCategories = [
      {'title': l10.food, 'image': 'burger_icon.png', 'category': "food"},
      {
        'title': l10.ceemart,
        'image': 'caterfy_mart_icon.png',
        'category': "ceemart",
      },
      {
        'title': l10.groceries,
        'image': 'grocery_icon.png',
        'category': "groceries",
      },
      {
        'title': l10.electronics,
        'image': 'electronics_icon.png',
        'category': "electronics",
      },
      {
        'title': l10.pharmacy,
        'image': 'pharmacy_icon.png',
        'category': "pharmacy",
      },
      {
        'title': l10.toysAndKids,
        'image': 'toys2_icon.png',
        'category': "toysAndKids",
      },
      {
        'title': l10.healthAndBeauty,
        'image': 'health_and_beauty_icon.png',
        'category': "healthAndBeauty",
      },
      {'title': l10.pets, 'image': 'pets_icon.png', 'category': "pets"},
    ];

    final List<Map> serviceCategories = [
      {
        'title': l10.eVouchers,
        'image': 'e_vouchers.png',
        'category': "eVouchers",
      },
      {'title': l10.laundry, 'image': 'laundry.png', 'category': "laundry"},
      {'title': l10.myHouse, 'image': 'my_house.png', 'category': "myHouse"},
      {'title': l10.myCar, 'image': 'my_car.png', 'category': "myCar"},
      {'title': l10.charity, 'image': 'charity.png', 'category': "charity"},
    ];

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

      if (category == "laundry") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LaundryScreen()),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeAdsCarousel(
              // onTap: (banner) {
              //   Navigator.pushNamed(
              //     context,
              //     '/restaurant',
              //     arguments: banner.restaurantId,
              //   );
              // },
            ),
            SizedBox(height: 30),
            Center(
              child: Wrap(
                spacing: 10,
                runSpacing: 15,
                children: regularCategories.map((item) {
                  return CategoryBox(
                    title: item['title'],
                    image: 'assets/images/${item['image']}',
                    onTap: () => navigateToCategory(category: item['category']),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 20),
              child: Text(
                l10.yourEverythingApp,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 130,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: serviceCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final item = serviceCategories[index];
                  return Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: index == 0 ? 20.0 : 0.0,
                      end: index == serviceCategories.length - 1 ? 20 : 0,
                    ),
                    child: CategoryBox(
                      title: item['title'],
                      image: 'assets/images/${item['image']}',
                      onTap: () =>
                          navigateToCategory(category: item['category']),
                    ),
                  );
                },
              ),
            ),
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
