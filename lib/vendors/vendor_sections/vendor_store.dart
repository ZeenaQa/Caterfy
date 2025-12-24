import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/outlined_button.dart';
import 'package:caterfy/shared_widgets.dart/outlined_icon_btn.dart';
import 'package:caterfy/vendors/screens/create_store_screen.dart';
import 'package:caterfy/vendors/screens/edit_category_screen.dart';
import 'package:caterfy/vendors/screens/edit_product_screen.dart';
import 'package:caterfy/vendors/screens/edit_store.screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:caterfy/shared_widgets.dart/three_bounce.dart';

class VendorStoreSection extends StatefulWidget {
  const VendorStoreSection({super.key});

  @override
  State<VendorStoreSection> createState() => _VendorStoreSectionState();
}

class _VendorStoreSectionState extends State<VendorStoreSection> {
  bool isAddingCategory = false;
  String newCategoryName = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoggedVendorProvider>().checkVendorStore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoggedVendorProvider>();
    final colors = Theme.of(context).colorScheme;

    if (provider.isLoading) {
      return const Center(child: ThreeBounce());
    }

    if (!provider.hasStore || provider.store == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_mall_directory,
              size: 80,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            const Text(
              'Get Started',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'You don’t have a store yet. Let’s create one!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: colors.onSurface),
            ),
            const SizedBox(height: 15),
            FilledBtn(
              stretch: false,
              title: 'Create Store',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateStoreCarousel(),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    final store = provider.store!;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              if (store.bannerUrl != null)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(store.bannerUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              if (store.logoUrl != null)
                Positioned(
                  bottom: -40,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.outline),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        store.logoUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 56),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ===== STORE INFO =====
                Expanded(
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ===== STORE NAME =====
                      Text(
                        store.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      if (store.tags != null && store.tags!.isNotEmpty)
                        Text(
                          store.tags!.join(' • '),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.onSurfaceVariant,
                          ),
                        ),

                      /// ===== LOCATION =====
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: colors.onSurfaceVariant,
                          ),

                          Expanded(
                            child: Text(
                              store.storeArea ?? 'Store location',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                OutlinedBtn(
                  title: 'edit',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditStoreScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          /// ===== MENU HEADER =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Menu',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),

                OutlinedBtn(
                  title: 'add',
                  onPressed: () {
                    setState(() {
                      isAddingCategory = true;
                    });
                  },
                ),
              ],
            ),
          ),

          /// ===== ADD CATEGORY INLINE (UNDER MENU) =====
          if (isAddingCategory)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  /// TEXT FIELD
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      onChanged: (val) {
                        newCategoryName = val.trim();
                      },
                      decoration: const InputDecoration(
                        hintText: 'Category name',
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// CANCEL ❌
                  OutlinedIconBtn(
                    child: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        newCategoryName = '';
                        isAddingCategory = false;
                      });
                    },
                  ),

                  OutlinedIconBtn(
                    onPressed: () async {
                      if (newCategoryName.isEmpty) return;

                      await provider.addCategory(newCategoryName);

                      setState(() {
                        newCategoryName = '';
                        isAddingCategory = false;
                      });
                    },

                    child: const Icon(Icons.check),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: provider.subCategories.asMap().entries.map((entry) {
                final cat = entry.value;

                final subProducts = provider.products
                    .where((p) => p.subCategoryId == cat['id'])
                    .toList();

                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== Category label =====
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      // ===== Category name =====
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              cat['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditCategoryScreen(
                                    categoryId: cat['id'],
                                    categoryName: cat['name'],
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 2, 12, 8),
                        child: Text(
                          '${subProducts.length} Items',
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (subProducts.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'No products yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),

                      // ===== Products =====
                      ...subProducts.map(
                        (p) => Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditProductScreen(
                                      productId: p.id,
                                      name: p.name,
                                      description: p.description,
                                      price: p.price,
                                      imageUrl: p.imageUrl,
                                    ),
                                  ),
                                );
                              },

                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    p.imageUrl,
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  p.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${p.price} JOD',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),

                                trailing: const Icon(
                                  Icons.chevron_right,
                                  size: 20,
                                ),
                              ),
                            ),
                            Divider(height: 1, color: colors.surfaceContainer),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
