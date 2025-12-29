import 'package:caterfy/customers/customer_widgets/delivered_by_info.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/customer_cart.dart';
import 'package:caterfy/customers/screens/customer_store_details_screen.dart';
import 'package:caterfy/customers/screens/customer_store_menu_layout.dart';
import 'package:caterfy/dummy_data.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:caterfy/shared_widgets.dart/favorite_toast.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/outlined_icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const ColorFilter blackAndWhite = ColorFilter.matrix(<double>[
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
]);

const ColorFilter noFilter = ColorFilter.mode(
  Colors.transparent,
  BlendMode.dst,
);

class CustomerStoreScreen extends StatefulWidget {
  const CustomerStoreScreen({super.key, required this.store});

  final Store store;

  @override
  State<CustomerStoreScreen> createState() => _CustomerStoreScreenState();
}

class _CustomerStoreScreenState extends State<CustomerStoreScreen> {
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<LoggedCustomerProvider>(
        context,
        listen: false,
      );
      await provider.fetchProducts(storeId: widget.store.id, context: context);
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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isLoading =
        customerProvider.isProductsLoading ||
        customerProvider.isCategoryLoading;

    final bool showCart = customerProvider.cart?.storeId == widget.store.id;

    return Scaffold(
      bottomNavigationBar: (!showCart || isLoading)
          ? null
          : BottomNav(store: widget.store),
      body: Skeletonizer(
        enabled: isLoading,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 0),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Skeleton.replace(
                          replacement: Image.asset(
                            'assets/images/app_icon.png',
                            height: 218,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image);
                            },
                          ),
                          child: ColorFiltered(
                            colorFilter: widget.store.isOpen
                                ? noFilter
                                : blackAndWhite,
                            child: Image.network(
                              widget.store.bannerUrl ?? '',
                              height: 218,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image);
                              },
                            ),
                          ),
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
                                        Stack(
                                          children: [
                                            Container(
                                              width: 65,
                                              height: 65,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF1F1F1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Skeleton.replace(
                                                  replacement: Image.asset(
                                                    'assets/images/app_icon.png',
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return Icon(
                                                            Icons.store,
                                                            size: 30,
                                                            color: Colors
                                                                .grey[400],
                                                          );
                                                        },
                                                  ),
                                                  child: Image.network(
                                                    widget.store.logoUrl ?? "",
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) {
                                                          return Icon(
                                                            Icons.store,
                                                            size: 30,
                                                            color: Colors
                                                                .grey[400],
                                                          );
                                                        },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (!widget.store.isOpen)
                                              Skeleton.ignore(
                                                child: Container(
                                                  width: 65,
                                                  height: 65,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    color: Colors.black
                                                        .withOpacity(0.6),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      l10.closed,
                                                      style: TextStyle(
                                                        color: colors.onPrimary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                behavior:
                                                    HitTestBehavior.opaque,
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
                                                        isArabic
                                                            ? widget
                                                                  .store
                                                                  .name_ar
                                                            : widget.store.name,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                                      color: colors
                                                          .onSurfaceVariant,
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
                                                    color: colors
                                                        .secondaryContainer,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    '5',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    ' (1k+)',
                                                    style: TextStyle(
                                                      color: colors
                                                          .onSurfaceVariant,
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
                                                    "15-20 ${l10.min}",
                                                    style: TextStyle(
                                                      fontSize: 12.5,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                              onTap: () {
                                                print(
                                                  customerProvider
                                                      .cart
                                                      ?.storeId,
                                                );
                                                openDrawer(
                                                  context,
                                                  padding: EdgeInsets.only(
                                                    bottom: 20,
                                                  ),
                                                  child: DeliveredByInfo(),
                                                );
                                              },
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
                                                      text:
                                                          '${l10.deliveredBy} ',
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
                                                            color:
                                                                colors.primary,
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
                    StoreMenuLayout(
                      store: widget.store,
                      products: isLoading
                          ? dummyProducts
                          : customerProvider.products,
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Skeleton.keep(
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
                            isArabic ? widget.store.name_ar : widget.store.name,
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
                        Skeleton.ignore(
                          child: OutlinedIconBtn(
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
                              color:
                                  !customerProvider.isFavorite(widget.store.id)
                                  ? colors.onSurface
                                  : const Color(0xFFF7584D),
                            ),
                          ),
                        ),
                        Skeleton.ignore(
                          child: OutlinedIconBtn(
                            child: Icon(
                              FontAwesomeIcons.magnifyingGlass,
                              size: 15,
                              color: colors.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final bool isStoreOpen = store.isOpen;

    return Skeleton.ignore(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          color: colors.surface,
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 3.5),
            ),
          ],
        ),
        width: double.infinity,
        child: SafeArea(
          top: false,
          child: FilledBtn(
            onPressed: !isStoreOpen? null :  () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomerCart()),
              );
            },
            innerVerticalPadding: 9,
            innerHorizontalPadding: 10,
            content: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      customerProvider.totalCartQuantity.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 13),
                Text(
                  l10.viewCart,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                Text(
                  '${l10.jod} ${customerProvider.totalCartPrice.toString()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
