import 'package:caterfy/customers/customer_widgets/customer_store_list_item.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';

import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FavoriteStoresScreen extends StatelessWidget {
  const FavoriteStoresScreen({super.key, this.category = ''});

  final String category;

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final colors = Theme.of(context).colorScheme;

    final l10 = AppLocalizations.of(context);

    final favoriteStores = category.isNotEmpty
        ? customerProvider.favoriteStores
              .where((store) => store.category == category)
              .toList()
        : customerProvider.favoriteStores;

    return Scaffold(
      appBar: CustomAppBar(
        content: Expanded(
          child: Text(
            l10.favorites,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
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
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.heart,
                    size: 100,
                    color: colors.outline,
                  ),
                  Text(
                    "Your favorite stores will appear here",
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
    );
  }
}
