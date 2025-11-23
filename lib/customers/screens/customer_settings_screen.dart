import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_dialog.dart';
import 'package:caterfy/shared_widgets.dart/settings_button.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerSettingsScreen extends StatelessWidget {
  CustomerSettingsScreen({super.key, this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    final customerAuth = Provider.of<CustomerAuthProvider>(context);
    final l10n = AppLocalizations.of(context);
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
      SettingsButton(title: l10n.accountInfo, icon: Icons.person_outline),
      SettingsButton(
        title: l10n.savedAddresses,
        icon: Icons.location_on_outlined,
      ),
      SettingsButton(title: l10n.changeEmail, icon: Icons.email_outlined),
      SettingsButton(title: l10n.changePassword, icon: Icons.key_outlined),
      SettingsButton(
        title: l10n.notifications,
        icon: Icons.notifications_outlined,
        rightText: l10n.enabled,
      ),
      SettingsButton(
        title: l10n.language,
        icon: Icons.language_outlined,
        rightText: l10n.english,
      ),
      Stack(
        children: [
          Column(
            children: [
              SettingsButton(
                title: l10n.logOut,
                onTap: () async {
                  showCustomDialog(
                    context,
                    title: l10n.logOut,
                    content: l10n.logOutConfirmation,
                    confirmText: l10n.logOut,
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
      appBar: CustomAppBar(title: title),
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
