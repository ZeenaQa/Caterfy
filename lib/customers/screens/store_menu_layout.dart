import 'package:caterfy/customers/customer_widgets/product_item.dart';
import 'package:caterfy/models/product.dart';
import 'package:caterfy/models/store.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    final List<Product> products = [
      // --- BURGERS ---
      Product(
        id: '101',
        foodCategory: 'Burgers',
        storeId: widget.store.id,
        name: 'Double Cheese Burger',
        description:
            'Two beef patties with cheddar cheese, lettuce, and special sauce.',
        price: 6.50,
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=60',
             subCategoryId: '',
      ),
      Product(
        id: '102',
        foodCategory: 'Burgers',
        storeId: widget.store.id,
        name: 'Mushroom Swiss Burger',
        description: 'Grilled mushroom, swiss cheese, and caramelized onions.',
        price: 7.20,
        imageUrl:
            'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?auto=format&fit=crop&w=500&q=60', subCategoryId: '',
      ),
      Product(
        id: '103',
        foodCategory: 'Burgers',
        storeId: widget.store.id,
        name: 'Spicy Chicken Zinger',
        description: 'Fried chicken breast with spicy mayo and coleslaw.',
        price: 5.80,
        imageUrl:
            'https://images.unsplash.com/photo-1615557960916-5f4791effe9d?auto=format&fit=crop&w=500&q=60', subCategoryId: '',
      ),

      // --- SHAWARMA ---
      Product(
        id: '201',
        foodCategory: 'Shawarma',
        storeId: widget.store.id,
        name: 'Classic Beef Shawarma',
        description: 'Authentic beef shawarma with tahini, parsley, and sumac.',
        price: 3.50,
        imageUrl:
            'https://i0.wp.com/shawarmaandalos.ca/wp-content/uploads/2024/01/Beef-Shawarma.png?fit=1000%2C1000&ssl=1', subCategoryId: '',
      ),
      Product(
        id: '202',
        foodCategory: 'Shawarma',
        storeId: widget.store.id,
        name: 'Chicken Shawarma Wrap',
        description: 'Served with garlic sauce (toum) and pickles.',
        price: 3.00,
        imageUrl:
            'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?auto=format&fit=crop&w=500&q=60', subCategoryId: '',
      ),
      Product(
        id: '203',
        foodCategory: 'Shawarma',
        storeId: widget.store.id,
        name: 'Shawarma Arabi Meal',
        description: 'Cut shawarma bites served with fries and extra dips.',
        price: 6.00,
        imageUrl:
            'https://images.unsplash.com/photo-1619526881542-c81baff85fa4?auto=format&fit=crop&w=500&q=60', subCategoryId: '',
      ),

      // --- DRINKS ---
      Product(
        id: '301',
        foodCategory: 'Drinks',
        storeId: widget.store.id,
        name: 'Coca Cola Zero',
        description: '330ml can chilled.',
        price: 1.00,
        imageUrl:
            'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?auto=format&fit=crop&w=500&q=60', subCategoryId: '',
      ),
      Product(
        id: '302',
        foodCategory: 'Drinks',
        storeId: widget.store.id,
        name: 'Fresh Orange Juice',
        description: 'Freshly squeezed orange juice without sugar.',
        price: 2.50,
        imageUrl:
            'https://images.unsplash.com/photo-1613478223719-2ab802602423?auto=format&fit=crop&w=500&q=60', subCategoryId: '',
      ),
    ];

    // Group items
    final grouped = <String, List<Product>>{};
    for (var p in products) {
      grouped.putIfAbsent(p.foodCategory, () => []);
      grouped[p.foodCategory]!.add(p);
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
