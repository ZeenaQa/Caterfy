import 'package:caterfy/shared_widgets.dart/spinner.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/vendors/screens/vendor_signup/personal_info.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:caterfy/vendors/screens/vendor_home_screen.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';

class VendorEmailLogin extends StatefulWidget {
  const VendorEmailLogin({super.key});

  @override
  State<VendorEmailLogin> createState() => _VendorEmailLoginState();
}

class _VendorEmailLoginState extends State<VendorEmailLogin> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final vendorAuth = Provider.of<VendorAuthProvider>(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 5,
          children: [
            LabeledTextField(
              onChanged: (v) => setState(() {
                email = v;
                vendorAuth.clearEmailError();
              }),
              hint: 'example@gmail.com',
              label: 'Email',
              errorText: vendorAuth.emailError,
            ),
            SizedBox(height: 20),

            LabeledPasswordField(
              onChanged: (v) => setState(() {
                password = v;
                vendorAuth.clearPassError();
              }),
              hint: ('****************'),
              label: 'Passowrd',
              errorText: vendorAuth.passwordError,
            ),

            if (vendorAuth.logInError != null)
              Text(
                vendorAuth.logInError!,
                style: TextStyle(
                  color: colors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Color(0xFF665B86),
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AuthButton(
              chiild: (vendorAuth.isLoading)
                  ? Spinner()
                  : Text("Sign In", style: TextStyle(color: colors.onPrimary)),

              onPressed: () async {
                final sSuccess = await vendorAuth.logIn(
                  email: email.trim(),
                  password: password,
                );

                if (sSuccess && context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const VendorHomeScreen()),
                  );
                }
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    final auth = Provider.of<VendorAuthProvider>(
                      context,
                      listen: false,
                    );
                    auth.clearErrors();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VendorPersonalInfo(),
                      ),
                    );
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: Color(0xFF665B86),
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
