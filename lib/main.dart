import 'package:caterfy/auth/auth_selection_screen.dart';
import 'package:caterfy/customers/customer_widgets/authenticated_customer.dart';
import 'package:caterfy/customers/customer_widgets/unauthenticated_customer.dart';
import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/style/theme/dark_theme.dart';
import 'package:caterfy/util/session.dart';
import 'package:caterfy/util/theme_controller.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/style/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vnnjwcertgamqqlzygwd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZubmp3Y2VydGdhbXFxbHp5Z3dkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0NjI4MzIsImV4cCI6MjA3NzAzODgzMn0._wsV1AW3sgCQdYVw3HKOFOPQBPYVKTHv9S949ltbk3E',
  );

  Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
    final event = data.event;
    final session = data.session;
    final user = session?.user;

    print(user);

    if (event == AuthChangeEvent.signedIn && user != null) {
      final emailConfirmedAt = user.emailConfirmedAt;

      if (emailConfirmedAt == null) {
        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => UnauthenticatedCustomer()),
        );
      } else {
        final existing = await Supabase.instance.client
            .from('customers')
            .select()
            .eq('id', user.id)
            .maybeSingle();

        if (existing == null || existing.isEmpty) {
          await Supabase.instance.client.from('customers').insert({
            'id': user.id,
            'email': user.email,
            'name': user.userMetadata?['full_name'] ?? 'New User',
          });
        }

        Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => AuthenticatedCustomer()),
        );
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = navigatorKey.currentContext;
        if (ctx != null) {
          Provider.of<CustomerAuthProvider>(
            ctx,
            listen: false,
          ).setLoading(false);
        }
      });
    }

    if (event == AuthChangeEvent.signedOut) {
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => SelectionScreen()),
      );
    }
  });

  final entryWidget = await OnBoardingSkip.WidgetIntApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: MyApp(entryWidget: entryWidget),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget entryWidget;
  const MyApp({super.key, required this.entryWidget});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomerAuthProvider()),
        ChangeNotifierProvider(create: (_) => VendorAuthProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Caterfy',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeController.themeMode,
        home: entryWidget,
      ),
    );
  }
}
