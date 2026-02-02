import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/cart.dart';
import 'package:caterfy/models/order.dart';
import 'package:caterfy/models/order_item.dart';
import 'package:caterfy/models/product.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/shared_widgets.dart/custom_toast.dart';
import 'package:caterfy/util/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

class LoggedCustomerProvider with ChangeNotifier {
  final supabase = Supabase.instance.client;

  final box = Hive.box('cartBox');

  final debouncer = Debouncer(milliseconds: 300);

  Cart? _cart;

  Cart? get cart => _cart;

  void loadCart() {
    final customerId = Supabase.instance.client.auth.currentUser?.id;
    final data = box.get('cart_$customerId');
    if (data == null || customerId == null) {
      _cart = null;
      return;
    }

    _cart = Cart.fromMap(Map<String, dynamic>.from(data));
    notifyListeners();
  }

  void saveCart() {
    final bool noItems = _cart!.items.isEmpty;
    if (noItems) {
      _cart = null;
      deleteCart();
      return;
    }
    debouncer.run(() {
      final customerId = Supabase.instance.client.auth.currentUser?.id;
      box.put('cart_$customerId', _cart?.toMap());
    });
  }

  void deleteCart() {
    final customerId = Supabase.instance.client.auth.currentUser?.id;
    box.delete('cart_$customerId');
  }

  LoggedCustomerProvider() {
    loadCart();
  }

  List<Product> _products = [];
  List<Store> _stores = [];
  List<Order> _orderHistory = [];

  List<Product> get products => _products;
  List<Store> get stores => _stores;
  List<Order> get orderHistory => _orderHistory;

  bool _isCategoryLoading = false;
  bool _isProductsLoading = false;
  bool _isFavLoading = false;
  bool _isCartLoading = false;
  bool _isPlaceOrderLoading = false;
  bool _isOrderHistoryLoading = false;

  bool get isProductsLoading => _isProductsLoading;
  bool get isCategoryLoading => _isCategoryLoading;
  bool get isFavLoading => _isFavLoading;
  bool get isCartLoading => _isCartLoading;
  bool get isPlaceOrderLoading => _isPlaceOrderLoading;
  bool get isOrderHistoryLoading => _isOrderHistoryLoading;

  int get totalCartQuantity {
    if (_cart?.storeId == null) return 0;
    final items = _cart?.items ?? const [];
    int totalQuantity = 0;

    for (var item in items) {
      totalQuantity += item.quantity;
    }

    return totalQuantity;
  }

  double get totalCartPrice {
    if (_cart?.storeId == null) return 0;
    final items = _cart?.items ?? const [];
    double totalPrice = 0;

    for (var item in items) {
      totalPrice += item.price * item.quantity;
    }

    return totalPrice;
  }

  Store? getStoreById(String storeId) {
    for (final store in stores) {
      if (store.id == storeId) return store;
    }
    return null;
  }

  void orderAgain({required Order order}) {
    final customerId = Supabase.instance.client.auth.currentUser?.id;
    if (customerId != null) {
      deleteCart();
      _cart = Cart(
        customerId: customerId,
        storeId: order.storeId,
        storeName: order.storeName,
        items: order.items,
      );
    }
  }

  void addToCart({required OrderItem item}) {
    final customerId = Supabase.instance.client.auth.currentUser?.id;
    if (customerId!.isEmpty) return;
    final Store store = _stores.firstWhere((store) => store.id == item.storeId);
    final storeName = store.name;
    if (_cart?.storeId == null) {
      _cart = Cart(
        customerId: customerId,
        storeId: item.storeId,
        storeName: storeName,
      );
    } else if (_cart?.storeId != item.storeId) {
      _cart = null;
      deleteCart();
      _cart = Cart(
        customerId: customerId,
        storeId: item.storeId,
        storeName: storeName,
      );
    }

    _cart!.addItem(item: item);
    saveCart();
    notifyListeners();
  }

  void setItemQuantity({required OrderItem item, required int newQuantity}) {
    if (_cart?.storeId == null) return;

    _cart?.setItemQuantity(item: item, newQuantity: newQuantity);
    saveCart();
    notifyListeners();
  }

  void setOrderItem({required OrderItem item}) {
    if (_cart?.storeId == null) return;
    _cart?.setOrderItem(item: item);
    saveCart();
    notifyListeners();
  }

  void deleteItemFromCart({required String orderItemId}) {
    if (_cart?.storeId == null) return;
    _cart?.deleteItem(orderItemId: orderItemId);
    saveCart();
    notifyListeners();
  }

  void setOrderNote({required String newNote}) {
    if (_cart?.storeId == null) return;
    _cart?.setNote(newNote);
    saveCart();
    notifyListeners();
  }

  // ===== Favorites =====
  Map<String, Store> _favoriteStores = {};
  Map<String, Store> get favoriteStoreIdsMap => _favoriteStores;
  List<Store> get favoriteStores => _favoriteStores.values.toList();

  bool isFavorite(String storeId) => _favoriteStores.containsKey(storeId);

