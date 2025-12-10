
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:caterfy/vendors/screens/create_store_screen.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';

class VendorStoreSection extends StatefulWidget {
  const VendorStoreSection({super.key});

  @override
  State<VendorStoreSection> createState() => _VendorStoreSectionState();
}

class _VendorStoreSectionState extends State<VendorStoreSection> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final provider = context.read<LoggedVendorProvider>();
      provider.checkVendorStore();
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendorProvider = context.watch<LoggedVendorProvider>();
    final colors = Theme.of(context).colorScheme;

    if (vendorProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!vendorProvider.hasStore) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store_mall_directory, size: 80, color: colors.onSurfaceVariant),
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
            const SizedBox(height: 24),
            FilledBtn(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateStoreCarousel()),
                );
              },
              stretch: false,
              title: 'Create Store',
            ),
          ],
        ),
      );
    }


    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (vendorProvider.bannerUrl != null)
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(vendorProvider.bannerUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 16),
          if (vendorProvider.logoUrl != null)
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(vendorProvider.logoUrl!),
            ),
          const SizedBox(height: 16),
          if (vendorProvider.storeNameEn != null || vendorProvider.storeNameAr != null)
            Column(
              children: [
                if (vendorProvider.storeNameEn != null)
                  Text(
                    vendorProvider.storeNameEn!,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
              
              ],
            ),
          const SizedBox(height: 24),
          FilledBtn(
            title: 'Edit Store',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateStoreCarousel()),
              );
            },
          ),
        ],
      ),
    );
  }
}
