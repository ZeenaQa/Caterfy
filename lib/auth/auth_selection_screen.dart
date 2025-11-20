import 'package:caterfy/customers/screens/customer_login/customer_login_screen.dart';
import 'package:caterfy/customers/screens/customer_login/customer_phone_auth_screen.dart';
import 'package:caterfy/shared_widgets.dart/custom_spinner.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/vendors/screens/vendor_login/vendor_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../shared_widgets.dart/outlined_button.dart';

import '../../customers/providers/customer_auth_provider.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final vendorAuth = Provider.of<VendorAuthProvider>(context);
    final customerAuth = Provider.of<CustomerAuthProvider>(context);
    void handleNavigation(String dest) {
      if (customerAuth.isGoogleLoading) return;
      vendorAuth.clearErrors();
      customerAuth.clearErrors();
      final customerProvider = Provider.of<CustomerAuthProvider>(
        context,
        listen: false,
      );

      if (dest == "google") {
        customerProvider.signInWithGoogle(context);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => dest == "email"
                ? CustomerEmailLogin()
                : dest == "phone"
                ? CustomerPhoneAuth()
                : dest == "vendor"
                ? SignInPage()
                : CustomerEmailLogin(),
          ),
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SvgPicture.asset('assets/icons/rounded_logo.svg', height: 80),
                  SizedBox(height: 20),
                  Text(
                    "Welcome\nto Caterfy",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff00005f),
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Hey there!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Log in or sign up to start ordering with Caterfy!",
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 30),
                  if (customerAuth.isGoogleLoading)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: CustomThreeLineSpinner(),
                    ),
                  if (!customerAuth.isGoogleLoading)
                    OutlinedBtn(
                      title: "Continue with Google",
                      onPressed: () => handleNavigation("google"),
                      bottomPadding: 8,
                      customSvgIcon: SvgPicture.asset(
                        'assets/icons/google_colored.svg',
                        height: 18,
                      ),
                    ),
                  OutlinedBtn(
                    title: "Continue with email",
                    onPressed: () => handleNavigation("email"),
                    bottomPadding: 8,
                    icon: Icons.email_outlined,
                  ),
                  OutlinedBtn(
                    title: "Continue with phone number",
                    onPressed: () => handleNavigation("phone"),
                    bottomPadding: 20,
                    icon: Icons.phone_outlined,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          color: colors.onSurfaceVariant,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'OR',
                          style: TextStyle(color: colors.onSurfaceVariant),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                    ],
                  ),
                  OutlinedBtn(
                    title: "Continue as vendor",
                    onPressed: () => handleNavigation("vendor"),
                    topPadding: 18,
                    bottomPadding: 20,
                    icon: Icons.store_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
