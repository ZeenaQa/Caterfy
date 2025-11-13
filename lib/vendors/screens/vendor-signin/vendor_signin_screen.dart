import 'package:caterfy/vendors/screens/vendor-signin/vendor_email_login_screen.dart';
import 'package:caterfy/vendors/screens/vendor-signin/vendor_phone_login_screen.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: TabBar(
              labelColor: colors.primary,
              unselectedLabelColor: colors.onSurface,
              labelStyle: TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
              tabs: [
                Tab(child: Text('Email')),
                Tab(child: Text('Phone')),
              ],
            ),
          ),
        ),
        body: TabBarView(children: [VendorEmailLogin(), VendorPhoneAuth()]),
      ),
    );
  }
}
