import 'package:caterfy/customers/screens/customer_login_screen.dart';
import 'package:caterfy/customers/screens/customer_phone_auth_screen.dart';
import 'package:caterfy/vendors/screens/vendor_login_screen.dart';
import 'package:caterfy/vendors/screens/vendor_phone_login_screen.dart';

import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/logo_appbar.dart';
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
                      builder: (context) => const VendorPhoneAuth(),
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
                      builder: (context) => const VendorEmailLogin(),
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
