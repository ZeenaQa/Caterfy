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

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen>
    with TickerProviderStateMixin {
  late final AnimationController svgController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 580),
  );

  late final AnimationController buttonsController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  late final Animation<double> svgScale;
  late List<Animation<Offset>> slideAnimations;
  late List<Animation<double>> fadeAnimations;

  @override
  void initState() {
    super.initState();

    svgScale = Tween<double>(
      begin: -100,
      end: 0,
    ).animate(CurvedAnimation(parent: svgController, curve: Curves.ease));

    svgController.forward();

    const stagger = 0.12;

    slideAnimations = List.generate(4, (i) {
      final start = i * stagger;
      return Tween<Offset>(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: buttonsController,
          curve: Interval(start, start + 0.5, curve: Curves.easeOutCubic),
        ),
      );
    });

    fadeAnimations = List.generate(4, (i) {
      final start = i * stagger;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: buttonsController,
          curve: Interval(start, start + 0.4, curve: Curves.easeOut),
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) buttonsController.forward();
    });
  }

  @override
  void dispose() {
    svgController.dispose();
    buttonsController.dispose();
    super.dispose();
  }

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

    final List<Widget> buttons = [
      if (customerAuth.isGoogleLoading)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 3),
          child: CustomThreeLineSpinner(),
        )
      else
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
      Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Divider(color: colors.onSurfaceVariant, thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  l10n.or,
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ),
              const Expanded(child: Divider(color: Colors.grey, thickness: 1)),
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
    ];

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
                    child: AnimatedBuilder(
                      animation: svgController,
                      builder: (_, child) {
                        return Transform.translate(
                          offset: Offset(0, svgScale.value),
                          child: child,
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/icons/${isDark ? 'auth_header_art_dark.svg' : 'auth_header_art.svg'}',
                        height: 250,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
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
                  child: const Icon(Icons.settings_outlined, size: 23),
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

                  for (int i = 0; i < buttons.length; i++)
                    AnimatedBuilder(
                      animation: buttonsController,
                      builder: (_, child) {
                        return Opacity(
                          opacity: fadeAnimations[i].value,
                          child: Transform.translate(
                            offset: slideAnimations[i].value * 50,
                            child: child,
                          ),
                        );
                      },
                      child: buttons[i],
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
