import 'package:caterfy/auth/auth_selection_screen.dart';
import 'package:caterfy/customers/customer_widgets/authenticated_customer.dart';
import 'package:caterfy/vendors/screens/vendor_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnBoardingSkip {
  static Future<Widget> WidgetIntApp() async {
    // final prefs = await SharedPreferences.getInstance();
    // final seenWelcome = prefs.getBool("boarding") ?? false;
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;

    // if (!seenWelcome) {
    //   return const WelcomeScreen();
    // }

    if (session == null) {
      return const SelectionScreen();
    }

    try {
      final userId = session.user.id;

      final customer = await supabase
          .from('customers')
          .select('id')
          .eq('id', userId)
          .maybeSingle();

      if (customer != null) {
        return AuthenticatedCustomer();
      }

      final vendor = await supabase
          .from('vendors')
          .select('id')
          .eq('id', userId)
          .maybeSingle();

      if (vendor != null) {
        return VendorHomeScreen();
      }

      return const SelectionScreen();
    } catch (e) {
      print("Error checking user type: $e");
      return const SelectionScreen();
    }
  }
}
