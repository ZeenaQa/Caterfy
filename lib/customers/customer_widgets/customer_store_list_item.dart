import 'package:caterfy/customers/screens/customer_store_screen.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/shared_widgets.dart/favorite_toast.dart';
import 'package:caterfy/shared_widgets.dart/overlap_heart_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerStoreListItem extends StatelessWidget {
  const CustomerStoreListItem({
    super.key,
    required this.store,
    this.dummyImage = false,
  });

  final Store store;
  final bool dummyImage;

  @override
  Widget build(BuildContext context) {
    final customerId = Supabase.instance.client.auth.currentUser?.id;
    final colors = Theme.of(context).colorScheme;
    final hasLogo = (store.logoUrl ?? '').isNotEmpty;
    final hasBanner = (store.bannerUrl ?? '').isNotEmpty;
    final storeNameToShow = Localizations.localeOf(context).languageCode == 'ar' && (store.name_ar.isNotEmpty) ? store.name_ar : store.name;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CustomerStoreScreen(store: store)),
        );
      },
      child: SizedBox(
        height: 90,
        width: double.infinity,
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 113,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: dummyImage
                        ? Image.asset(
                            'assets/images/app_icon.png',
                            fit: BoxFit.cover,
                          )
                        : (hasBanner || hasLogo)
                        ? Image.network(
                            hasBanner ? store.bannerUrl! : store.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.store,
                                size: 50,
                                color: Colors.grey[400],
                              );
                            },
                          )
                        : Icon(Icons.store, size: 50, color: Colors.grey[400]),
                  ),
                ),
                SizedBox(
                  width: 113,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!dummyImage)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 6,
                          ),
                          child: (hasBanner && hasLogo)
                              ? Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF1F1F1),
                                    border: Border.all(
                                      color: Color(0xffe4e4e4),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      store.logoUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              Icons.store,
                                              size: 30,
                                              color: Colors.grey[400],
                                            );
                                          },
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      Spacer(),

                      Consumer<LoggedCustomerProvider>(
                        builder: (context, customerProvider, child) {
                          final isFav = customerProvider.isFavorite(store.id);
                          return Skeleton.ignore(
                            child: OverlapHeartButton(
                              isFavorite: isFav,
                              onTap: () {
                                if (customerId != null) {
                                  showFavoriteToast(
                                    context: context,
                                    isFavorite: !isFav,
                                    category: store.category,
                                  );
                                  customerProvider.toggleFavorite(
                                    customerId,
                                    store,
                                  );
                                }
                              },
                              size: 23,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.solidCircleCheck,
                        size: 13,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          storeNameToShow,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  if (store.storeArea != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.locationDot,
                          size: 13,
                          color: colors.onSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            store.storeArea ?? '',
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 2),
                  Flexible(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.solidStar,
                          size: 13,
                          color: colors.secondaryContainer,
                        ),
                        SizedBox(width: 6),
                        Text('5.3 (1k+) ', style: TextStyle(fontSize: 12)),
                        Text(
                          '• 15-20 mins • JOD 1.0',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
