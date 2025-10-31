import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/sellers/providers/seller_auth_provider.dart';
import 'package:caterfy/customers/screens/home-screen.dart';
import 'package:caterfy/sellers/screens/home-screen.dart';
import 'package:caterfy/customers/widgets/textfields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  String? error;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final customerAuth = Provider.of<CustomerAuthProvider>(
      context,
      listen: false,
    );
    final sellerAuth = Provider.of<SellerAuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Log In")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(labelText: "Email", onChanged: (v) => email = v),
            const SizedBox(height: 20),
            PasswordTextField(onChanged: (v) => password = v),
            const SizedBox(height: 20),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            isLoading
                ? const SpinKitWanderingCubes(color: Color(0xFF577A80))
                : ElevatedButton(
                    child: const Text("Log In"),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                        error = null;
                      });

                      customerAuth.setEmail(email);
                      customerAuth.setPassword(password);
                      final cSuccess = await customerAuth.logIn();

                      if (cSuccess) {
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CustomerHomeScreen(),
                            ),
                          );
                        }
                        return;
                      }

                      sellerAuth.setEmail(email);
                      sellerAuth.setPassword(password);
                      final sSuccess = await sellerAuth.logIn();

                      if (sSuccess) {
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SellerHomeScreen(),
                            ),
                          );
                        }
                        return;
                      }

                      setState(() {
                        error = "Invalid credentials or role mismatch";
                        isLoading = false;
                      });
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
