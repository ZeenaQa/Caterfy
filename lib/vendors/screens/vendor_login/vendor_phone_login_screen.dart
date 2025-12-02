import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';

import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class VendorPhoneAuth extends StatefulWidget {
  const VendorPhoneAuth({super.key});

  @override
  State<VendorPhoneAuth> createState() => _VendorPhoneAuthState();
}

class _VendorPhoneAuthState extends State<VendorPhoneAuth> {
  String phoneNumber = "";
  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final vendorAuth = Provider.of<VendorAuthProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            LabeledPhoneField(
              onChanged: (phoneNumber) {},
              label: l10.phoneNumber,
            ),
            SizedBox(height: 123),
            Spacer(),

            FilledBtn(
              title: l10.login,
              onPressed: () async {},
              isLoading: vendorAuth.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
