import 'package:caterfy/customers/screens/login-screen.dart';
import 'package:caterfy/sellers/screens/login-screen.dart';
import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Choose Your Role",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CustomerLoginScreen(role: "buyer"),
                  ),
                );
              },
              child: const Text("I am a Buyer"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SellerLoginScreen(role: "seller"),
                  ),
                );
              },
              child: const Text("I am a Seller"),
            ),
          ],
        ),
      ),
    );
  }
}
