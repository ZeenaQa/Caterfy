import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/outlined_button.dart';
import 'package:caterfy/shared_widgets.dart/outlined_icon_btn.dart';
import 'package:caterfy/vendors/screens/app_screens/create_store_screen.dart';
import 'package:caterfy/vendors/screens/app_screens/edit_category_screen.dart';
import 'package:caterfy/vendors/screens/app_screens/edit_product_screen.dart';
import 'package:caterfy/vendors/screens/app_screens/edit_store.screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
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
  String newCategoryNameEn = '';
  String newCategoryNameAr = '';

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
    final l10 = AppLocalizations.of(context);

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
            Text(
              l10.getStarted,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10.noStoreYet,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: colors.onSurface),
            ),
            const SizedBox(height: 15),
            FilledBtn(
              stretch: false,
              title: l10.createStore,
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
    final storeNameToShow =
        Localizations.localeOf(context).languageCode == 'ar' &&
            (store.name_ar.isNotEmpty)
        ? store.name_ar
        : store.name;
    String catLabel(Map<String, dynamic> cat) {
      return Localizations.localeOf(context).languageCode == 'ar' &&
              (cat['name_ar']?.isNotEmpty ?? false)
          ? cat['name_ar'] ?? ''
          : cat['name'] ?? '';
    }

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
                        storeNameToShow,
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
                              store.storeArea ?? l10.storeLocation,
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
                  title: l10.edit,
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
                Text(
                  l10.menu,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),

                OutlinedBtn(
                  title: l10.add,
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
                    child: Column(
                      children: [
                        TextField(
                          autofocus: true,
                          onChanged: (val) {
                            newCategoryNameEn = val.trim();
                          },
                          decoration: InputDecoration(
                            hintText: l10.enterCategoryNameEnglish,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: (val) {
                            newCategoryNameAr = val.trim();
                          },
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            hintText: l10.enterCategoryNameArabic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// CANCEL ❌
                  OutlinedIconBtn(
                    child: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        newCategoryNameEn = '';
                        newCategoryNameAr = '';
                        isAddingCategory = false;
                      });
                    },
                  ),

                  OutlinedIconBtn(
                    onPressed: () async {
                      if (newCategoryNameEn.isEmpty) return;

                      await provider.addCategory(
                        newCategoryNameEn,
                        nameAr: newCategoryNameAr.isEmpty
                            ? null
                            : newCategoryNameAr,
                      );

                      setState(() {
                        newCategoryNameEn = '';
                        newCategoryNameAr = '';
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
                            l10.category,
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
                              catLabel(cat),
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
                          '${subProducts.length} ${l10.items}',
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (subProducts.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            l10.noProductsYet,
                            style: const TextStyle(color: Colors.grey),
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
                                      imageUrl: p.imageUrl ?? '',
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
                                    p.imageUrl ?? '',
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
                                      '${p.price} ${l10.jod}',
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
