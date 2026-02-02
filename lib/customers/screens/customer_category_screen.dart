import 'package:caterfy/customers/customer_widgets/cart_button.dart';
import 'package:caterfy/customers/customer_widgets/customer_store_list_item.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/favorite_stores_screen.dart';
import 'package:caterfy/dummy_data.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/customers/utils/localization_helpers.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/outlined_icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.category});

  final String category;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late ScrollController _scrollController;

  double searchBarHeight = 63;
  double currentSearchBarOffset = 0;
  double lastOffset = 0;

  @override
  void initState() {
    super.initState();

    final location = context.read<GlobalProvider>().lastPickedLocation;

    if (location == null) {
      Navigator.of(context).pop();
    }

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      double delta = offset - lastOffset;

      double newSearchBarOffset = currentSearchBarOffset - delta;

      if (newSearchBarOffset > 0) newSearchBarOffset = 0;
      if (newSearchBarOffset < -searchBarHeight) {
        newSearchBarOffset = -searchBarHeight;
      }

      if (newSearchBarOffset != currentSearchBarOffset) {
        currentSearchBarOffset = newSearchBarOffset;
        setState(() {});
      }

      lastOffset = offset;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<LoggedCustomerProvider>(
        context,
        listen: false,
      );
      await provider.fetchStores(category: widget.category, context: context);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final provider = context.watch<GlobalProvider>();
    final l10 = AppLocalizations.of(context);
    final isLoading = customerProvider.isCategoryLoading;

    final List<Store> stores = customerProvider.stores
        .where((store) => store.category == widget.category)
        .toList();

    return Scaffold(
      appBar: CustomAppBar(
        content: Expanded(
          child: Row(
            children: [
              Expanded(
                child: Consumer<GlobalProvider>(
                  builder: (_, provider, __) {
                    return RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: TextStyle(fontSize: 15, color: colors.onSurface),
                        children: [
                          TextSpan(
                            text: provider.deliveryLocation != null
                                ? '${l10.deliverTo} '
                                : '',
                          ),
                          TextSpan(
                            text: l10.pickLocation,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 10),
              OutlinedIconBtn(
                child: Icon(Icons.favorite_outline, size: 19),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FavoriteStoresScreen(category: widget.category),
                    ),
                  );
                },
              ),
              CartButton(),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Skeletonizer(
            enabled: isLoading,
            child: ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: searchBarHeight + 10,
              ),
              itemCount: isLoading ? dummyStores.length : stores.length,
              itemBuilder: (context, index) {
                final store = isLoading ? dummyStores[index] : stores[index];
                return CustomerStoreListItem(
                  store: store,
                  dummyImage: isLoading,
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
            ),
          ),

          Transform.translate(
            offset: Offset(0, currentSearchBarOffset),
            child: Container(
              color: colors.onInverseSurface,
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 12,
                bottom: 10,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: TextField(
                  decoration: InputDecoration(
                    hintText:
                        '${l10.searchAbout} ${getLocalizedCategory(context, widget.category)}',
                    hintStyle: TextStyle(fontSize: 15),
                    filled: true,
                    fillColor: colors.surfaceContainer,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                    prefixIconConstraints: BoxConstraints(minHeight: 0),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 13.0, right: 5),
                      child: Icon(Icons.search, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
