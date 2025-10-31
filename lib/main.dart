import 'package:caterfy/customers/providers/auth_provider.dart';
import 'package:caterfy/role-selection-screen.dart';
import 'package:caterfy/sellers/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vnnjwcertgamqqlzygwd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZubmp3Y2VydGdhbXFxbHp5Z3dkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0NjI4MzIsImV4cCI6MjA3NzAzODgzMn0._wsV1AW3sgCQdYVw3HKOFOPQBPYVKTHv9S949ltbk3E', // ضع مفتاح المشروع هنا
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomerAuthProvider()),
        ChangeNotifierProvider(create: (_) => SellerAuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Caterfy',
        theme: ThemeData(primarySwatch: Colors.brown),
        home: const RoleSelectionScreen(),
      ),
    );
  }
}
