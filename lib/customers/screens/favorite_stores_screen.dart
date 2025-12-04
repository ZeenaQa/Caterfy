import 'package:caterfy/customers/customer_widgets/customer_store_list_item.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';

import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavoriteStoresScreen extends StatelessWidget {
  const FavoriteStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final colors = Theme.of(context).colorScheme;

    final l10 = AppLocalizations.of(context);

  
    final favoriteStores = customerProvider.stores
        .where((store) => store.isFavorite == true)
        .toList();

    return Scaffold(
      appBar: CustomAppBar(
        content: Expanded(
          child: Text(
            l10.favorites,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.onSurface),
          ),
        ),
      ),
      body: favoriteStores.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.all(15),
              itemCount: favoriteStores.length,
              itemBuilder: (context, index) {
                final store = favoriteStores[index];
                return CustomerStoreListItem(store: store);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
            )
          : Center(
              child: Text(
                "noFavoritesYet" ,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
            ),
    );
  }
}
