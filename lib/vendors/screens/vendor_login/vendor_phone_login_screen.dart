import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/spinner.dart';
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
    final vendorAuth = Provider.of<VendorAuthProvider>(context);
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            LabeledPhoneField(
              onChanged: (phoneNumber) {},
              label: 'phone number',
            ),
            SizedBox(height: 123),
            AuthButton(
              chiild: (vendorAuth.isLoading)
                  ? Spinner()
                  : Text("Sign In", style: TextStyle(color: colors.onPrimary)),
              onPressed: () async {
                //ZEENAA create a different function for phone login forget about the BS below 👍

                // final sSuccess = await vendorAuth.logIn();

                // if (sSuccess && context.mounted) {
                //   Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //       builder: (_) => const VendorHomeScreen(),
                //     ),
                //   );
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}
