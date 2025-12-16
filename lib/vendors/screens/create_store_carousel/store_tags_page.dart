import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:caterfy/vendors/vendor_widgets/page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreTagsPage extends StatelessWidget {
  const StoreTagsPage({super.key});

  static const _tags = [
    "Pizza","Burger","Desserts","Drinks","Coffee","Bakery",
    "Fast Food","Healthy Food","Grocery","Supermarket",
    "Mini Market","Fruits & Vegetables","Butcher","Dairy",
    "Cleaning","Laundry","Maintenance","Delivery","Car Wash",
    "Printing","Computers","Mobile Phones","Electronics",
    "Accessories","Repair","Clothes","Shoes","Gifts",
    "Flowers","Pharmacy","Beauty",
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final provider = context.watch<LoggedVendorProvider>();
    final storeForm = provider.storeForm;

    if (storeForm == null) return const SizedBox();

    final selectedTags = storeForm.tags ?? [];

    return PageWrapper(
      title: "Tags",
      subtitle: "Choose store tags",
      child: SingleChildScrollView(
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

                provider.updateStoreForm(tags: newTags);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
