import 'package:caterfy/auth/auth_settings_screen.dart';
import 'package:caterfy/customers/screens/customer_login/customer_login_screen.dart';
import 'package:caterfy/customers/screens/customer_login/customer_phone_auth_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
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
    final themeController = context.watch<ThemeController>();
    final isDark = themeController.themeMode == ThemeMode.dark;
    final colors = Theme.of(context).colorScheme;
    final vendorAuth = Provider.of<VendorAuthProvider>(context);
    final customerAuth = Provider.of<CustomerAuthProvider>(context);
    final l10n = AppLocalizations.of(context);

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
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: topPadding),
                  height: 320 + topPadding,
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: colors.onPrimaryFixedVariant,
                    shape: WavyShapeBorder(waveHeight: 15),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/${isDark ? 'auth_header_art_dark.svg' : 'auth_header_art.svg'}',
                          height: 250,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AuthSettingsScreen()),
                      );
                    },
                    child: Icon(Icons.settings_outlined, size: 23),
                  ),
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
                    l10n.heyThere,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.welcomeInstruction,
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
                      title: l10n.continueWithGoogle,
                      onPressed: () => handleNavigation("google"),
                      bottomPadding: 8,
                      customSvgIcon: SvgPicture.asset(
                        'assets/icons/google_colored.svg',
                        height: 18,
                      ),
                    ),
                  OutlinedBtn(
                    title: l10n.continueWithEmail,
                    onPressed: () => handleNavigation("email"),
                    bottomPadding: 8,
                    icon: Icons.email_outlined,
                  ),
                  OutlinedBtn(
                    title: l10n.continueWithPhoneNumber,
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
                          l10n.or,
                          style: TextStyle(color: colors.onSurfaceVariant),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                    ],
                  ),
                  OutlinedBtn(
                    title: l10n.continueAsVendor,
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
