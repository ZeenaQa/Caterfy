import 'package:caterfy/sellers/providers/seller_auth_provider.dart';
import 'package:caterfy/sellers/screens/signup-screen.dart';
import 'package:caterfy/shared_widgets.dart/button-widget.dart';
import 'package:caterfy/shared_widgets.dart/logo-AppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:caterfy/sellers/screens/home-screen.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';

class SellerEmailLogin extends StatelessWidget {
  const SellerEmailLogin({super.key});

  

  @override
  Widget build(BuildContext context) {
    final sellerAuth = Provider.of<SellerAuthProvider>(context);
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

            if (sellerAuth.logInError != null)
              Text(
                sellerAuth.logInError!,
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
            (sellerAuth.isLoading)
                ? const SpinKitRing(color: Colors.black)
                : AuthButton(
                    chiild: Text(
                      "Sign In",
                      style: TextStyle(color: colors.onPrimary),
                    ),
                    onPressed: () async {
                      sellerAuth.setEmail(email);
                      sellerAuth.setPassword(password);
                      final sSuccess = await sellerAuth.logIn();

                      if (sSuccess && context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SellerHomeScreen(),
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
                    final auth = Provider.of<SellerAuthProvider>(
                      context,
                      listen: false,
                    );
                    auth.clearErrors();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SellerSignUp()),
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
