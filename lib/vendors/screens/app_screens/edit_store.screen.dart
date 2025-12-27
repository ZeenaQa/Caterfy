import 'dart:io';
import 'package:caterfy/shared_widgets.dart/outlined_button.dart';
import 'package:caterfy/vendors/screens/app_screens/edit_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:caterfy/l10n/app_localizations.dart';

class EditStoreScreen extends StatefulWidget {
  const EditStoreScreen({super.key});

  @override
  State<EditStoreScreen> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  bool showTagsSelector = false;

  final List<String> availableTags = const [
    "Pizza",
    "Burger",
    "Desserts",
    "Drinks",
    "Coffee",
    "Bakery",
    "Fast Food",
    "Healthy Food",
    "Grocery",
    "Supermarket",
    "Mini Market",
    "Fruits & Vegetables",
    "Butcher",
    "Dairy",
    "Cleaning",
    "Laundry",
    "Maintenance",
    "Delivery",
    "Car Wash",
    "Printing",
    "Computers",
    "Mobile Phones",
    "Electronics",
    "Accessories",
    "Repair",
    "Clothes",
    "Shoes",
    "Gifts",
    "Flowers",
    "Pharmacy",
    "Beauty",
  ];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<LoggedVendorProvider>(context, listen: false);

    provider.storeForm = provider.store;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoggedVendorProvider>();
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final store = provider.storeForm;

    if (store == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10.editStore)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10.banner,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(),

                /// ===== FILE NAME =====
                if (provider.bannerFile != null)
                  SizedBox(
                    width: 120,
                    child: Text(
                      provider.bannerFile!.path.split('/').last,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),

                const SizedBox(width: 8),

                OutlinedBtn(
                  onPressed: () async {
                    final picked = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked != null) {
                      provider.setBannerFile(File(picked.path));
                    }
                  },
                  title: l10.change,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Text(
                  l10.logo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(),

                /// ===== FILE NAME  =====
                if (provider.logoFile != null)
                  SizedBox(
                    width: 120,
                    child: Text(
                      provider.logoFile!.path.split('/').last,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),

                const SizedBox(width: 8),

                OutlinedBtn(
                  onPressed: () async {
                    final picked = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked != null) {
                      provider.setLogoFile(File(picked.path));
                    }
                  },
                  title: l10.change,
                ),
              ],
            ),

            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ===== CURRENT AREA =====
                Row(
                  children: [
                    Text(l10.location, style: const TextStyle(fontSize: 16)),
                    const Spacer(),
                    Text(
                      store.storeArea?.isNotEmpty == true
                          ? store.storeArea!
                          : l10.unknownArea,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const Spacer(),
                    OutlinedBtn(
                      title: l10.change,
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditStoreLocationScreen(),
                          ),
                        );

                        setState(() {});
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 12),
              ],
            ),
            const SizedBox(height: 24),

            // Store name (Arabic)
            LabeledTextField(
              label: l10.storeNameArabic,
              value: store.name_ar,
              onChanged: (val) {
                provider.updateStoreForm(nameAr: val.trim());
              },
            ),

            const SizedBox(height: 16),

            // Store name (English)
            LabeledTextField(
              label: l10.storeName,
              value: store.name,
              onChanged: (val) {
                provider.updateStoreForm(name: val.trim());
              },
            ),

            const SizedBox(height: 24),

            //////////////////////////////////////////
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.local_offer_outlined, color: colors.primary),
              title: Text(l10.storeTags),
              trailing: Icon(
                showTagsSelector
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: colors.onSurfaceVariant,
              ),
              onTap: () {
                setState(() {
                  showTagsSelector = !showTagsSelector;
                });
              },
            ),

            if (showTagsSelector) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableTags.map((tag) {
                  final selected = (store.tags ?? []).contains(tag);

                  return FilterChip(
                    label: Text(tag),
                    selected: selected,
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    selectedColor: colors.primaryContainer,
                    backgroundColor: colors.surface,
                    labelStyle: TextStyle(
                      color: selected
                          ? colors.onPrimaryContainer
                          : colors.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: selected ? colors.primary : colors.outline,
                    ),
                    onSelected: (value) {
                      final newTags = List<String>.from(store.tags ?? []);

                      if (value) {
                        newTags.add(tag);
                      } else {
                        newTags.remove(tag);
                      }

                      provider.updateStoreForm(tags: newTags);
                    },
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 32),

            /// ===== LOCATION =====
            FilledBtn(
              title: l10.saveChanges,
              isLoading: provider.isLoading,
              onPressed: provider.isLoading
                  ? () {}
                  : () async {
                      final success = await provider.updateStore();

                      if (success && context.mounted) {
                        Navigator.pop(context);
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}
