import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/vendors/screens/vendor-signup/personal-info.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/logo_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:caterfy/vendors/screens/vendor_home_screen.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';

class VendorEmailLogin extends StatelessWidget {
  const VendorEmailLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final vendorAuth = Provider.of<VendorAuthProvider>(context);
    final colors = Theme.of(context).colorScheme;
    String email = '';
    String password = '';

    return Scaffold(
      appBar: LogoAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: [
            LabeledTextField(
              onChanged: (v) => email = v.trim(),
              hint: 'example@gmail.com',
              label: 'Email',
              // errorText: auth.nameError,
            ),
            SizedBox(height: 20),

            LabeledPasswordField(
              onChanged: (v) => password = v.trim(),
              hint: ('****************'),
              label: 'Passowrd',
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
            (vendorAuth.isLoading)
                ? const SpinKitRing(color: Colors.black)
                : AuthButton(
                    chiild: Text(
                      "Sign In",
                      style: TextStyle(color: colors.onPrimary),
                    ),
                    onPressed: () async {
                      vendorAuth.setEmail(email);
                      vendorAuth.setPassword(password);
                      final sSuccess = await vendorAuth.logIn();

                      if (sSuccess && context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VendorHomeScreen(),
                          ),
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
