import 'package:caterfy/customers/customer_widgets/delivered_by_info.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:caterfy/shared_widgets.dart/favorite_toast.dart';
import 'package:caterfy/shared_widgets.dart/outlined_icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final customerId = Supabase.instance.client.auth.currentUser?.id;
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.network(
                store.bannerUrl!,
                height: 218,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SafeArea(
                child: Column(
                  spacing: 33,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: Row(
                        children: [
                          OutlinedIconBtn(
                            child: BackButton(),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Spacer(),
                          OutlinedIconBtn(
                            onPressed: () {
                              if (customerId != null) {
                                final isFav = customerProvider.isFavorite(
                                  store.id,
                                );
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
                            child: Icon(
                              !customerProvider.isFavorite(store.id)
                                  ? FontAwesomeIcons.heart
                                  : FontAwesomeIcons.solidHeart,
                              size: 16,
                              color: !customerProvider.isFavorite(store.id)
                                  ? colors.onSurface
                                  : const Color(0xFFF7584D),
                            ),
                          ),
                          OutlinedIconBtn(
                            child: Icon(
                              FontAwesomeIcons.magnifyingGlass,
                              size: 15,
                              color: colors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(13),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(17),
                        border: BoxBorder.all(color: colors.outline),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 14,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 11,
                            children: [
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(store.logoUrl!),
                                    fit: BoxFit.cover,
                                  ),
                                  color: Color(0xffe4e4e4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            store.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: colors.onSurfaceVariant,
                                          size: 17,
                                        ),
                                      ],
                                    ),
                                    if (store.tags != null &&
                                        store.tags!.isNotEmpty)
                                      Text(
                                        store.tags!.join(', '),
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: colors.onSurfaceVariant,
                                          fontSize: 12.5,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.solidStar,
                                          size: 13,
                                          color: colors.secondaryContainer,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          '4.3',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          ' (1k+)',
                                          style: TextStyle(
                                            color: colors.onSurfaceVariant,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    spacing: 4,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.clock,
                                        size: 13,
                                        color: colors.onSurface,
                                      ),
                                      Baseline(
                                        baseline: 13,
                                        baselineType: TextBaseline.alphabetic,
                                        child: Text(
                                          "15-20 mins",
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(width: 8),
                                  Text(
                                    "•",
                                    style: TextStyle(
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  Row(
                                    spacing: 4,
                                    children: [
                                      Icon(
                                        Icons.delivery_dining_rounded,
                                        size: 16,
                                        color: colors.onSurface,
                                      ),
                                      Baseline(
                                        baseline: 14,
                                        baselineType: TextBaseline.alphabetic,
                                        child: Text(
                                          '1.00 ${l10.jod}',
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(width: 8),
                                  Text(
                                    "•",
                                    style: TextStyle(
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  GestureDetector(
                                    onTap: () => openDrawer(
                                      context,
                                      child: DeliveredByInfo(),
                                    ),
                                    behavior: HitTestBehavior.opaque,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 4,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: '${l10.deliveredBy} ',
                                            style: TextStyle(
                                              color: colors.onSurface,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.5,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "Caterfy",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: colors.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.info_outline,
                                          size: 16,
                                          color: colors.onSurface,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Text("hi")
        ],
      ),
    );
  }
}
