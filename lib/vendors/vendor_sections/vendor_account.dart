import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_dialog.dart';
import 'package:caterfy/shared_widgets.dart/settings_button.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VendorAccountSection extends StatelessWidget {
  const VendorAccountSection({super.key});
  

  @override
  Widget build(BuildContext context) {
          final VendorAuth = Provider.of<VendorAuthProvider>(context);
              final l10 = AppLocalizations.of(context);


  Future<void> handleLogout() async {
      VendorAuth.isLoading = true;
      VendorAuth.notifyLis();

      try {
        await Future.delayed(Duration(milliseconds: 500));
        await Supabase.instance.client.auth.signOut();
      } finally {
        VendorAuth.isLoading = false;
        VendorAuth.notifyLis();
      }
    }
    return   Stack(
        children: [
          Column(
            children: [
              SettingsButton(
                title: l10.logOut,
                onTap: () async {
                  showCustomDialog(
                    context,
                    title: l10.logOut,
                    content: l10.logOutConfirmation,
                    confirmText: l10.logOut,
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
      );
  }
}
