import 'package:caterfy/customers/customer_widgets/customer_store_list_item.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/favorite_stores_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/outlined_icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomerFoodCategory extends StatefulWidget {
  const CustomerFoodCategory({super.key});

  @override
  State<CustomerFoodCategory> createState() => _CustomerFoodCategoryState();
}

class _CustomerFoodCategoryState extends State<CustomerFoodCategory> {
  late ScrollController _scrollController;

  double searchBarHeight = 63;
  double currentSearchBarOffset = 0;
  double lastOffset = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      double delta = offset - lastOffset;

      double newSearchBarOffset = currentSearchBarOffset - delta;

      if (newSearchBarOffset > 0) newSearchBarOffset = 0;
      if (newSearchBarOffset < -searchBarHeight)
        newSearchBarOffset = -searchBarHeight;

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
      await provider.fetchStores(category: 'food', context: context);
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
    return Scaffold(
      appBar: CustomAppBar(
        content: Expanded(
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(fontSize: 15, color: colors.onSurface),
                    children: [
                      TextSpan(text: '${l10.deliverTo} '),
                      TextSpan(
                        text: provider.deliveryLocation,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              OutlinedIconBtn(
                child: Icon(Icons.favorite_outline, size: 19),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteStoresScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          if (customerProvider.stores.isNotEmpty)
            ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: searchBarHeight + 10,
              ),
              itemCount: customerProvider.stores.length,
              itemBuilder: (context, index) {
                final store = customerProvider.stores[index];
                return CustomerStoreListItem(store: store);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
            )
          else if (customerProvider.isFoodLoading)
            Skeletonizer(
              enabled: true,
              child: ListView.separated(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: searchBarHeight + 10,
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return CustomerStoreListItem(
                    store: Store(
                      id: '1',
                      vendorId: '2',
                      storeArea: '222222222',
                      name: '222222222',
                    ),
                    dummyImage: true,
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
                    hintText: "Search food",
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
