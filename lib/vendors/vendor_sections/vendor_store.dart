import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/vendors/screens/add_product_screen.dart';
import 'package:caterfy/vendors/screens/create_store_screen.dart';
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
  int? _expandedIndex;

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
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(store.logoUrl!),
            ),

          const SizedBox(height: 12),

          Text(
            store.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          FilledBtn(
            title: 'Add Category',
            stretch: false,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  final controller = TextEditingController();

                  return AlertDialog(
                    title: const Text('Add Category'),
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Category name',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      FilledBtn(
                        title: 'Add',
                        onPressed: () async {
                          await provider.addCategory(controller.text);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: provider.subCategories.asMap().entries.map((entry) {
                final index = entry.key;
                final cat = entry.value;
                final isExpanded = _expandedIndex == index;

                final subProducts = provider.products
                    .where((p) => p.subCategoryId == cat['id'])
                    .toList();

                return SizedBox(
                  width: double.infinity,
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _expandedIndex = isExpanded ? null : index;
                            });
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  cat['name'] ?? '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down_outlined,
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),

                        if (isExpanded) ...[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddProductScreen(
                                    subCategoryId: cat['id'],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: const [
                                  Icon(Icons.add_box_outlined),
                                  SizedBox(width: 8),
                                  Text(
                                    'Add products',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if (subProducts.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Text(
                                'No products yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),

                          ...subProducts.map(
                            (p) => ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  p.imageUrl,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(p.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.description,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: colors.onSurfaceVariant,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${p.price} JOD',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
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
