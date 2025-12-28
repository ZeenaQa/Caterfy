import 'dart:io';
import 'package:caterfy/models/vendor_order.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:caterfy/models/store.dart';
import 'package:caterfy/models/product.dart';

class LoggedVendorProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  bool _isLoading = false;
  bool _isOrdersLoading = false;

  bool get isLoading => _isLoading;
  bool get isOrdersLoading => _isOrdersLoading;

  Store? store;
  List<Map<String, dynamic>> subCategories = [];
  List<Product> products = [];

  /* ===================== STORE ===================== */

  Future<void> checkVendorStore() async {
    _isLoading = true;
    notifyListeners();

    try {
      final vendorId = supabase.auth.currentUser?.id;
      if (vendorId == null) {
        return;
      }

      final response = await supabase
          .from('stores')
          .select('*')
          .eq('vendor_id', vendorId)
          .maybeSingle();

      if (response != null) {
        store = Store.fromMap(response);

        await _refreshSubCategories();
        await fetchProducts();
      } else {
        store = null;
      }
    } catch (e) {
      debugPrint('checkVendorStore error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createStore({
    required Store storeData,
    File? logoFile,
    File? bannerFile,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final vendorId = supabase.auth.currentUser?.id;
      if (vendorId == null) return false;

      String? logoUrl;
      String? bannerUrl;

      if (logoFile != null) {
        logoUrl = await uploadImage(logoFile, 'logos');
      }

      if (bannerFile != null) {
        bannerUrl = await uploadImage(bannerFile, 'banners');
      }

      final response = await supabase
          .from('stores')
          .insert({
            ...storeData.toMap(),
            'vendor_id': vendorId,
            'logo_url': logoUrl,
            'banner_url': bannerUrl,
          })
          .select()
          .single();

      store = Store.fromMap(response);

      await _refreshSubCategories();
      await fetchProducts();

      return true;
    } catch (e) {
      debugPrint('createStore error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateStore({
    required Store updatedStore,
    File? logoFile,
    File? bannerFile,
  }) async {
    if (store == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      String? logoUrl = store!.logoUrl;
      String? bannerUrl = store!.bannerUrl;

      if (logoFile != null) {
        logoUrl = await uploadImage(logoFile, 'logos');
      }

      if (bannerFile != null) {
        bannerUrl = await uploadImage(bannerFile, 'banners');
      }

      final response = await supabase
          .from('stores')
          .update({
            'name': updatedStore.name,
            'name_ar': updatedStore.name_ar,
            'category': updatedStore.category,
            'tags': updatedStore.tags,
            'store_area': updatedStore.storeArea,
            'latitude': updatedStore.latitude,
            'longitude': updatedStore.longitude,
            'logo_url': logoUrl,
            'banner_url': bannerUrl,
          })
          .eq('id', store!.id)
          .select()
          .single();

      store = Store.fromMap(response);
      return true;
    } catch (e) {
      debugPrint('updateStore error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /* ===================== SUB CATEGORIES ===================== */

  Future<void> addCategory({required String name, String? nameAr}) async {
    if (store == null || name.trim().isEmpty) return;

    await supabase.from('sub_categories').insert({
      'store_id': store!.id,
      'name': name.trim(),
      'name_ar': nameAr?.trim(),
    });

    await _refreshSubCategories();
  }

  Future<void> updateCategory({
    required String categoryId,
    required String newName,
    String? newNameAr,
  }) async {
    if (newName.trim().isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final updateData = {'name': newName.trim()};

      if (newNameAr != null) {
        updateData['name_ar'] = newNameAr.trim();
      }

      await supabase
          .from('sub_categories')
          .update(updateData)
          .eq('id', categoryId);

      await _refreshSubCategories();
    } catch (e) {
      debugPrint('updateCategory error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await supabase
          .from('products')
          .delete()
          .eq('sub_category_id', categoryId);

      await supabase.from('sub_categories').delete().eq('id', categoryId);

      await _refreshSubCategories();
      await fetchProducts();
    } catch (e) {
      debugPrint('deleteCategory error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _refreshSubCategories() async {
    if (store == null) return;

    final response = await supabase
        .from('sub_categories')
        .select('*')
        .eq('store_id', store!.id)
        .order('created_at');

    subCategories = List<Map<String, dynamic>>.from(response);
    notifyListeners();
  }

  /* ===================== PRODUCTS ===================== */

  Future<void> fetchProducts() async {
    if (store == null) return;

    final response = await supabase
        .from('products')
        .select('*')
        .eq('store_id', store!.id)
        .order('created_at');

    products = response.map<Product>((e) => Product.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required File imageFile,
    required String subCategoryId,
  }) async {
    if (store == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final imageUrl = await uploadImage(imageFile, 'products');

      await supabase.from('products').insert({
        'store_id': store!.id,
        'sub_category_id': subCategoryId,
        'name': name,
        'description': description,
        'price': price,
        'image_url': imageUrl,
      });

      await fetchProducts();
    } catch (e) {
      debugPrint('addProduct error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProductData({
    required String productId,
    required String name,
    required String description,
    required double price,
    File? imageFile,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      String? imageUrl;

      if (imageFile != null) {
        imageUrl = await uploadImage(imageFile, 'products');
      }

      final updateData = {
        'name': name,
        'description': description,
        'price': price,
      };

      if (imageUrl != null) {
        updateData['image_url'] = imageUrl;
      }

      await supabase.from('products').update(updateData).eq('id', productId);

      await fetchProducts();
    } catch (e) {
      debugPrint('updateProductData error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await supabase.from('products').delete().eq('id', productId);

      products.removeWhere((p) => p.id == productId);
    } catch (e) {
      debugPrint('deleteProduct error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Product> productsBySubCategory(String subCategoryId) {
    return products.where((p) => p.subCategoryId == subCategoryId).toList();
  }

  /* ===================== IMAGES ===================== */

  Future<String> uploadImage(File file, String folder) async {
    final userId = supabase.auth.currentUser!.id;
    final path = '$folder/$userId-${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage
        .from('store-images')
        .upload(path, file, fileOptions: const FileOptions(upsert: true));

    return supabase.storage.from('store-images').getPublicUrl(path);
  }

  List<VendorOrder> _orders = [];

  get orders => _orders;

  Future<void> fetchOrders() async {
    final String? storeId = store?.id;

    if (storeId == null) return;

    try {
      _isOrdersLoading = true;
      notifyListeners();

      final PostgrestList data = await supabase
          .from('orders')
          .select('*, customers:customer_id (name, email, phone)')
          .eq('store_id', storeId)
          .order('created_at', ascending: false);

      Map<String, dynamic> setUpOrder(Map<String, dynamic> order) {
        final customer = order['customers'];
        if (customer == null) return order;
        final String? customerName = order['customers']['name'];
        final String? customerEmail = order['customers']['email'];
        final String? customerPhone = order['customers']['phone'];
        return {
          ...order,
          'customer_name': customerName,
          'customer_phone': customerPhone,
          'customer_email': customerEmail,
        };
      }

      _orders = data
          .map((order) => VendorOrder.fromMap(setUpOrder(order)))
          .toList();

      // print(_orders);
    } catch (e) {
      debugPrint('$e');
    } finally {
      _isOrdersLoading = false;
      notifyListeners();
    }
  }
  Future<void> updateStoreStatus({
  required String storeId,
  required bool isOpen,
}) async {
  await supabase
      .from('stores')
      .update({'is_open': isOpen})
      .eq('id', storeId);
}

  
}

