import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/product.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/shared_widgets.dart/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

class LoggedCustomerProvider with ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<Product> _products = [];
  List<Product> get products => _products;
  List<Store> _stores = [];
  List<Store> get stores => _stores;

  bool isCategoryLoading = false;

  int productsNum = 0;
  double totalPrice = 0;

  void setTotalPrice(double val) {
    totalPrice += val;
    notifyListeners();
  }

  void setProductsNum(int val) {
    productsNum += val;
    notifyListeners();
  }

  void clearCart() {
    productsNum = 0;
    totalPrice = 0;
    notifyListeners();
  }

  // ===== Favorites =====
  Map<String, Store> _favoriteStores = {};
  Map<String, Store> get favoriteStoreIdsMap => _favoriteStores;
  List<Store> get favoriteStores => _favoriteStores.values.toList();

  bool isFavorite(String storeId) => _favoriteStores.containsKey(storeId);

  Future<void> fetchFavorites(String customerId, BuildContext context) async {
    try {
      final data = await supabase
          .from('customer_favorites')
          .select('store_id, stores(*)')
          .eq('customer_id', customerId);
      _favoriteStores = {};

      for (final e in data) {
        final storeId = e['store_id'].toString();
        final storeObject = e['stores'];

        _favoriteStores[storeId] = Store.fromMap(storeObject);
      }
    } catch (e) {
      if (context.mounted) {
        final l10 = AppLocalizations.of(context);
        showCustomToast(
          context: context,
          type: ToastificationType.error,
          message: l10.somethingWentWrong,
        );
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchProducts({
    required String storeId,
    required BuildContext context,
  }) async {
    try {
      final data = await supabase
          .from('products')
          .select('*, sub_categories(name)')
          .eq('store_id', storeId);

      final Map<String, Product> productsMap = {
        for (final product in _products) product.id: product,
      };

      for (final e in data) {
        final productId = e['id'];
        final productObject = {
          ...e,
          'sub_categories': e['sub_categories']['name'],
        };

        productsMap[productId] = Product.fromMap(productObject);
      }

      _products = productsMap.values.toList();
    } catch (e) {
      if (context.mounted) {
        final l10 = AppLocalizations.of(context);
        showCustomToast(
          context: context,
          type: ToastificationType.error,
          message: l10.somethingWentWrong,
        );
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String customerId, Store store) async {
    final isCurrentlyFavorite = _favoriteStores.containsKey(store.id);

    try {
      if (!isCurrentlyFavorite) {
        _favoriteStores[store.id] = store;
        notifyListeners();
        await supabase.from('customer_favorites').insert({
          'customer_id': customerId,
          'store_id': store.id,
        });
      } else {
        _favoriteStores.remove(store.id);
        notifyListeners();
        await supabase
            .from('customer_favorites')
            .delete()
            .eq('customer_id', customerId)
            .eq('store_id', store.id)
            .select();
      }
    } catch (e) {
      if (isCurrentlyFavorite) {
        _favoriteStores[store.id] = store;
      } else {
        _favoriteStores.remove(store.id);
      }
      notifyListeners();
    }
  }

  // ===== Fetch Stores =====
  Future<void> fetchStores({
    required String category,
    required BuildContext context,
  }) async {
    final l10 = AppLocalizations.of(context);

    try {
      isCategoryLoading = true;
      notifyListeners();

      final data = await supabase
          .from('stores')
          .select()
          .eq('category', category);

      _stores = data.map((item) => Store.fromMap(item)).toList();
    } catch (e) {
      if (context.mounted) {
        showCustomToast(
          context: context,
          type: ToastificationType.error,
          message: l10.somethingWentWrong,
        );
      }
    } finally {
      isCategoryLoading = false;
      notifyListeners();
    }
  }
}
