import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:caterfy/models/store.dart';
import 'package:caterfy/models/product.dart';

class LoggedVendorProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  bool isLoading = false;
  bool hasStore = false;
  Store? store;
  Store? storeForm;
  bool showStoreInfoErrors = false;
  File? logoFile;
  File? bannerFile;
  List<Map<String, dynamic>> subCategories = [];
  List<Product> products = [];

  void initStoreForm() {
    storeForm = Store(
      id: '',
      vendorId: '',
      name: '',
      name_ar: '',
      category: '',
      storeArea: null,
      latitude: 0,
      longitude: 0,
      tags: [],
    );
    notifyListeners();
  }

  bool get isStoreInfoValid {
    return storeForm != null &&
        storeForm!.name.isNotEmpty &&
        storeForm!.name_ar.isNotEmpty &&
        storeForm!.category.isNotEmpty;
  }

  void updateStoreForm({
    String? name,
    String? nameAr,
    String? category,
    String? storeArea,
    double? latitude,
    double? longitude,
    List<String>? tags,
  }) {
    if (storeForm == null) return;

    storeForm = Store(
      id: storeForm!.id,
      vendorId: storeForm!.vendorId,
      name: name ?? storeForm!.name,
      name_ar: nameAr ?? storeForm!.name_ar,
      category: category ?? storeForm!.category,
      storeArea: storeArea ?? storeForm!.storeArea,
      latitude: latitude ?? storeForm!.latitude,
      longitude: longitude ?? storeForm!.longitude,
      tags: tags ?? storeForm!.tags,
      logoUrl: storeForm!.logoUrl,
      bannerUrl: storeForm!.bannerUrl,
    );

    notifyListeners();
  }

  Future<void> checkVendorStore() async {
    isLoading = true;
    notifyListeners();

    try {
      final vendorId = supabase.auth.currentUser?.id;
      if (vendorId == null) {
        hasStore = false;
        return;
      }

      final response = await supabase
          .from('stores')
          .select('*')
          .eq('vendor_id', vendorId)
          .maybeSingle();

      if (response != null) {
        store = Store.fromMap(response);
        hasStore = true;

        await _refreshSubCategories();
        await fetchProducts();
      } else {
        hasStore = false;
        store = null;
      }
    } catch (e) {
      debugPrint('checkVendorStore error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createStore() async {
    try {
      if (storeForm == null) return false;

      isLoading = true;
      notifyListeners();

      final vendorId = supabase.auth.currentUser?.id;
      if (vendorId == null) return false;

      String? logoUrl;
      String? bannerUrl;

      if (logoFile != null) {
        logoUrl = await uploadImage(logoFile!, 'logos');
      }

      if (bannerFile != null) {
        bannerUrl = await uploadImage(bannerFile!, 'banners');
      }

      final response = await supabase
          .from('stores')
          .insert({
            ...storeForm!.toMap(),
            'vendor_id': vendorId,
            'logo_url': logoUrl,
            'banner_url': bannerUrl,
          })
          .select()
          .single();

      store = Store.fromMap(response);
      hasStore = true;

      await _refreshSubCategories();
      await fetchProducts();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /* ===================== SUB CATEGORIES ===================== */

  Future<void> addCategory(String name, {String? nameAr}) async {
    if (store == null || name.trim().isEmpty) return;

    await supabase.from('sub_categories').insert({
      'store_id': store!.id,
      'name': name.trim(),
      'name_ar': nameAr?.trim(),
    });

    await _refreshSubCategories();
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

  Future<void> updateCategory({
    required String categoryId,
    required String newName,
    String? newNameAr,
  }) async {
    if (newName.trim().isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      final updateData = {
        'name': newName.trim(),
      };

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
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    isLoading = true;
    notifyListeners();

    try {
      // delete products under category
      await supabase
          .from('products')
          .delete()
          .eq('sub_category_id', categoryId);

      // delete category
      await supabase.from('sub_categories').delete().eq('id', categoryId);

      await _refreshSubCategories();
      await fetchProducts();
    } catch (e) {
      debugPrint('deleteCategory error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
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

    isLoading = true;
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
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    isLoading = true;
    notifyListeners();

    await supabase.from('products').delete().eq('id', productId);

    products.removeWhere((p) => p.id == productId);

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProductData({
    required String productId,
    required String name,
    required String description,
    required double price,
    File? imageFile,
  }) async {
    isLoading = true;
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
      isLoading = false;
      notifyListeners();
    }
  }

  List<Product> productsBySubCategory(String subCategoryId) {
    return products.where((p) => p.subCategoryId == subCategoryId).toList();
  }

  /* ===================== IMAGES ===================== */

  Future<String> uploadImage(File file, String folder) async {
    final userId = supabase.auth.currentUser!.id;
    final path = "$folder/$userId-${DateTime.now().millisecondsSinceEpoch}.jpg";

    await supabase.storage
        .from('store-images')
        .upload(path, file, fileOptions: const FileOptions(upsert: true));

    return supabase.storage.from('store-images').getPublicUrl(path);
  }

  Future<bool> updateStore() async {
    if (storeForm == null || store == null) return false;

    try {
      isLoading = true;
      notifyListeners();

      String? logoUrl = store!.logoUrl;
      String? bannerUrl = store!.bannerUrl;

      /// ===== UPLOAD LOGO =====
      if (logoFile != null) {
        logoUrl = await uploadImage(logoFile!, 'logos');
      }

      /// ===== UPLOAD BANNER =====
      if (bannerFile != null) {
        bannerUrl = await uploadImage(bannerFile!, 'banners');
      }

      /// ===== UPDATE STORE =====
      final response = await supabase
          .from('stores')
          .update({
            'name': storeForm!.name,
            'tags': storeForm!.tags,
            'logo_url': logoUrl,
            'banner_url': bannerUrl,
          })
          .eq('id', store!.id)
          .select()
          .single();

      /// ===== UPDATE LOCAL STATE =====
      store = Store.fromMap(response);
      storeForm = store;

      logoFile = null;
      bannerFile = null;

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('updateStore error: $e');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ======= Helpers to set files safely =====
  void setLogoFile(File? file) {
    logoFile = file;
    notifyListeners();
  }

  void setBannerFile(File? file) {
    bannerFile = file;
    notifyListeners();
  }

  void setShowStoreInfoErrors(bool value) {
    showStoreInfoErrors = value;
    notifyListeners();
  }
}

