import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/product.dart';
import 'package:caterfy/shared_widgets.dart/outlined_button.dart';
import 'package:caterfy/util/wavy_clipper.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Vstore extends StatefulWidget {
  const Vstore({super.key});

  @override
  State<Vstore> createState() => _VstoreState();
}

class _VstoreState extends State<Vstore> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoggedVendorProvider>().checkVendorStore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final vendorProvider = Provider.of<LoggedVendorProvider>(context);
    final store = vendorProvider.store;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhysicalShape(
              clipper: WavyClipper(waveHeight: 6),
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              child: Image.network(
                store?.bannerUrl ?? '',
                height: 218,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image);
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 14,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    child: Image.network(
                      width: 65,
                      height: 65,
                      store?.logoUrl ?? "",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.store,
                          size: 30,
                          color: Colors.grey[400],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          store?.name ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (store?.tags != null && store!.tags!.isNotEmpty)
                          Text(
                            store.tags!.join(', '),
                            maxLines: 1,
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 12.5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        Text(
                          store?.storeArea ?? l10.storeLocation,
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 12.5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedBtn(
                    onPressed: () {},
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
            SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   l10.menu,
                //   style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                // ),
                Column(
                  children: vendorProvider.subCategories.asMap().entries.map((
                    entry,
                  ) {
                    final cat = entry.value;
                    final length = vendorProvider.subCategories.length;
                    final index = entry.key;

                    final subProducts = vendorProvider.products
                        .where((p) => p.subCategoryId == cat['id'])
                        .toList();

                    return MenuCategory(
                      isFirstCategory: index == 0,
                      isLastCategory: index == length - 1,
                      products: subProducts,
                      cat: cat,
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCategory extends StatelessWidget {
  const MenuCategory({
    super.key,
    this.isFirstCategory = false,
    this.isLastCategory = false,
    this.cat = const {},
    this.products = const [],
  });

  final bool isFirstCategory;
  final bool isLastCategory;
  final List<Product> products;
  final Map<String, dynamic> cat;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    String catLabel(Map<String, dynamic> cat) {
      return Localizations.localeOf(context).languageCode == 'ar' &&
              (cat['name_ar']?.isNotEmpty ?? false)
          ? cat['name_ar'] ?? ''
          : cat['name'] ?? '';
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: isFirstCategory ? 18 : 28.0,
            // left: 21,
            // right: 21,
            bottom: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 21),
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
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 21, right: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            catLabel(cat),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "4 items",
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.secondary,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 80),
                    IconButton(
                      onPressed: () => {},
                      icon: Icon(Icons.add, color: colors.secondary, size: 23),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              Column(
                children: products.asMap().entries.map((entry) {
                  final index = entry.key;
                  final p = entry.value;

                  return StoreProductItem(
                    product: p,
                    isLastItem: index == products.length - 1,
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
            decoration: BoxDecoration(
              color: colors.onPrimaryFixedVariant.withOpacity(0.4),
            ),
          ),
      ],
    );
  }
}

class StoreProductItem extends StatelessWidget {
  const StoreProductItem({
    super.key,
    this.isLastItem = false,
    required this.product,
  });

  final bool isLastItem;
  final Product product;

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
        onTap: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(9),
              child: Image.network(
                product.imageUrl ?? "",
                fit: BoxFit.cover,
                width: 55,
                height: 55,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image);
                },
              ),
            ),
            SizedBox(width: 20),
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
                        SizedBox(height: 5),
                        // Text(
                        //   '${l10.jod} ${product.price}',
                        //   style: TextStyle(color: colors.onSurfaceVariant),
                        // ),
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
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  // color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: colors.secondary,
                      size: 15,
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
