import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/util/theme_controller.dart';
import 'package:caterfy/vendors/vendor_sections/vendor_account.dart';
import 'package:caterfy/vendors/vendor_sections/vendor_orders.dart';
import 'package:caterfy/vendors/vendor_sections/vstore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AuthenticatedVendor extends StatefulWidget {
  const AuthenticatedVendor({super.key});

  @override
  State<AuthenticatedVendor> createState() => AuthenticatedVendorState();
}

class AuthenticatedVendorState extends State<AuthenticatedVendor> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Vstore(),
    VendorOrdersSection(),
    VendorAccountSection(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final themeController = context.watch<ThemeController>();
    final isDark = themeController.themeMode == ThemeMode.dark;

    return AnnotatedRegion(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.transparent
                    : Color.fromARGB(66, 226, 226, 226),
                blurRadius: 6,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: TextStyle(fontSize: 12, height: 2),
              unselectedLabelStyle: TextStyle(fontSize: 12, height: 2),
              backgroundColor: colors.surface,
              iconSize: 20,
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 1),
                    child: Icon(Icons.storefront),
                  ),
                  label: l10.store,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 1),
                    child: Icon(Icons.receipt_outlined),
                  ),
                  label: l10.orders,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 1),
                    child: Icon(Icons.menu),
                  ),
                  label: l10.more,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
