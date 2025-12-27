import 'package:flutter/material.dart';
import 'package:caterfy/vendors/vendor_widgets/page_wrapper.dart';
import 'package:caterfy/l10n/app_localizations.dart';

class StoreTagsPage extends StatelessWidget {
  final List<String> selectedTags;
  final ValueChanged<List<String>> onTagsChanged;

  const StoreTagsPage({
    super.key,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  static const _tags = [
    "Pizza",
    "Burger",
    "Desserts",
    "Drinks",
    "Coffee",
    "Bakery",
    "Fast Food",
    "Healthy Food",
    "Grocery",
    "Supermarket",
    "Mini Market",
    "Fruits & Vegetables",
    "Butcher",
    "Dairy",
    "Cleaning",
    "Laundry",
    "Maintenance",
    "Delivery",
    "Car Wash",
    "Printing",
    "Computers",
    "Mobile Phones",
    "Electronics",
    "Accessories",
    "Repair",
    "Clothes",
    "Shoes",
    "Gifts",
    "Flowers",
    "Pharmacy",
    "Beauty",
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    return PageWrapper(
      title: l10.tags,
      subtitle: l10.chooseStoreTags,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _tags.map((tag) {
          final selected = selectedTags.contains(tag);

          return ChoiceChip(
            label: Text(tag),
            selected: selected,
            selectedColor: colors.primary.withOpacity(0.15),
            onSelected: (value) {
              final newTags = List<String>.from(selectedTags);

              if (value) {
                newTags.add(tag);
              } else {
                newTags.remove(tag);
              }

              onTagsChanged(newTags);
            },
          );
        }).toList(),
      ),
    );
  }
}
