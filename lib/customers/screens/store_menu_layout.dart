import 'package:caterfy/customers/customer_widgets/product_item.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/models/product.dart';
import 'package:caterfy/models/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreMenuLayout extends StatefulWidget {
  const StoreMenuLayout({super.key, required this.store});

  final Store store;

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
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<LoggedCustomerProvider>(
        context,
        listen: false,
      );
      await provider.fetchProducts(storeId: widget.store.id, context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final List<Product> products = customerProvider.products;

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
