import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/shared_widgets.dart/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

class LoggedCustomerProvider with ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<Store> _stores = [];
  bool isFoodLoading = false;

  List<Store> get stores => _stores;

  Future<void> fetchStores({
    required String category,
    required BuildContext context,
  }) async {
    final l10 = AppLocalizations.of(context);
    try {
      isFoodLoading = true;
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
      Future.delayed(Duration(milliseconds: 100), () {
        isFoodLoading = false;
        notifyListeners();
      });
    }
  }
}
