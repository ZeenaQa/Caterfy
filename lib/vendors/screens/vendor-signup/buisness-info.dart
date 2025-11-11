import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/vendors/screens/vendor_home_screen.dart';

import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class VendorBuisnessInfo extends StatelessWidget {
  const VendorBuisnessInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<VendorAuthProvider>(context);

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
                "Vendor Sign Up",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 131, 148, 138),
                ),
              ),
            ),

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
                            builder: (context) => VendorHomeScreen(),
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
