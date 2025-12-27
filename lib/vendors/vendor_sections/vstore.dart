import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/product.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/outlined_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:caterfy/util/wavy_clipper.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:caterfy/vendors/screens/app_screens/add_product_screen.dart';
import 'package:caterfy/vendors/screens/app_screens/create_store_screen.dart';
import 'package:caterfy/vendors/screens/app_screens/edit_category_screen.dart';
import 'package:caterfy/vendors/screens/app_screens/edit_product_screen.dart';
import 'package:caterfy/vendors/screens/app_screens/edit_store.screen.dart';
import 'package:caterfy/shared_widgets.dart/three_bounce.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Vstore extends StatefulWidget {
  const Vstore({super.key});

  @override
  State<Vstore> createState() => _VstoreState();
}

class _VstoreState extends State<Vstore> {
  String newCategoryNameEn = '';
  String newCategoryNameAr = '';
  String? categoryNameEnError;
  String? categoryNameArError;
  void clearErrors() {
    categoryNameEnError = null;
    categoryNameArError = null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoggedVendorProvider>().checkVendorStore();
    });
  }

  void _openAddCategoryDrawer(
    BuildContext context,
    LoggedVendorProvider provider,
  ) {
    final l10 = AppLocalizations.of(context);
    bool isSaving = false;

    openDrawer(
      context,
      title: l10.addCategory,
      accountForKeyboard: true,
      padding: const EdgeInsets.only(left: 21, right: 21, top: 20, bottom: 10),
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabeledTextField(
                label: l10.categoryNameEnglish,
                value: newCategoryNameEn,
                errorText: categoryNameEnError,
                onChanged: (val) {
                  setModalState(() {
                    clearErrors();
                    newCategoryNameEn = val.trim();
                    categoryNameEnError = null;
                  });
                },
              ),

              const SizedBox(height: 8),
              LabeledTextField(
                label: l10.categoryNameArabic,
                value: newCategoryNameAr,
                errorText: categoryNameArError,
                onChanged: (val) {
                  setModalState(() {
                    newCategoryNameAr = val.trim();
                    categoryNameArError = null;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// ===== ACTION BUTTONS =====
              Row(
                children: [
                  Expanded(
                    child: OutlinedBtn(
                      title: l10.cancel,
                      onPressed: () {
                        newCategoryNameEn = '';
                        newCategoryNameAr = '';
                        Navigator.pop(context);
                        clearErrors();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledBtn(
                      title: l10.save,
                      isLoading: isSaving,
                      onPressed: isSaving
                          ? () {}
                          : () async {
                              final categories = provider.subCategories;

                              bool hasError = false;

                              // ===== EMPTY CHECK =====
                              setModalState(() {
                                categoryNameEnError = newCategoryNameEn.isEmpty
                                    ? l10.required
                                    : null;

                                categoryNameArError = newCategoryNameAr.isEmpty
                                    ? l10.required
                                    : null;

                                hasError =
                                    categoryNameEnError != null ||
                                    categoryNameArError != null;
                              });

                              if (hasError) return;

                              // ===== DUPLICATE CHECK =====
                              bool enExists = false;
                              bool arExists = false;

                              for (final c in categories) {
                                final en = (c['name'] ?? '')
                                    .toString()
                                    .toLowerCase()
                                    .trim();
                                final ar = (c['name_ar'] ?? '')
                                    .toString()
                                    .toLowerCase()
                                    .trim();

                                if (en ==
                                    newCategoryNameEn.toLowerCase().trim()) {
                                  enExists = true;
                                }

                                if (ar ==
                                    newCategoryNameAr.toLowerCase().trim()) {
                                  arExists = true;
                                }
                              }

                              if (enExists || arExists) {
                                setModalState(() {
                                  categoryNameEnError = enExists
                                      ? l10.categoryAlreadyExists
                                      : null;

                                  categoryNameArError = arExists
                                      ? l10.categoryAlreadyExists
                                      : null;
                                });
                                return;
                              }

                              // ===== SAVE =====
                              setModalState(() => isSaving = true);

                              await provider.addCategory(
                                name: newCategoryNameEn,
                                nameAr: newCategoryNameAr,
                              );

                              newCategoryNameEn = '';
                              newCategoryNameAr = '';
                              clearErrors();

                              Navigator.pop(context);
                            },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
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
          ? cat['name_ar']
          : cat['name'];
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhysicalShape(
            clipper: WavyClipper(waveHeight: 6),
            clipBehavior: Clip.antiAlias,
            color: Colors.transparent,
            child: Image.network(
              store.bannerUrl ?? '',
              height: 218,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),

          const SizedBox(height: 20),

          /// ===== STORE HEADER =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    store.logoUrl ?? '',
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.store, color: Colors.grey[400]),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        storeNameToShow,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (store.tags != null && store.tags!.isNotEmpty)
                        Text(
                          store.tags!.join(', '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 12.5,
                          ),
                        ),
                      Text(
                        store.storeArea ?? l10.storeLocation,
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedBtn(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditStoreScreen(),
                      ),
                    );
                  },
                  title: l10.edit,
                  innerHorizontalPadding: 20,
                  innerVerticalPadding: 10,
                  titleSize: 15,
                  lighterBorder: true,
                  borderRadius: 13,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              _openAddCategoryDrawer(context, provider);
            },
            child: Icon(Icons.add_circle_outline),
          ),

          /// ===== CATEGORIES =====
          Column(
            children: provider.subCategories.asMap().entries.map((entry) {
              final cat = entry.value;
              final index = entry.key;

              final products = provider.products
                  .where((p) => p.subCategoryId == cat['id'])
                  .toList();

              return MenuCategory(
                cat: cat,
                products: products,
                isFirstCategory: index == 0,
                isLastCategory: index == provider.subCategories.length - 1,
                onAddPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddProductScreen(
                        categoryId: cat['id'],
                        categoryName: catLabel(cat),
                      ),
                    ),
                  ).then((_) {
                    setState(() {});
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class MenuCategory extends StatelessWidget {
  const MenuCategory({
    super.key,
    required this.cat,
    required this.products,
    required this.onAddPressed,
    this.isFirstCategory = false,
    this.isLastCategory = false,
  });

  final Map<String, dynamic> cat;
  final List<Product> products;
  final VoidCallback onAddPressed;
  final bool isFirstCategory;
  final bool isLastCategory;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    String catLabel() {
      return Localizations.localeOf(context).languageCode == 'ar' &&
              (cat['name_ar']?.isNotEmpty ?? false)
          ? cat['name_ar']
          : cat['name'];
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: isFirstCategory ? 18 : 28, bottom: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// CATEGORY TAG
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 21),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  l10.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// CATEGORY HEADER
              Padding(
                padding: const EdgeInsets.only(left: 21, right: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  catLabel(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 4,
                                    top: 4,
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    size: 12,
                                    color: colors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            '${products.length} ${l10.items}',
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: Icon(Icons.add, color: colors.secondary),
                      onPressed: onAddPressed,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              /// PRODUCTS
              Column(
                children: products.asMap().entries.map((e) {
                  return StoreProductItem(
                    product: e.value,
                    isLastItem: e.key == products.length - 1,
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        if (!isLastCategory)
          Container(
            width: double.infinity,
            height: 13,
            color: colors.onPrimaryFixedVariant.withOpacity(0.4),
          ),
      ],
    );
  }
}

class StoreProductItem extends StatelessWidget {
  const StoreProductItem({
    super.key,
    required this.product,
    this.isLastItem = false,
  });

  final Product product;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: isLastItem ? 0 : 12,
        right: 21,
        left: 21,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditProductScreen(
                productId: product.id,
                name: product.name,
                description: product.description,
                price: product.price,
                imageUrl: product.imageUrl ?? '',
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                product.imageUrl ?? '',
                width: 55,
                height: 55,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isLastItem ? Colors.transparent : colors.outline,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name),
                        const SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            text: '${l10.jod} ',
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: product.price.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: colors.secondary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
