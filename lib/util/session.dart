import 'package:caterfy/auth/auth_selection_screen.dart';
import 'package:caterfy/util/initial_loader_screen.dart';
import 'package:flutter/material.dart';
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

      final entryData = {'role': role, 'fetchedUser': fetchedUser};

      // Return a new widget responsible for setting state and navigating
      return InitialLoaderScreen(entryData: entryData);
    } catch (e) {
      return const SelectionScreen();
    }
  }
}
