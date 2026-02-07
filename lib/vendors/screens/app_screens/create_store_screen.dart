import 'dart:io';

import 'package:caterfy/vendors/screens/create_store_carousel/store_brand_page.dart';
import 'package:caterfy/vendors/screens/create_store_carousel/store_info_page.dart';
import 'package:caterfy/vendors/screens/create_store_carousel/store_location_page.dart';
import 'package:caterfy/vendors/screens/create_store_carousel/store_tags_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:caterfy/shared_widgets.dart/outlined_button.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:caterfy/vendors/vendor_sections/vendor_store.dart';
import 'package:caterfy/models/store.dart';

class CreateStoreCarousel extends StatefulWidget {
  const CreateStoreCarousel({super.key});

  @override
  State<CreateStoreCarousel> createState() => _CreateStoreCarouselState();
}

class _CreateStoreCarouselState extends State<CreateStoreCarousel> {
  final PageController _controller = PageController();
  int currentPage = 0;

  /// ===== LOCAL STATE =====
  File? logoFile;
  File? bannerFile;
  late Store storeDraft;
  late String storeType;

  @override
  void initState() {
    super.initState();
    _initializeStoreType();
  }

  void _initializeStoreType() {
    try {
      final supabase = Supabase.instance.client;
      final userMetadata = supabase.auth.currentUser?.userMetadata;
      storeType = (userMetadata?['store_type'] as String?) ?? 'regular';
    } catch (e) {
      storeType = 'regular';
    }

    storeDraft = Store(
      id: '',
      vendorId: '',
      name: '',
      name_ar: '',
      category: '',
      storeArea: null,
      latitude: 0,
      longitude: 0,
      tags: [],
    );
  }

  bool get isStoreInfoValid =>
      storeDraft.name.isNotEmpty &&
      storeDraft.name_ar.isNotEmpty &&
      storeDraft.category.isNotEmpty;

  Widget buildDots(Color active, Color inactive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == i ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentPage == i ? active : inactive,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final provider = context.watch<LoggedVendorProvider>();
    final l10 = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        centerTitle: true,
        title: const SizedBox.shrink(),
      ),
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (i) => setState(() => currentPage = i),
        children: [
          /// ===== BRAND =====
          StoreBrandBannerPage(
            onLogoSelected: (file) => logoFile = file,
            onBannerSelected: (file) => bannerFile = file,
          ),

          /// ===== INFO =====
          StoreInfoPage(
            showErrors: currentPage == 1 && !isStoreInfoValid,
            onChanged: (name, nameAr, category) {
              storeDraft = Store(
                id: storeDraft.id,
                vendorId: storeDraft.vendorId,
                name: name,
                name_ar: nameAr,
                category: category,
                storeArea: storeDraft.storeArea,
                latitude: storeDraft.latitude,
                longitude: storeDraft.longitude,
                tags: storeDraft.tags,
              );
            },
          ),

          /// ===== TAGS =====
          StoreTagsPage(
            selectedTags: storeDraft.tags ?? [],
            onTagsChanged: (tags) {
              storeDraft = Store(
                id: storeDraft.id,
                vendorId: storeDraft.vendorId,
                name: storeDraft.name,
                name_ar: storeDraft.name_ar,
                category: storeDraft.category,
                storeArea: storeDraft.storeArea,
                latitude: storeDraft.latitude,
                longitude: storeDraft.longitude,
                tags: tags,
              );
            },
          ),

          /// ===== LOCATION =====
          StoreLocationPage(
            onLocationSelected: (area, lat, lng) {
              storeDraft = Store(
                id: storeDraft.id,
                vendorId: storeDraft.vendorId,
                name: storeDraft.name,
                name_ar: storeDraft.name_ar,
                category: storeDraft.category,
                storeArea: area,
                latitude: lat,
                longitude: lng,
                tags: storeDraft.tags,
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (currentPage > 0)
                  SizedBox(
                    width: 140,
                    child: OutlinedBtn(
                      title: l10.back,
                      onPressed: () {
                        _controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  )
                else
                  const SizedBox(width: 140),
                const Spacer(),
                SizedBox(
                  width: 140,
                  child: FilledBtn(
                    title: currentPage == 3 ? l10.continueBtn : l10.next,
                    isLoading: provider.isLoading,
                    onPressed: () async {
                      if (currentPage == 1 && !isStoreInfoValid) return;

                      if (currentPage == 3) {
                        final success = await provider.createStore(
                          storeData: storeDraft,
                          logoFile: logoFile,
                          bannerFile: bannerFile,
                        );

                        if (success && context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const VendorStoreSection(),
                            ),
                          );
                        }
                        return;
                      }

                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            buildDots(colors.primary, colors.outline),
          ],
        ),
      ),
    );
  }
}
