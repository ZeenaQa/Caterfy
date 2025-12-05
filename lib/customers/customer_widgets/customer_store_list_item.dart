import 'package:caterfy/customers/screens/store_screen.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/shared_widgets.dart/overlap_heart_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => StoreScreen(store: store)),
      ),
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
                    image: hasBanner || hasLogo
                        ? DecorationImage(
                            image: dummyImage
                                ? AssetImage('assets/images/app_icon.png')
                                : NetworkImage(
                                    hasBanner
                                        ? store.bannerUrl!
                                        : store.logoUrl!,
                                  ),
                            fit: BoxFit.cover,
                          )
                        : null,
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
                                    color: Color.fromARGB(255, 219, 219, 219),
                                    border: Border.all(
                                      color: Color(0xffe4e4e4),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(store.logoUrl!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      Spacer(),

                      // OverlapHeartButton(size: 15),
                      Consumer<LoggedCustomerProvider>(
                        builder: (context, customerProvider, child) {
                          return OverlapHeartButton(
                            isFavorite: customerProvider.isFavorite(store.id),
                            onTap: () {
                              print('Tapped!');
                              print('customerId: $customerId');
                              if (customerId != null) {
                                customerProvider.toggleFavorite(
                                  customerId,
                                  store.id,
                                );
                              }
                            },
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
                          store.name,
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
