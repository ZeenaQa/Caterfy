import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerPhoneAuth extends StatefulWidget {
  const CustomerPhoneAuth({super.key});

  @override
  State<CustomerPhoneAuth> createState() => _CustomerPhoneAuthState();
}

class _CustomerPhoneAuthState extends State<CustomerPhoneAuth> {
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final customerAuth = Provider.of<CustomerAuthProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LabeledPhoneField(
              label: l10.phoneNumber,
              onChanged: (value) {
                phoneNumber = value.trim();
                customerAuth.phoneNumberError = null;
              },
              errorText: customerAuth.phoneNumberError,
            ),

            SizedBox(height: 20),
            Spacer(),
            FilledBtn(
              title: l10.continueBtn,
              isLoading: customerAuth.isLoading,
              onPressed: () async {
                final auth = Provider.of<CustomerAuthProvider>(
                  context,
                  listen: false,
                );

                final success = await auth.signUpOrSignInWithPhone(
                  phoneNumber: phoneNumber,
                  context: context,
                );

                if (!success) return;
              },
            ),
          ],
        ),
      ),
    );
  }
}
