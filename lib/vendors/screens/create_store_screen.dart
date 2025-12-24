import 'package:caterfy/vendors/screens/create_store_carousel/store_brand_page.dart';
import 'package:caterfy/vendors/screens/create_store_carousel/store_info_page.dart';
import 'package:caterfy/vendors/screens/create_store_carousel/store_location_page.dart';
import 'package:caterfy/vendors/screens/create_store_carousel/store_tags_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:caterfy/shared_widgets.dart/outlined_button.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:caterfy/vendors/vendor_sections/vendor_store.dart';

class CreateStoreCarousel extends StatefulWidget {
  const CreateStoreCarousel({super.key});

  @override
  State<CreateStoreCarousel> createState() => _CreateStoreCarouselState();
}

class _CreateStoreCarouselState extends State<CreateStoreCarousel> {
  final PageController _controller = PageController();
  int currentPage = 0;

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
        children: const [
          StoreBrandBannerPage(),
          StoreInfoPage(),
          StoreTagsPage(),
          StoreLocationPage(),
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
                      title: "Back",
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
                    title: currentPage == 3 ? "Continue" : "Next",
                    isLoading: provider.isLoading,
                    onPressed: () async {
                      if (currentPage == 1) {
                        provider.showStoreInfoErrors = true;
                        provider.notifyListeners();

                        if (!provider.isStoreInfoValid) return;
                      }

                      if (currentPage == 3) {
                        final success = await provider.createStore();

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
