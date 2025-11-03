import 'package:caterfy/customers/screens/signup-screen.dart';
import 'package:caterfy/sellers/screens/signup-screen.dart';

import 'package:caterfy/shared_widgets.dart/button-widget.dart';
import 'package:caterfy/shared_widgets.dart/logo-AppBar.dart';
import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogoAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthButton(
                chiild: const Text("Sign Up as Customer"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CustomerSignUpScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              AuthButton(
                chiild: const Text("Sign Up as Vendor"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SellerSignUpScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
