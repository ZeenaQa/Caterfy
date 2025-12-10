
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class LoggedVendorProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  bool isLoading = false;
  bool hasStore = false;
  String? errorMessage;
  String? successMessage;


  File? logoFile;
  File? bannerFile;

  String? storeNameEn;
  String? storeNameAr;
  String? storeCategory;
  String? storeArea;
  double? storeLatitude;
  double? storeLongitude;


  String? logoUrl;
  String? bannerUrl;

  List<String> tags = [];

  Future<void> checkVendorStore() async {
    isLoading = true;
    notifyListeners();

    final vendorId = supabase.auth.currentUser?.id;
    if (vendorId == null) {
      hasStore = false;
      isLoading = false;
      notifyListeners();
      return;
    }

    final response = await supabase
        .from('stores')
        .select()
        .eq('vendor_id', vendorId)
        .maybeSingle();

    if (response != null) {
      hasStore = true;
      storeNameEn = response['name'];
      storeNameAr = response['name_ar'];
      storeCategory = response['category'];
      storeArea = response['store_area'];
      storeLatitude = response['latitude'];
      storeLongitude = response['longitude'];
      tags = List<String>.from(response['tags'] ?? []);
      logoUrl = response['logo_url'];
      bannerUrl = response['banner_url'];
    } else {
      hasStore = false;
    }

    isLoading = false;
    notifyListeners();
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
    final vendorId = supabase.auth.currentUser?.id;
    if (vendorId == null) return false;

    if (storeNameEn == null ||
        storeNameAr == null ||
        storeCategory == null ||
        logoFile == null ||
        bannerFile == null ||
        storeArea == null ||
        storeLatitude == null ||
        storeLongitude == null ||
        tags.isEmpty) {
      errorMessage = "Missing required fields";
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      notifyListeners();

      final uploadedLogoUrl = await uploadImage(logoFile!, 'logos');
      final uploadedBannerUrl = await uploadImage(bannerFile!, 'banners');

      await supabase.from('stores').upsert({
        'vendor_id': vendorId,
        'name': storeNameEn,
        'name_ar': storeNameAr,
        'category': storeCategory,
        'logo_url': uploadedLogoUrl,
        'banner_url': uploadedBannerUrl,
        'tags': tags,
        'store_area': storeArea,
        'latitude': storeLatitude,
        'longitude': storeLongitude,
        'created_at': DateTime.now().toIso8601String(),
      });


      logoUrl = uploadedLogoUrl;
      bannerUrl = uploadedBannerUrl;
      successMessage = "Store created successfully!";
      hasStore = true;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
