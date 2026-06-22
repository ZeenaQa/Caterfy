import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/credit_card.dart';
import 'package:caterfy/models/cart.dart';
import 'package:caterfy/models/customer_address.dart';
import 'package:caterfy/models/laundry_order.dart';
import 'package:caterfy/models/order.dart';
import 'package:caterfy/models/ticket_order.dart';
import 'package:caterfy/models/voucher_order.dart';
import 'package:caterfy/models/discount_code.dart';
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

  RealtimeChannel? _ordersChannel;

  void subscribeToOrderUpdates(String customerId) {
    _ordersChannel?.unsubscribe();
    _ordersChannel = supabase
        .channel('customer_orders_$customerId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'orders',
          callback: (payload) {
            final newRecord = payload.newRecord;
            final recordCustomerId = newRecord['customer_id'] as String?;
            if (recordCustomerId != customerId) return;

            final orderId = newRecord['id'] as String?;
            final newStatus = newRecord['status'] as String?;
            if (orderId == null || newStatus == null) return;

            final idx = _orderHistory.indexWhere((o) => o.id == orderId);
            if (idx != -1 && _orderHistory[idx].status != newStatus) {
              _orderHistory[idx] = _orderHistory[idx].copyWith(status: newStatus);
              notifyListeners();
            }
          },
        )
        .subscribe();
  }

  void unsubscribeFromOrderUpdates() {
    _ordersChannel?.unsubscribe();
    _ordersChannel = null;
  }

  Future<void> silentFetchOrderStatus(String orderId) async {
    try {
      final data = await supabase
          .from('orders')
          .select('id, status')
          .eq('id', orderId)
          .single();

      final newStatus = data['status'] as String?;
      if (newStatus == null) return;

      final idx = _orderHistory.indexWhere((o) => o.id == orderId);
      if (idx != -1 && _orderHistory[idx].status != newStatus) {
        _orderHistory[idx] = _orderHistory[idx].copyWith(status: newStatus);
        notifyListeners();
      }
    } catch (_) {}
  }

  final debouncer = Debouncer(milliseconds: 300);

  // ── Addresses ───────────────────────────────────────────────────────────────

  List<CustomerAddress> _addresses = [];
  CustomerAddress? _selectedAddress;
  bool _isAddressLoading = false;

  List<CustomerAddress> get addresses => _addresses;
  CustomerAddress? get selectedAddress => _selectedAddress;
  bool get isAddressLoading => _isAddressLoading;

  static const Set<String> _categoriesRequiringAddress = {
    'food', 'ceemart', 'groceries', 'electronics', 'pharmacy',
    'toysAndKids', 'healthAndBeauty', 'clothing', 'stationeries', 'pets',
  };

  bool storeRequiresAddress(Store store) {
    return _categoriesRequiringAddress.contains(store.category) ||
        store.type == 'regular';
  }

  Future<void> fetchAddresses() async {
    _isAddressLoading = true;
    notifyListeners();
    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase
          .from('customer_addresses')
          .select()
          .eq('customer_id', userId)
          .order('is_default', ascending: false)
          .order('created_at');
      _addresses = (data as List).map((e) => CustomerAddress.fromMap(e)).toList();
      if (_selectedAddress == null && _addresses.isNotEmpty) {
        _selectedAddress = _addresses.firstWhere(
          (a) => a.isDefault,
          orElse: () => _addresses.first,
        );
      }
    } catch (_) {
    } finally {
      _isAddressLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAddress({
    required String type,
    required String? building,
    required String? floor,
    required String? apartment,
    required String? street,
    required String? directions,
    required String? area,
    required double latitude,
    required double longitude,
  }) async {
    final userId = supabase.auth.currentUser!.id;
    final makeDefault = _addresses.isEmpty;
    try {
      final result = await supabase
          .from('customer_addresses')
          .insert({
            'customer_id': userId,
            'type': type,
            if (building != null && building.isNotEmpty) 'building': building,
            if (floor != null && floor.isNotEmpty) 'floor': floor,
            if (apartment != null && apartment.isNotEmpty) 'apartment': apartment,
            if (street != null && street.isNotEmpty) 'street': street,
            if (directions != null && directions.isNotEmpty) 'directions': directions,
            if (area != null && area.isNotEmpty) 'area': area,
            'latitude': latitude,
            'longitude': longitude,
            'is_default': makeDefault,
          })
          .select()
          .single();
      final newAddr = CustomerAddress.fromMap(result);
      _addresses.insert(0, newAddr);
      if (_selectedAddress == null) _selectedAddress = newAddr;
      notifyListeners();
    } catch (e) {
      debugPrint('addAddress error: $e');
    }
  }

  Future<void> updateAddress({
    required String id,
    required String type,
    required String? building,
    required String? floor,
    required String? apartment,
    required String? street,
    required String? directions,
    required double latitude,
    required double longitude,
    required String? area,
  }) async {
    try {
      final result = await supabase
          .from('customer_addresses')
          .update({
            'type': type,
            'building': building?.isNotEmpty == true ? building : null,
            'floor': floor?.isNotEmpty == true ? floor : null,
            'apartment': apartment?.isNotEmpty == true ? apartment : null,
            'street': street?.isNotEmpty == true ? street : null,
            'directions': directions?.isNotEmpty == true ? directions : null,
            'latitude': latitude,
            'longitude': longitude,
            'area': area?.isNotEmpty == true ? area : null,
          })
          .eq('id', id)
          .select()
          .single();
      final updated = CustomerAddress.fromMap(result);
      final idx = _addresses.indexWhere((a) => a.id == id);
      if (idx != -1) _addresses[idx] = updated;
      if (_selectedAddress?.id == id) _selectedAddress = updated;
      notifyListeners();
    } catch (e) {
      debugPrint('updateAddress error: $e');
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await supabase.from('customer_addresses').delete().eq('id', id);
      _addresses.removeWhere((a) => a.id == id);
      if (_selectedAddress?.id == id) {
        _selectedAddress = _addresses.isNotEmpty ? _addresses.first : null;
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> setDefaultAddress(String id) async {
    final userId = supabase.auth.currentUser!.id;
    try {
      await supabase
          .from('customer_addresses')
          .update({'is_default': false})
          .eq('customer_id', userId);
      await supabase
          .from('customer_addresses')
          .update({'is_default': true})
          .eq('id', id);
      _addresses = _addresses
          .map((a) => a.copyWith(isDefault: a.id == id))
          .toList();
      notifyListeners();
    } catch (_) {}
  }

  void selectAddress(CustomerAddress address) {
    _selectedAddress = address;
    notifyListeners();
  }

  // ── Discount ────────────────────────────────────────────────────────────────

  DiscountCode? _appliedDiscount;
  bool _isApplyingDiscount = false;

  DiscountCode? get appliedDiscount => _appliedDiscount;
  bool get isApplyingDiscount => _isApplyingDiscount;

  double get appliedDiscountAmount {
    if (_appliedDiscount == null) return 0;
    return _appliedDiscount!.computeDiscount(totalCartPrice);
  }

  Future<String?> applyDiscountCode({
    required BuildContext context,
    required String code,
    required String storeId,
  }) async {
    final l10 = AppLocalizations.of(context);
    _isApplyingDiscount = true;
    notifyListeners();

    try {
      final trimmed = code.trim().toUpperCase();
      final data = await supabase
          .from('discount_codes')
          .select()
          .eq('code', trimmed)
          .eq('is_active', true)
          .maybeSingle();

      if (data == null) {
        _isApplyingDiscount = false;
        notifyListeners();
        return l10.invalidDiscountCode;
      }

      final discount = DiscountCode.fromMap(Map<String, dynamic>.from(data));

      if (discount.expiresAt != null &&
          discount.expiresAt!.isBefore(DateTime.now())) {
        _isApplyingDiscount = false;
        notifyListeners();
        return l10.discountCodeExpired;
      }

      if (discount.maxUses != null &&
          discount.usesCount >= discount.maxUses!) {
        _isApplyingDiscount = false;
        notifyListeners();
        return l10.invalidDiscountCode;
      }

      if (discount.storeId != null && discount.storeId != storeId) {
        _isApplyingDiscount = false;
        notifyListeners();
        return l10.invalidDiscountCode;
      }

      if (totalCartPrice < discount.minOrderAmount) {
        _isApplyingDiscount = false;
        notifyListeners();
        return l10.discountMinOrderNotMet;
      }

      _appliedDiscount = discount;
      _isApplyingDiscount = false;
      notifyListeners();
      return null;
    } catch (_) {
      _isApplyingDiscount = false;
      notifyListeners();
      return l10.somethingWentWrong;
    }
  }

  void clearDiscount() {
    _appliedDiscount = null;
    notifyListeners();
  }

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
  List<Order> _transactions = [];
  List<CreditCard> _paymentMethods = [];
  List<LaundryOrder> _laundryOrders = [];
  List<VoucherOrder> _voucherOrders = [];
  List<TicketOrder> _ticketOrders = [];

  List<Product> get products => _products;
  List<Store> get stores => _stores;
  List<Order> get orderHistory => _orderHistory;
  List<Order> get transactions => _transactions;
  List<CreditCard> get paymentMethods => _paymentMethods;
  List<LaundryOrder> get laundryOrders => _laundryOrders;
  List<LaundryOrder> get activeLaundryOrders =>
      _laundryOrders.where((o) => o.isActive).toList();
  List<VoucherOrder> get voucherOrders => _voucherOrders;
  List<TicketOrder> get ticketOrders => _ticketOrders;

  bool _isCategoryLoading = false;
  bool _isProductsLoading = false;
  bool _isFavLoading = false;
  bool _isCartLoading = false;
  bool _isPlaceOrderLoading = false;
  bool _isOrderHistoryLoading = false;
  bool _isAddCardLoading = false;
  bool _isCheckoutLoading = false;
  bool _transactionsLoading = false;
  bool _isLaundryOrdersLoading = false;
  bool _isVoucherOrdersLoading = false;
  bool _isTicketOrdersLoading = false;

  bool get isProductsLoading => _isProductsLoading;
  bool get isCategoryLoading => _isCategoryLoading;
  bool get isFavLoading => _isFavLoading;
  bool get isCartLoading => _isCartLoading;
  bool get isPlaceOrderLoading => _isPlaceOrderLoading;
  bool get isOrderHistoryLoading => _isOrderHistoryLoading;
  bool get isAddCardLoading => _isAddCardLoading;
  bool get isCheckoutLoading => _isCheckoutLoading;
  bool get transactionsLoading => _transactionsLoading;
  bool get isLaundryOrdersLoading => _isLaundryOrdersLoading;

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
        final nameEn = (subcat is Map) ? (subcat['name'] ?? '') : '';
        final subCategoryName = (subcat is Map)
            ? (isArabic && (subcat['name_ar']?.toString().isNotEmpty ?? false)
                  ? subcat['name_ar']
                  : subcat['name'])
            : '';

        final productObject = {...e, 'sub_categories': subCategoryName, 'sub_categories_en': nameEn};

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

  Future<Store?> fetchCeemartProducts(BuildContext context) async {
    final l10 = AppLocalizations.of(context);
    final isArabic = l10.localeName == 'ar';

    try {
      _isProductsLoading = true;
      notifyListeners();

      final storeData = await supabase
          .from('stores')
          .select()
          .eq('category', 'ceemart')
          .maybeSingle();

      if (storeData == null) return null;

      final ceemartStore = Store.fromMap(storeData);

      final idx = _stores.indexWhere((s) => s.id == ceemartStore.id);
      if (idx >= 0) {
        _stores[idx] = ceemartStore;
      } else {
        _stores.add(ceemartStore);
      }

      final data = await supabase
          .from('products')
          .select('*, sub_categories(name, name_ar)')
          .eq('store_id', ceemartStore.id);

      final Map<String, Product> productsMap = {};
      for (final e in data) {
        final subcat = e['sub_categories'];
        final nameEn = (subcat is Map) ? (subcat['name'] ?? '') : '';
        final subCategoryName = (subcat is Map)
            ? (isArabic && (subcat['name_ar']?.toString().isNotEmpty ?? false)
                  ? subcat['name_ar']
                  : subcat['name'])
            : '';
        productsMap[e['id']] = Product.fromMap({...e, 'sub_categories': subCategoryName, 'sub_categories_en': nameEn});
      }
      _products = productsMap.values.toList();

      return ceemartStore;
    } catch (e) {
      if (context.mounted) {
        showCustomToast(
          context: context,
          type: ToastificationType.error,
          message: l10.somethingWentWrong,
        );
      }
      return null;
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
  static const _serviceCategories = {'myCar', 'myHouse', "eventPlanning", "education"};

  Future<void> fetchStores({
    required String category,
    required BuildContext context,
  }) async {
    final l10 = AppLocalizations.of(context);
    final storeType = _serviceCategories.contains(category) ? 'service' : 'regular';

    try {
      _isCategoryLoading = true;
      notifyListeners();

      final data = await supabase
          .from('stores')
          .select()
          .eq('category', category)
          .eq('type', storeType);

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
        final nameEn = (subcat is Map) ? (subcat['name'] ?? '') : '';
        final subcatName = (subcat is Map)
            ? ((Localizations.localeOf(context).languageCode == 'ar' &&
                      (subcat['name_ar']?.toString().isNotEmpty ?? false))
                  ? subcat['name_ar']
                  : subcat['name'])
            : (subcat?.toString() ?? '');

        final productObject = {...e, 'sub_categories': subcatName, 'sub_categories_en': nameEn};

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

  Future<String?> placeOrder({
    required BuildContext context,
    required double deliveryPrice,
    required double walletTransaction,
    required bool isUsingWallet,
  }) async {
    if (_cart?.storeId == null || _cart!.items.isEmpty) return null;
    final l10 = AppLocalizations.of(context);
    final userId = supabase.auth.currentUser!.id;
    final discount = _appliedDiscount;
    final discountAmount = appliedDiscountAmount;
    try {
      _isPlaceOrderLoading = true;
      notifyListeners();

      final mapCart = _cart!.toMap();
      final cartStoreType = _stores
          .where((s) => s.id == _cart!.storeId)
          .map((s) => s.type)
          .firstOrNull ?? 'regular';

      final result = await supabase
          .from('orders')
          .insert({
            ...mapCart,
            'delivery_price': deliveryPrice,
            'wallet_transaction': isUsingWallet
                ? walletTransaction.toStringAsFixed(2)
                : 0.00,
            'status': 'pending',
            'store_type': cartStoreType,
            if (discount != null) 'discount_code': discount.code,
            'discount_amount': discountAmount,
            if (_selectedAddress != null) 'delivery_address': _selectedAddress!.subtitle,
          })
          .select('id')
          .single();

      if (discount != null) {
        await supabase.rpc(
          'redeem_discount_code',
          params: {'p_code': discount.code},
        );
      }

      if (isUsingWallet) {
        await supabase.rpc(
          'subtract_wallet_balance',
          params: {
            'p_customer_id': userId,
            'p_amount': totalCartPrice + deliveryPrice - discountAmount,
          },
        );
      }

      _cart = null;
      _appliedDiscount = null;
      deleteCart();
      return result['id'] as String?;
    } catch (e) {
      if (context.mounted) {
        showCustomToast(
          context: context,
          type: ToastificationType.error,
          message: l10.somethingWentWrong,
        );
      }
      return null;
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
          .select('*, stores:store_id (logo_url, name_ar, type, category)')
          .eq('customer_id', customerId)
          .order('created_at', ascending: false);

      Map<String, dynamic> enrichOrder(order) {
        final store = order['stores'];
        final storeLogo = (store is Map) ? store['logo_url'] : null;
        final storeArName = (store is Map) ? store['name_ar'] : '';
        final storeType = (store is Map) ? (store['type'] ?? 'regular') : (order['store_type'] ?? 'regular');
        final storeCategory = (store is Map) ? (store['category'] ?? '') : '';
        return {
          ...order,
          if (storeLogo != null) 'store_logo': storeLogo,
          'name_ar': storeArName,
          'store_type': storeType,
          'store_category': storeCategory,
        };
      }

      _orderHistory = data
          .map((order) => Order.fromMap(enrichOrder(order)))
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

  Future<void> AddCard({
    required BuildContext context,
    required CreditCard card,
  }) async {
    final l10 = AppLocalizations.of(context);
    try {
      _isAddCardLoading = true;
      notifyListeners();

      final mapCard = card.toMap();

      await supabase.from('cards').insert(mapCard);

      _paymentMethods.add(card);
      if (context.mounted) {
        Navigator.of(context).pop();
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
      _isAddCardLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPaymentMethods({required BuildContext context}) async {
    final customerId = Supabase.instance.client.auth.currentUser?.id;
    final l10 = AppLocalizations.of(context);
    if (customerId == null) return;
    try {
      _isCheckoutLoading = true;
      notifyListeners();

      final data = await supabase
          .from('cards')
          .select('*')
          .eq('customer_id', customerId);
      _paymentMethods = data.map((card) => CreditCard.fromMap(card)).toList();
    } catch (e) {
      if (context.mounted) {
        showCustomToast(
          context: context,
          type: ToastificationType.error,
          message: l10.somethingWentWrong,
        );
      }
    } finally {
      _isCheckoutLoading = false;
      notifyListeners();
    }
  }

  Future<void> removePaymentMethod({
    required BuildContext context,
    required String cardNumber,
  }) async {
    final customerId = Supabase.instance.client.auth.currentUser?.id;
    final l10 = AppLocalizations.of(context);
    if (customerId == null) return;
    try {
      await supabase
          .from('cards')
          .delete()
          .eq('customer_id', customerId)
          .eq('card_number', cardNumber);

      paymentMethods.removeWhere((card) => card.cardNumber == cardNumber);
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        showCustomToast(
          context: context,
          type: ToastificationType.error,
          message: l10.somethingWentWrong,
        );
      }
    }
  }

  // ===== Laundry Orders =====

  Future<String?> placeLaundryOrder({
    required BuildContext context,
    required String storeName,
    required String storeImageUrl,
    required String service,
    required String address,
    required String phone,
    required String pickupTime,
    required String deliveryDate,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;
    final l10 = AppLocalizations.of(context);
    try {
      final result = await supabase
          .from('laundry_orders')
          .insert({
            'customer_id': userId,
            'store_name': storeName,
            'store_image_url': storeImageUrl,
            'service': service,
            'address': address,
            'phone': phone,
            'pickup_time': pickupTime,
            'delivery_date': deliveryDate,
            'status': 'scheduled',
          })
          .select('id')
          .single();
      return result['id'] as String?;
    } catch (e) {
      if (context.mounted) {
        showCustomToast(
          context: context,
          type: ToastificationType.error,
          message: l10.somethingWentWrong,
        );
      }
      return null;
    }
  }

  Future<void> fetchLaundryOrders({required BuildContext context}) async {
    final customerId = supabase.auth.currentUser?.id;
    if (customerId == null) return;
    try {
      _isLaundryOrdersLoading = true;
      notifyListeners();
      final data = await supabase
          .from('laundry_orders')
          .select()
          .eq('customer_id', customerId)
          .order('created_at', ascending: false);
      _laundryOrders = data.map((e) => LaundryOrder.fromMap(e)).toList();
    } catch (_) {
    } finally {
      _isLaundryOrdersLoading = false;
      notifyListeners();
    }
  }

  Future<void> silentFetchLaundryOrderStatus(String orderId) async {
    try {
      final data = await supabase
          .from('laundry_orders')
          .select('id, status')
          .eq('id', orderId)
          .single();
      final newStatus = data['status'] as String?;
      if (newStatus == null) return;
      final idx = _laundryOrders.indexWhere((o) => o.id == orderId);
      if (idx != -1 && _laundryOrders[idx].status != newStatus) {
        _laundryOrders[idx] = _laundryOrders[idx].copyWith(status: newStatus);
        notifyListeners();
      }
    } catch (_) {}
  }

  // ===== Voucher Orders =====

  Future<VoucherOrder?> placeVoucherOrder({
    required BuildContext context,
    required String provider,
    required String providerCategory,
    required String denominationLabel,
    required double priceJod,
    required String activationCode,
    required bool isUsingWallet,
    required double walletTransaction,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;
    final l10 = AppLocalizations.of(context);
    try {
      final result = await supabase
          .from('voucher_orders')
          .insert({
            'customer_id': userId,
            'provider': provider,
            'provider_category': providerCategory,
            'denomination_label': denominationLabel,
            'price_jod': priceJod,
            'activation_code': activationCode,
            'status': 'completed',
          })
          .select()
          .single();

      if (isUsingWallet) {
        await supabase.rpc(
          'subtract_wallet_balance',
          params: {
            'p_customer_id': userId,
            'p_amount': walletTransaction,
          },
        );
      }

      final order = VoucherOrder.fromMap(result);
      _voucherOrders.insert(0, order);
      notifyListeners();
      return order;
    } catch (e) {
      if (context.mounted) {
        showCustomToast(
          context: context,
          type: ToastificationType.error,
          message: l10.somethingWentWrong,
        );
      }
      return null;
    }
  }

  Future<void> fetchVoucherOrders({required BuildContext context}) async {
    final customerId = supabase.auth.currentUser?.id;
    if (customerId == null) return;
    try {
      _isVoucherOrdersLoading = true;
      notifyListeners();
      final data = await supabase
          .from('voucher_orders')
          .select()
          .eq('customer_id', customerId)
          .order('created_at', ascending: false);
      _voucherOrders = data.map((e) => VoucherOrder.fromMap(e)).toList();
    } catch (_) {
    } finally {
      _isVoucherOrdersLoading = false;
      notifyListeners();
    }
  }

  // ===== Ticket Orders =====

  Future<TicketOrder?> placeTicketOrder({
    required BuildContext context,
    required String eventName,
    required String eventCategory,
    required String ticketType,
    required String eventDate,
    required String venue,
    required double priceJod,
    required String bookingRef,
    required bool isUsingWallet,
    required double walletTransaction,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;
    final l10 = AppLocalizations.of(context);
    try {
      final result = await supabase
          .from('ticket_orders')
          .insert({
            'customer_id': userId,
            'event_name': eventName,
            'event_category': eventCategory,
            'ticket_type': ticketType,
            'event_date': eventDate,
            'venue': venue,
            'price_jod': priceJod,
            'booking_ref': bookingRef,
            'quantity': 1,
            'status': 'confirmed',
          })
          .select()
          .single();

      if (isUsingWallet) {
        await supabase.rpc(
          'subtract_wallet_balance',
          params: {
            'p_customer_id': userId,
            'p_amount': walletTransaction,
          },
        );
      }

      final order = TicketOrder.fromMap(result);
      _ticketOrders.insert(0, order);
      notifyListeners();
      return order;
    } catch (e) {
      if (context.mounted) {
        showCustomToast(
          context: context,
          type: ToastificationType.error,
          message: l10.somethingWentWrong,
        );
      }
      return null;
    }
  }

  Future<void> fetchTicketOrders({required BuildContext context}) async {
    final customerId = supabase.auth.currentUser?.id;
    if (customerId == null) return;
    try {
      _isTicketOrdersLoading = true;
      notifyListeners();
      final data = await supabase
          .from('ticket_orders')
          .select()
          .eq('customer_id', customerId)
          .order('created_at', ascending: false);
      _ticketOrders = data.map((e) => TicketOrder.fromMap(e)).toList();
    } catch (_) {
    } finally {
      _isTicketOrdersLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWalletTransactions({required BuildContext context}) async {
    final customerId = Supabase.instance.client.auth.currentUser?.id;
    final l10 = AppLocalizations.of(context);
    if (customerId == null) return;
    try {
      _transactionsLoading = true;
      notifyListeners();

      final data = await supabase
          .from('orders')
          .select('*, stores:store_id (logo_url, name_ar)')
          .eq('customer_id', customerId)
          .gt('wallet_transaction', 0)
          .order('created_at', ascending: false);

      Map<String, dynamic> checkStoreLogo(order) {
        final storeLogo = (order['stores'] is Map)
            ? order['stores']['logo_url']
            : null;

        final storeArName = order['stores']['name_ar'];

        if (storeLogo == null) {
          return order;
        }

        return {...order, 'store_logo': storeLogo, 'name_ar': storeArName};
      }

      _transactions = data
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
      _transactionsLoading = false;
      notifyListeners();
    }
  }
}