  Future<void> fetchFavorites(String customerId, BuildContext context) async {
    try {
      _isFavLoading = true;
      notifyListeners();
      final data = await supabase
          .from('customer_favorites')
          .select('store_id, stores(*)')
          .eq('customer_id', customerId)
          .order('created_at', ascending: false);
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
      _isFavLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProducts({
    required String storeId,
    required BuildContext context,
  }) async {
    final l10 = AppLocalizations.of(context);
    final isArabic = l10.localeName == 'ar';

    try {
      _isProductsLoading = true;
      notifyListeners();

      final data = await supabase
          .from('products')
          .select('*, sub_categories(name, name_ar)')
          .eq('store_id', storeId);

      final Map<String, Product> productsMap = {};

      for (final e in data) {
        final subcat = e['sub_categories'];

        final subCategoryName = (subcat is Map)
            ? (isArabic && (subcat['name_ar']?.toString().isNotEmpty ?? false)
                  ? subcat['name_ar']
                  : subcat['name'])
            : '';

        final productObject = {...e, 'sub_categories': subCategoryName};

        productsMap[e['id']] = Product.fromMap(productObject);
      }

      _products = productsMap.values.toList();
    } catch (e) {
      if (context.mounted) {
        showCustomToast(
          context: context,
          type: ToastificationType.error,
          message: l10.somethingWentWrong,
        );
      }
    } finally {
      _isProductsLoading = false;
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
      _isCategoryLoading = true;
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
      _isCategoryLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductsInCart({
    required String storeId,
    required BuildContext context,
  }) async {
    try {
      _isProductsLoading = true;
      notifyListeners();
      final data = await supabase
          .from('products')
          .select('*, sub_categories(name, name_ar)')
          .eq('store_id', storeId);

      final Map<String, Product> productsMap = {
        for (final product in _products) product.id: product,
      };

      for (final e in data) {
        final productId = e['id'];
        final subcat = e['sub_categories'];
        final subcatName = (subcat is Map)
            ? ((Localizations.localeOf(context).languageCode == 'ar' &&
                      (subcat['name_ar']?.toString().isNotEmpty ?? false))
                  ? subcat['name_ar']
                  : subcat['name'])
            : (subcat?.toString() ?? '');

        final productObject = {...e, 'sub_categories': subcatName};

        productsMap[productId] = Product.fromMap(productObject);
      }

      _products = productsMap.values.toList();

      final cartItems = cart?.items;
      if (cartItems!.isEmpty) return;

      final List<OrderItem> newList = [];

      for (var item in cartItems) {
        final equalProduct = productsMap[item.productId];
        if (equalProduct == null) continue;

        final OrderItem newItem = item.copyWith(
          name: equalProduct.name,
          description: equalProduct.description,
          imageUrl: equalProduct.imageUrl,
          price: equalProduct.price,
        );

        newList.add(newItem);
      }

      cart?.setItems(newList);

      saveCart();
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
      _isProductsLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCartContent({
    required String storeId,
    required BuildContext context,
  }) async {
    final l10 = AppLocalizations.of(context);

    try {
      _isCartLoading = true;
      notifyListeners();

      final receivedStore = await supabase
          .from('stores')
          .select()
          .eq('id', storeId);
      await fetchProductsInCart(storeId: storeId, context: context);

      final readyStore = Store.fromMap(receivedStore.first);

      bool addToList = true;

      for (int i = 0; i < _stores.length; i++) {
        if (_stores[i].id == readyStore.id) {
          _stores[i] = readyStore;
          addToList = false;
          break;
        }
      }

      if (addToList) {
        _stores.add(readyStore);
      }
    } catch (e) {
      if (context.mounted) {
        showCustomToast(
          context: context,
          type: ToastificationType.error,
          message: l10.somethingWentWrong,
        );
      }
    } finally {
      _isCartLoading = false;
      notifyListeners();
    }
  }

  Future<void> placeOrder({
    required BuildContext context,
    required double deliveryPrice,
  }) async {
    if (_cart?.storeId == null || _cart!.items.isEmpty) return;
    final l10 = AppLocalizations.of(context);
    try {
      _isPlaceOrderLoading = true;
      notifyListeners();

      final mapCart = _cart!.toMap();

      await supabase.from('orders').insert({
        ...mapCart,
        'delivery_price': deliveryPrice,
      });

      _cart = null;
      deleteCart();
    } catch (e) {
      if (context.mounted) {
        showCustomToast(
          context: context,
          type: ToastificationType.error,
          message: l10.somethingWentWrong,
        );
      }
    } finally {
      _isPlaceOrderLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrderHistory({required BuildContext context}) async {
    final customerId = Supabase.instance.client.auth.currentUser?.id;
    final l10 = AppLocalizations.of(context);
    if (customerId == null) return;
    try {
      _isOrderHistoryLoading = true;
      notifyListeners();

      final data = await supabase
          .from('orders')
          .select('*, stores:store_id (logo_url)')
          .eq('customer_id', customerId)
          .order('created_at', ascending: false);

      Map<String, dynamic> checkStoreLogo(order) {
        final storeLogo = (order['stores'] is Map)
            ? order['stores']['logo_url']
            : null;

        if (storeLogo == null) {
          return order;
        }

        return {...order, 'store_logo': storeLogo};
      }

      _orderHistory = data
          .map((order) => Order.fromMap(checkStoreLogo(order)))
          .toList();
    } catch (e) {
      if (context.mounted) {
        showCustomToast(
          context: context,
          type: ToastificationType.error,
          message: l10.somethingWentWrong,
        );
      }
    } finally {
      _isOrderHistoryLoading = false;
      notifyListeners();
    }
  }
}
