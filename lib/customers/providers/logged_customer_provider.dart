import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/shared_widgets.dart/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

class LoggedCustomerProvider with ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<Store> _stores = [];
  List<Store> get stores => _stores;

  bool isFoodLoading = false;

  // ===== Favorites =====
  List<String> _favoriteStoreIds = [];
  List<String> get favoriteStoreIds => _favoriteStoreIds;

  bool isFavorite(String storeId) => _favoriteStoreIds.contains(storeId);
 

  Future<void> fetchFavorites(String customerId) async {
    try {
      final data = await supabase
          .from('customer_favorites')
          .select('store_id')
          .eq('customer_id', customerId);

      _favoriteStoreIds =
          data.map<String>((e) => e['store_id'].toString()).toList();

      notifyListeners();
    } catch (e) {}
  }

  
  Future<void> toggleFavorite(String customerId, String storeId) async {
  final isCurrentlyFavorite = _favoriteStoreIds.contains(storeId);
  if (isCurrentlyFavorite) {
    _favoriteStoreIds.remove(storeId);
  } else {
    _favoriteStoreIds.add(storeId);
  }
  notifyListeners();

  try {
    if (!isCurrentlyFavorite) {
      await supabase.from('customer_favorites').insert({
        'customer_id': customerId,
        'store_id': storeId,
      });
    } else {
      print("Deleting favorite with:");
print("customer_id: $customerId");
print("store_id: $storeId");
    final response =await supabase
    .from('customer_favorites')
    .delete()
    .eq('customer_id', customerId)
    .eq('store_id', storeId).select();

      print('Delete response: $response');
    }
  } catch (e) {
    print('Supabase error: $e');

    if (isCurrentlyFavorite) {
      _favoriteStoreIds.add(storeId);
    } else {
      _favoriteStoreIds.remove(storeId);
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
      isFoodLoading = true;
      notifyListeners();

      final data =
          await supabase.from('stores').select().eq('category', category);

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
      isFoodLoading = false;
      notifyListeners();
    }
  }
}
