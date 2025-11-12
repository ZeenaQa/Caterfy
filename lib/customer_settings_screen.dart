import 'package:caterfy/settings_button.dart';
import 'package:caterfy/shared_widgets.dart/logo_appbar.dart';
import 'package:flutter/material.dart';

class CustomerSettingsScreen extends StatelessWidget {
  CustomerSettingsScreen({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
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
      SettingsButton(
        title: 'Log out',
        icon: Icons.logout_outlined,
        isLastItem: true,
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
