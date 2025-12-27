import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:caterfy/models/store.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:caterfy/vendors/screens/app_screens/edit_location_screen.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/outlined_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class EditStoreScreen extends StatefulWidget {
  const EditStoreScreen({super.key});

  @override
  State<EditStoreScreen> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  bool showTagsSelector = false;

  File? logoFile;
  File? bannerFile;
  late Store storeDraft;
  String? nameArError;
  String? nameEnError;

  final List<String> availableTags = [
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
    final provider = context.read<LoggedVendorProvider>();
    storeDraft = provider.store!;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoggedVendorProvider>();
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    final tags = storeDraft.tags ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(l10.editStore)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= BANNER =================
            Row(
              children: [
                Text(l10.banner),
                const Spacer(),
                if (bannerFile != null)
                  SizedBox(
                    width: 120,
                    child: Text(
                      bannerFile!.path.split('/').last,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(width: 8),
                OutlinedBtn(
                  title: l10.change,
                  onPressed: () async {
                    final picked = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked != null) {
                      setState(() => bannerFile = File(picked.path));
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// ================= LOGO =================
            Row(
              children: [
                Text(l10.logo),
                const Spacer(),
                if (logoFile != null)
                  SizedBox(
                    width: 120,
                    child: Text(
                      logoFile!.path.split('/').last,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(width: 8),
                OutlinedBtn(
                  title: l10.change,
                  onPressed: () async {
                    final picked = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked != null) {
                      setState(() => logoFile = File(picked.path));
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// ================= LOCATION =================
            Row(
              children: [
                Text(l10.location),
                const Spacer(),
                Text(
                  storeDraft.storeArea?.isNotEmpty == true
                      ? storeDraft.storeArea!
                      : l10.unknownArea,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 8),
                OutlinedBtn(
                  title: l10.change,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditStoreLocationScreen(
                          store: storeDraft,
                          onLocationSaved: (updatedStore) {
                            setState(() {
                              storeDraft = updatedStore;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// ================= STORE NAME =================
            LabeledTextField(
              label: l10.storeNameArabic,
              value: storeDraft.name_ar,
              errorText: nameArError,
              onChanged: (val) {
                setState(() {
                  nameArError = null;
                  storeDraft = Store(
                    id: storeDraft.id,
                    vendorId: storeDraft.vendorId,
                    name: storeDraft.name,
                    name_ar: val.trim(),
                    category: storeDraft.category,
                    storeArea: storeDraft.storeArea,
                    latitude: storeDraft.latitude,
                    longitude: storeDraft.longitude,
                    tags: storeDraft.tags,
                  );
                });
              },
            ),

            const SizedBox(height: 16),

            LabeledTextField(
              label: l10.storeName,
              value: storeDraft.name,
              errorText: nameEnError,
              onChanged: (val) {
                setState(() {
                  nameEnError = null;
                  storeDraft = Store(
                    id: storeDraft.id,
                    vendorId: storeDraft.vendorId,
                    name: val.trim(),
                    name_ar: storeDraft.name_ar,
                    category: storeDraft.category,
                    storeArea: storeDraft.storeArea,
                    latitude: storeDraft.latitude,
                    longitude: storeDraft.longitude,
                    tags: storeDraft.tags,
                  );
                });
              },
            ),

            const SizedBox(height: 24),

            /// ================= TAGS =================
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.local_offer_outlined, color: colors.primary),
              title: Text(l10.storeTags),
              trailing: Icon(
                showTagsSelector
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              onTap: () {
                setState(() {
                  showTagsSelector = !showTagsSelector;
                });
              },
            ),

            if (showTagsSelector)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableTags.map((tag) {
                  final selected = tags.contains(tag);

                  return FilterChip(
                    label: Text(tag),
                    selected: selected,
                    onSelected: (value) {
                      final updatedTags = List<String>.from(tags);
                      value ? updatedTags.add(tag) : updatedTags.remove(tag);

                      setState(() {
                        storeDraft = Store(
                          id: storeDraft.id,
                          vendorId: storeDraft.vendorId,
                          name: storeDraft.name,
                          name_ar: storeDraft.name_ar,
                          category: storeDraft.category,
                          storeArea: storeDraft.storeArea,
                          latitude: storeDraft.latitude,
                          longitude: storeDraft.longitude,
                          tags: updatedTags,
                        );
                      });
                    },
                  );
                }).toList(),
              ),

            const SizedBox(height: 32),

            /// ================= SAVE =================
            FilledBtn(
              title: l10.saveChanges,
              isLoading: provider.isLoading,
              onPressed: () async {
                setState(() {
                  nameArError = storeDraft.name_ar.trim().isEmpty
                      ? l10.required
                      : null;
                  nameEnError = storeDraft.name.trim().isEmpty
                      ? l10.required
                      : null;
                });

                if (nameArError != null || nameEnError != null) return;

                final success = await provider.updateStore(
                  logoFile: logoFile,
                  bannerFile: bannerFile,
                  updatedStore: storeDraft,
                );

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
