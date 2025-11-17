import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/shared_widgets.dart/dialog_box.dart';
import 'package:caterfy/shared_widgets.dart/settings_button.dart';
import 'package:caterfy/shared_widgets.dart/logo_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerSettingsScreen extends StatelessWidget {
  CustomerSettingsScreen({super.key, this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    final customerAuth = Provider.of<CustomerAuthProvider>(context);
    Future<void> handleLogout() async {
      customerAuth.isLoading = true;
      customerAuth.notifyLis();

      try {
        await Future.delayed(Duration(milliseconds: 500));
        await Supabase.instance.client.auth.signOut();
      } finally {
        customerAuth.isLoading = false;
        customerAuth.notifyLis();
      }
    }

    final List<Widget> items = [
      SizedBox(height: 10),
      SettingsButton(title: 'Account info', icon: Icons.person_outline),
      SettingsButton(
        title: 'Saved addresses',
        icon: Icons.location_on_outlined,
      ),
      SettingsButton(title: 'Change email', icon: Icons.email_outlined),
      SettingsButton(title: 'Change password', icon: Icons.key_outlined),
      SettingsButton(
        title: 'Notifications',
        icon: Icons.notifications_outlined,
        rightText: 'Enabled',
      ),
      SettingsButton(
        title: 'Language',
        icon: Icons.language_outlined,
        rightText: "English",
      ),
      Stack(
        children: [
          Column(
            children: [
              SettingsButton(
                title: 'Log out',
                onTap: () async {
                  showMyDialog(
                    context,
                    title: "Log out",
                    content: "Are you sure you want to log out?",
                    confirmText: "Log out",
                    onConfirmAsync: handleLogout,
                    popAfterAsync: false,
                  );
                },
                icon: Icons.logout_outlined,
                isLastItem: true,
              ),
            ],
          ),
        ],
      ),
    ];
    return Scaffold(
      appBar: LogoAppBar(title: title),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 19),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) => items[index],
      ),
    );
  }
}
