import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/vendors/screens/vendor_login/vendor_email_login_screen.dart';
import 'package:caterfy/vendors/screens/vendor_login/vendor_phone_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) {
          final auth = Provider.of<VendorAuthProvider>(context, listen: false);
          auth.clearErrors();
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              l10.login,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: TabBar(
                labelColor: colors.primary,
                unselectedLabelColor: colors.onSurface,
                labelStyle: TextStyle(fontWeight: FontWeight.w600),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
                tabs: [
                  Tab(child: Text(l10.email)),
                  Tab(child: Text(l10.phoneNumber)),
                ],
              ),
            ),
          ),
          body: TabBarView(children: [VendorEmailLogin(), VendorPhoneAuth()]),
        ),
      ),
    );
  }
}
