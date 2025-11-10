import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/customers/screens/customer_signup_screen.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/logo_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:caterfy/customers/screens/customer_home_screen.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';

class CustomerEmailLogin extends StatelessWidget {
  const CustomerEmailLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final customerAuth = Provider.of<CustomerAuthProvider>(context);
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
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            CustomTextField(
              onChanged: (v) => email = v.trim(),
              hint: 'example@gmail.com',
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'password',
                  style: TextStyle(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            PasswordTextField(
              onChanged: (v) => password = v.trim(),
              hint: ('****************'),
            ),

            if (customerAuth.logInError != null)
              Text(
                customerAuth.logInError!,
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
            (customerAuth.isLoading)
                ? const SpinKitRing(color: Colors.black)
                : AuthButton(
                    chiild: Text(
                      "Sign In",
                      style: TextStyle(color: colors.onPrimary),
                    ),
                    onPressed: () async {
                      customerAuth.setEmail(email);
                      customerAuth.setPassword(password);
                      final cSuccess = await customerAuth.logIn();

                      if (cSuccess && context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CustomerHomeScreen(),
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
                    final auth = Provider.of<CustomerAuthProvider>(
                      context,
                      listen: false,
                    );
                    auth.clearErrors();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CustomerSignUp()),
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
