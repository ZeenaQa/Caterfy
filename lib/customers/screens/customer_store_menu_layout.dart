import 'package:caterfy/customers/customer_widgets/product_item.dart';
import 'package:caterfy/models/product.dart';
import 'package:caterfy/models/store.dart';
import 'package:flutter/material.dart';

class StoreMenuLayout extends StatefulWidget {
  const StoreMenuLayout({
    super.key,
    required this.store,
    required this.categoryKeys,
    this.products = const [],
  });

  final Store store;
  final List<Product> products;
  final Map<String, GlobalKey> categoryKeys;

  @override
  State<StoreMenuLayout> createState() => _StoreMenuLayoutState();
}

class _StoreMenuLayoutState extends State<StoreMenuLayout> {
  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<Product>>{};
    for (var p in widget.products) {
      grouped.putIfAbsent(p.subCategory, () => []).add(p);
    }
    final categories = grouped.keys.toList();

    return SingleChildScrollView(
      // Disable independent scrolling — the outer SingleChildScrollView
      // handles all vertical scrolling so the sticky tab bar works correctly.
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categories.map((category) {
            widget.categoryKeys[category] ??= GlobalKey();
            final items = grouped[category]!;
            return Column(
              key: widget.categoryKeys[category],
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...items.asMap().entries.map((entry) {
                  return ProductItem(
                    product: entry.value,
                    isStoreOpen: widget.store.isOpen,
                    isLastItem: entry.key == items.length - 1,
                  );
                }),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
