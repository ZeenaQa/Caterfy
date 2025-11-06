import 'package:caterfy/sellers/providers/seller_auth_provider.dart';
import 'package:caterfy/sellers/screens/home-screen.dart';

import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SellerSignUpScreen extends StatelessWidget {
  const SellerSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<SellerAuthProvider>(context);

    final List<String> businessTypes = [
      "Restaurant",
      "Cafe",
      "Bakery",
      "Grocery",
      "Other",
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            const Center(
              child: Text(
                "Seller Sign Up",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 131, 148, 138),
                ),
              ),
            ),
            const SizedBox(height: 40),

            CustomTextField(onChanged: auth.setName),
            const SizedBox(height: 20),

            CustomTextField(onChanged: auth.setBusinessName),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: auth.businessType.isNotEmpty ? auth.businessType : null,
              items: businessTypes
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) auth.setBusinessType(value);
              },
              decoration: const InputDecoration(
                labelText: "Business Type",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            CustomTextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: auth.setEmail,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              keyboardType: TextInputType.phone,
              onChanged: auth.setPhoneNumber,
            ),
            const SizedBox(height: 20),

            PasswordTextField(onChanged: auth.setPassword),
            const SizedBox(height: 20),

            PasswordTextField(onChanged: auth.setConfirmPassword),
            const SizedBox(height: 20),

            if (auth.signUpError != null)
              Text(
                auth.signUpError!,
                style: const TextStyle(color: Colors.red),
              ),

            if (auth.successMessage != null)
              Text(
                auth.successMessage!,
                style: const TextStyle(color: Colors.green),
              ),

            const SizedBox(height: 20),

            auth.isLoading
                ? const Center(
                    child: SpinKitWanderingCubes(color: Color(0xFF577A80)),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      final success = await auth.signUp();
                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SellerHomeScreen(),
                          ),
                        );
                      }
                    },
                    child: const Text("Sign Up"),
                  ),
          ],
        ),
      ),
    );
  }
}
