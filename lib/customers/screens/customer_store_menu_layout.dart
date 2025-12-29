import 'package:caterfy/customers/customer_widgets/product_item.dart';
import 'package:caterfy/models/product.dart';
import 'package:caterfy/models/store.dart';
import 'package:flutter/material.dart';

class StoreMenuLayout extends StatefulWidget {
  const StoreMenuLayout({
    super.key,
    required this.store,
    this.products = const [],
  });

  final Store store;

  final List<Product> products;

  @override
  State<StoreMenuLayout> createState() => _StoreMenuLayoutState();
}

class _StoreMenuLayoutState extends State<StoreMenuLayout> {
  final ScrollController scrollController = ScrollController();
  final Map<String, GlobalKey> categoryKeys = {};

  // ---------------------------
  // SCROLL TO CATEGORY
  // ---------------------------
  void scrollToCategory(String category) {
    final key = categoryKeys[category];
    if (key == null) return;

    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0.3,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> products = widget.products;

    // Group items
    final grouped = <String, List<Product>>{};
    for (var p in products) {
      grouped.putIfAbsent(p.subCategory, () => []);
      grouped[p.subCategory]!.add(p);
    }

    final categories = grouped.keys.toList();

    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     scrollToCategory("Shawarma");
            //   },
            //   child: Text('Shawarma'),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: categories.map((category) {
                // Create key for each category
                categoryKeys[category] ??= GlobalKey();

                final items = grouped[category]!;

                return Column(
                  key: categoryKeys[category], // <--- IMPORTANT
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CATEGORY HEADER
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

                    // PRODUCTS
                    ...items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final product = entry.value;

                      return ProductItem(
                        product: product,
                        isStoreOpen: widget.store.isOpen,
                        isLastItem: index == items.length - 1,
                      );
                    }),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
