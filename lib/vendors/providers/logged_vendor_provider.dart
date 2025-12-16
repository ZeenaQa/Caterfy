import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:caterfy/models/store.dart';

class LoggedVendorProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  bool isLoading = false;
  bool hasStore = false;

  Store? store;

  String? storeNameEn;
  String? storeNameAr;
  String? storeCategory;
  String? storeArea;
  double storeLatitude = 0;
  double storeLongitude = 0;

  File? logoFile;
  File? bannerFile;

  List<String> tags = [];

  List<Map<String, dynamic>> subCategories = [];

  Future<void> checkVendorStore() async {
    isLoading = true;
    notifyListeners();

    final vendorId = supabase.auth.currentUser?.id;
    if (vendorId == null) {
      _resetStore();
      return;
    }

    final response = await supabase
        .from('stores')
        .select()
        .eq('vendor_id', vendorId)
        .maybeSingle();

    if (response != null) {
      store = Store.fromMap(response);
      hasStore = true;
      await fetchCategories();
    } else {
      _resetStore();
    }

    isLoading = false;
    notifyListeners();
  }

  void _resetStore() {
    store = null;
    hasStore = false;
    subCategories.clear();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    if (store == null) return;

    final response = await supabase
        .from('sub_categories')
        .select()
        .eq('store_id', store!.id)
        .order('created_at');

    subCategories = List<Map<String, dynamic>>.from(response);
    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    if (store == null || name.trim().isEmpty) return;

    await supabase.from('sub_categories').insert({
      'store_id': store!.id,
      'name': name.trim(),
    });

    await fetchCategories();
  }

  Future<String> uploadImage(File file, String folder) async {
    final userId = supabase.auth.currentUser!.id;
    final path = "$folder/$userId-${DateTime.now().millisecondsSinceEpoch}.jpg";

    await supabase.storage
        .from('store-images')
        .upload(path, file, fileOptions: const FileOptions(upsert: true));

    return supabase.storage.from('store-images').getPublicUrl(path);
  }

  Future<bool> createStore() async {
    try {
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
            'vendor_id': vendorId,
            'name': storeNameEn,
            'name_ar': storeNameAr,
            'category': storeCategory,
            'store_area': storeArea,
            'latitude': storeLatitude,
            'longitude': storeLongitude,
            'logo_url': logoUrl,
            'banner_url': bannerUrl,
            'tags': tags,
          })
          .select()
          .single();

      store = Store.fromMap(response);
      hasStore = true;

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
