import 'package:caterfy/shared_widgets.dart/custom_spinner.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/outlined_button.dart';
import 'package:caterfy/util/l10n_helper.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/vendors/screens/vendor_signup/personal_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';

class VendorEmailLogin extends StatefulWidget {
  const VendorEmailLogin({super.key});

  @override
  State<VendorEmailLogin> createState() => _VendorEmailLoginState();
}

class _VendorEmailLoginState extends State<VendorEmailLogin> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final vendorAuth = Provider.of<VendorAuthProvider>(context);
    

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        L10n.t.continueWithEmail,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 23),

                      LabeledTextField(
                        onChanged: (v) {
                          email = v.trim();
                          vendorAuth.clearEmailError();
                        },
                        hint: 'example@gmail.com',
                        label: L10n.t.email,
                        errorText: vendorAuth.emailError,
                      ),
                      SizedBox(height: 15),

                      LabeledPasswordField(
                        onChanged: (v) {
                          password = v.trim();
                          vendorAuth.clearPassError();
                        },
                        hint: ('****************'),
                        label: L10n.t.password,
                        errorText: vendorAuth.passwordError,
                      ),

                      SizedBox(height: 11),

                      Row(
                        children: [
                          if (vendorAuth.forgotPassLoading)
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: CustomThreeLineSpinner(),
                            ),

                          if (!vendorAuth.forgotPassLoading)
                            OutlinedBtn(
                              onPressed: () {},
                              title: L10n.t.forgotPassword,
                              titleSize: 13,
                              lighterBorder: true,
                            ),

                          Spacer(),

                          OutlinedBtn(
                            onPressed: () {
                              vendorAuth.clearErrors();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const VendorPersonalInfo(),
                                ),
                              );
                            },
                            title: L10n.t.becomeVendor,
                            titleSize: 13,
                            lighterBorder: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),

              FilledBtn(
                title: L10n.t.login,
                onPressed: () async {
                  await vendorAuth.logIn(
                    email: email.trim(),
                    password: password,
                    context: context,
                  );
                },
                isLoading: vendorAuth.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
