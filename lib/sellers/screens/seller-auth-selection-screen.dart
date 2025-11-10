import 'package:caterfy/customers/screens/login_screen.dart';
import 'package:caterfy/customers/screens/phone-auth-screen.dart';
import 'package:caterfy/sellers/screens/login-screen.dart';
import 'package:caterfy/sellers/screens/phone-auth-screen.dart';

import 'package:caterfy/shared_widgets.dart/button-widget.dart';
import 'package:caterfy/shared_widgets.dart/logo-AppBar.dart';
import 'package:flutter/material.dart';

class VendorSelectionScreen extends StatelessWidget {
  const VendorSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogoAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15,
            children: [
              AuthButton(
                chiild: Text('Continue with phone number'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SellerPhoneAuth(),
                    ),
                  );
                },
              ),
              AuthButton(
                chiild: Text('Continue with email'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SellerEmailLogin(),
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
