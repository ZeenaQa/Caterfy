import 'package:caterfy/auth/auth_selection_screen.dart';
import 'package:caterfy/customers/customer_widgets/authenticated_customer.dart';
import 'package:caterfy/main.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/vendors/screens/vendor_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnBoardingSkip {
  static Future<Widget> WidgetIntApp() async {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;

    if (session == null) {
      return const SelectionScreen();
    }

    try {
      final userId = session.user.id;
      final role = session.user.userMetadata?['role'];

      dynamic fetchedUser;

      if (role == "customer") {
        fetchedUser = await supabase
            .from('customers')
            .select()
            .eq('id', userId)
            .maybeSingle();

        if (fetchedUser == null) return const SelectionScreen();
      } else if (role == "vendor") {
        fetchedUser = await supabase
            .from('vendors')
            .select()
            .eq('id', userId)
            .maybeSingle();

        if (fetchedUser == null) return const SelectionScreen();
      } else {
        return const SelectionScreen();
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = navigatorKey.currentContext;

        if (ctx != null) {
          final globalProvider = Provider.of<GlobalProvider>(
            ctx,
            listen: false,
          );

          globalProvider.setUser(fetchedUser);
        }
      });

      if (role == "customer") {
        return AuthenticatedCustomer();
      } else {
        return VendorHomeScreen();
      }
    } catch (e) {
      return const SelectionScreen();
    }
  }
}
