import 'package:caterfy/customers/screens/customer_login/customer_login_screen.dart';
import 'package:caterfy/customers/screens/customer_login/customer_phone_auth_screen.dart';
import 'package:caterfy/shared_widgets.dart/custom_spinner.dart';
import 'package:caterfy/util/theme_controller.dart';
import 'package:caterfy/util/wavy_border_shape.dart';
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

    final topPadding = MediaQuery.of(context).padding.top + 50;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(top: topPadding),
              height: 320 + topPadding,
              width: double.infinity,
              decoration: ShapeDecoration(
                color: Color(0xfffff1ff),
                shape: WavyShapeBorder(waveHeight: 15),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  'assets/icons/auth_header_art.svg',
                  height: 250,
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 40 + bottomPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hey there!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Log in or sign up to start ordering with Caterfy!",
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (customerAuth.isGoogleLoading)
                    const Padding(
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
                      const Expanded(
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
            ),
          ),
        ],
      ),
    );
  }
}
