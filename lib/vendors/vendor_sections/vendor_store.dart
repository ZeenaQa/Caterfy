import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:caterfy/vendors/screens/create_store_screen.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/three_bounce.dart';

class VendorStoreSection extends StatefulWidget {
  const VendorStoreSection({super.key});

  @override
  State<VendorStoreSection> createState() => _VendorStoreSectionState();
}

class _VendorStoreSectionState extends State<VendorStoreSection> {
  bool _isInit = true;
  final List<TextEditingController> _controllers = [];
  final List<TextEditingController> _dbControllers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final provider = context.read<LoggedVendorProvider>();
      provider.checkVendorStore().then((_) {
        _initDbControllers(provider);
      });
      _isInit = false;
    }
  }

  void _initDbControllers(LoggedVendorProvider provider) {
    _dbControllers.clear();
    for (var cat in provider.subCategories) {
      _dbControllers.add(TextEditingController(text: cat['name']));
    }
    setState(() {});
  }

  void _addCategoryField() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  Future<void> _saveCategory(
      BuildContext context, TextEditingController controller) async {
    final provider = context.read<LoggedVendorProvider>();
    final name = controller.text.trim();
    if (name.isEmpty) return;
    await provider.addCategory(name);
    _initDbControllers(provider);
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
            Icon(Icons.store_mall_directory,
                size: 80, color: colors.onSurfaceVariant),
            const SizedBox(height: 16),
            const Text('Get Started',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('You don’t have a store yet. Let’s create one!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: colors.onSurface)),
            const SizedBox(height: 24),
            FilledBtn(
              title: 'Create Store',
              stretch: false,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CreateStoreCarousel()),
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
          const SizedBox(height: 16),
          if (store.logoUrl != null)
            CircleAvatar(radius: 50, backgroundImage: NetworkImage(store.logoUrl!)),
          const SizedBox(height: 16),
          Text(store.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ..._dbControllers.map((controller) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                ..._controllers.map((controller) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                hintText: 'Enter category name',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (_) =>
                                  _saveCategory(context, controller),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () => _saveCategory(context, controller),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                TextButton.icon(
                  onPressed: _addCategoryField,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Category"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}