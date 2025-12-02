import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/customers/screens/customer_signup/customer_pass_token_screen.dart';
import 'package:caterfy/customers/screens/customer_signup/customer_signup_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_spinner.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/outlined_button.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';

class CustomerEmailLogin extends StatefulWidget {
  const CustomerEmailLogin({super.key});

  @override
  State<CustomerEmailLogin> createState() => _CustomerEmailLoginState();
}

class _CustomerEmailLoginState extends State<CustomerEmailLogin> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final customerAuth = Provider.of<CustomerAuthProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(),
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
                        l10.continueWithEmail,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 23),

                      LabeledTextField(
                        onChanged: (v) {
                          email = v.trim();
                          customerAuth.clearEmailError();
                        },
                        hint: 'example@gmail.com',
                        label: l10.email,
                        errorText: customerAuth.emailError,
                      ),
                      SizedBox(height: 15),

                      LabeledPasswordField(
                        onChanged: (v) {
                          password = v.trim();
                          customerAuth.clearPassError();
                        },
                        hint: ('****************'),
                        label: l10.password,
                        errorText: customerAuth.passwordError,
                      ),

                      SizedBox(height: 11),

                      Row(
                        children: [
                          if (customerAuth.forgotPassLoading)
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: CustomThreeLineSpinner(),
                            ),
                          if (!customerAuth.forgotPassLoading)
                            OutlinedBtn(
                              onPressed: () async {
                                final tempEmail = email;
                                final res = await customerAuth
                                    .sendForgotPasswordPassEmail(
                                      email: email,
                                      context: context,
                                    );

                                if (res['success'] && context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerPassTokenScreen(
                                            email: tempEmail,
                                          ),
                                    ),
                                  );
                                }
                              },
                              title: l10.forgotPassword,
                              titleSize: 13,
                              lighterBorder: true,
                            ),

                          Spacer(),
                          OutlinedBtn(
                            onPressed: () {
                              final auth = Provider.of<CustomerAuthProvider>(
                                context,
                                listen: false,
                              );
                              auth.clearErrors();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CustomerSignUp(),
                                ),
                              );
                            },
                            title: l10.createAccount,
                            titleSize: 13,
                            lighterBorder: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              FilledBtn(
                title: l10.login,
                onPressed: () async {
                  await customerAuth.logIn(
                    email: email.trim(),
                    password: password,
                    context: context,
                  );
                },
                isLoading: customerAuth.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
