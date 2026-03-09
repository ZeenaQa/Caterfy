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
        'https://static.vecteezy.com/system/resources/thumbnails/057/068/323/small/single-fresh-red-strawberry-on-table-green-background-food-fruit-sweet-macro-juicy-plant-image-photo.jpg',
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
