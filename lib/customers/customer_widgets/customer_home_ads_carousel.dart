import 'package:carousel_slider/carousel_slider.dart';
import 'package:caterfy/shared_widgets.dart/custom_spinner.dart';
import 'package:flutter/material.dart';

class AdBanner {
  final String imageUrl;
  final String restaurantId;

  const AdBanner({required this.imageUrl, required this.restaurantId});
}

final List<AdBanner> banners = [
  AdBanner(
    imageUrl:
        'https://www.bellanaija.com/wp-content/uploads/2023/02/Squad-Flame-Web-Banner-scaled.jpg',
    restaurantId: 's',
  ),
  AdBanner(
    imageUrl:
        'https://leaders.jo/wp-content/uploads/2026/01/Tablets-Ar-27th-Jan.jpg',
    restaurantId: 'b',
  ),
  AdBanner(
    imageUrl:
        'https://scontent.famm10-1.fna.fbcdn.net/v/t39.30808-6/456962687_909906431180353_176107052498410797_n.png?_nc_cat=110&ccb=1-7&_nc_sid=cc71e4&_nc_ohc=a7rF4d_wkZ8Q7kNvwE--sbh&_nc_oc=AdngXIytscvb_6CG-sVTv4kFiE2h86IFIekYfM_LatyWvVW6Hhvt8J1mssehPhCCerARoDSZnPr62jXEpnzRgpYz&_nc_zt=23&_nc_ht=scontent.famm10-1.fna&_nc_gid=BadW9B88QvE7_tcG9pKm4Q&oh=00_Afuz3DZsuiy5NCEUf-3S6-I7qyNFP0U_cXTWfNgIvhvNZg&oe=698EBC39',
    restaurantId: '3',
  ),
];

class HomeAdsCarousel extends StatefulWidget {
  final double height;
  final Duration autoPlayInterval;

  const HomeAdsCarousel({
    super.key,
    this.height = 160,
    this.autoPlayInterval = const Duration(seconds: 3),
  });

  @override
  State<HomeAdsCarousel> createState() => _HomeAdsCarouselState();
}

class _HomeAdsCarouselState extends State<HomeAdsCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: widget.height,
            autoPlay: banners.length > 1,
            autoPlayInterval: widget.autoPlayInterval,
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            enableInfiniteScroll: banners.length > 1,
            pauseAutoPlayOnTouch: true,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          items: banners.map((banner) {
            return GestureDetector(
              onTap: () => {},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  banner.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: colors.outline,
                      child: const Center(
                        child: CustomThreeLineSpinner(),
                      ),
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 8),

        // 🔘 Wide pill indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (index) {
            final isActive = index == _currentIndex;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 2),
              width: 27,
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? colors.onPrimaryFixed.withOpacity(0.7)
                    : colors.onPrimaryFixed.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
            );
          }),
        ),
      ],
    );
  }
}
