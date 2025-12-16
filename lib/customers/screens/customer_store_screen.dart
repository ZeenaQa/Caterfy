import 'package:caterfy/customers/customer_widgets/delivered_by_info.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/customer_store_details_screen.dart';
import 'package:caterfy/customers/screens/customer_store_menu_layout.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:caterfy/shared_widgets.dart/favorite_toast.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/outlined_icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key, required this.store});

  final Store store;

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late ScrollController _scrollController;
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      final offset = _scrollController.offset;

      final newOpacity = ((offset - 50) / 70).clamp(0.0, 1.0);

      if (newOpacity != _appBarOpacity) {
        setState(() {
          _appBarOpacity = newOpacity;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerId = Supabase.instance.client.auth.currentUser?.id;
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: customerProvider.productsNum > 0 ? 100 : 20,
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image.network(
                        widget.store.bannerUrl!,
                        height: 218,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image);
                        },
                      ),
                      SafeArea(
                        bottom: false,
                        child: Column(
                          spacing: 33,
                          children: [
                            const SizedBox(height: 60),

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 11,
                                    children: [
                                      Container(
                                        width: 65,
                                        height: 65,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF1F1F1),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            widget.store.logoUrl!,
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
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CustomerStoreDetailsScreen(
                                                        store: widget.store,
                                                      ),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      widget.store.name,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 16.5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    color:
                                                        colors.onSurfaceVariant,
                                                    size: 17,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (widget.store.tags != null &&
                                                widget.store.tags!.isNotEmpty)
                                              Text(
                                                widget.store.tags!.join(', '),
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color:
                                                      colors.onSurfaceVariant,
                                                  fontSize: 12.5,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.solidStar,
                                                  size: 13,
                                                  color:
                                                      colors.secondaryContainer,
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
                                                    color:
                                                        colors.onSurfaceVariant,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                                baselineType:
                                                    TextBaseline.alphabetic,
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
                                                baselineType:
                                                    TextBaseline.alphabetic,
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
                                              padding: EdgeInsets.only(
                                                bottom: 20,
                                              ),
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12.5,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: "Caterfy",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
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
                  StoreMenuLayout(store: widget.store),
                ],
              ),
            ),
          ),

          if (customerProvider.productsNum > 0)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: 35,
                  top: 10,
                  right: 10,
                  left: 10,
                ),
                height: 100,

                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border(top: BorderSide(color: colors.outline)),
                ),
                width: double.infinity,
                child: FilledBtn(
                  onPressed: () {},
                  content: Row(
                    children: [
                      Text(
                        customerProvider.productsNum.toString(),
                        style: TextStyle(
                          color: colors.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(width: 13),
                      Text(
                        "View cart",
                        style: TextStyle(
                          color: colors.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Spacer(),
                      Text(
                        '${l10.jod} ${customerProvider.totalPrice.toString()}',
                        style: TextStyle(
                          color: colors.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),

              decoration: BoxDecoration(
                color: colors.onInverseSurface.withOpacity(_appBarOpacity),
                border: Border(
                  bottom: BorderSide(
                    color: colors.outline.withOpacity(_appBarOpacity),
                  ),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    OutlinedIconBtn(
                      child: BackButton(),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        widget.store.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: colors.onPrimaryFixed.withOpacity(
                            _appBarOpacity,
                          ),
                        ),
                      ),
                    ),
                    OutlinedIconBtn(
                      onPressed: () {
                        if (customerId != null) {
                          final isFav = customerProvider.isFavorite(
                            widget.store.id,
                          );
                          showFavoriteToast(
                            context: context,
                            isFavorite: !isFav,
                            category: widget.store.category,
                          );
                          customerProvider.toggleFavorite(
                            customerId,
                            widget.store,
                          );
                        }
                      },
                      child: Icon(
                        !customerProvider.isFavorite(widget.store.id)
                            ? FontAwesomeIcons.heart
                            : FontAwesomeIcons.solidHeart,
                        size: 16,
                        color: !customerProvider.isFavorite(widget.store.id)
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
            ),
          ),
        ],
      ),
    );
  }
}
