import 'package:caterfy/util/l10n_helper.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/vendors/screens/vendor_login/vendor_email_login_screen.dart';
import 'package:caterfy/vendors/screens/vendor_login/vendor_phone_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return PopScope(
      canPop: true, // allow popping
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
              L10n.t.login,
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
                  Tab(child: Text(L10n.t.email)),
                  Tab(child: Text(L10n.t.phoneNumber)),
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
