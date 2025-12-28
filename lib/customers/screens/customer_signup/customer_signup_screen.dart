import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/customers/screens/customer_signup/customer_email_token_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class CustomerSignUp extends StatefulWidget {
  const CustomerSignUp({super.key});

  @override
  State<CustomerSignUp> createState() => _CustomerSignUpState();
}

class _CustomerSignUpState extends State<CustomerSignUp> {
  String name = '';
  String email = '';
  String password = '';
  String confirmPass = '';
  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final auth = Provider.of<CustomerAuthProvider>(context);

    final colors = Theme.of(context).colorScheme;
    return WillPopScope(
      onWillPop: () async {
    context.read<CustomerAuthProvider>().clearErrors();
    return true;
  },
      child: Scaffold(
        appBar: CustomAppBar(titleSize: 14),
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
                          l10.joinCaterfy,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
      
                        LabeledTextField(
                          onChanged: (val) {
                            auth.clearNameError();
                            name = val;
                          },
                          hint: l10.firstLastName,
                          label: l10.name,
                          errorText: auth.nameError,
                        ),
                        SizedBox(height: 15),
      
                        LabeledTextField(
                          onChanged: (val) {
                            auth.clearEmailError();
                            email = val;
                          },
                          hint: 'example@gmail.com',
                          label: l10.email,
                          keyboardType: TextInputType.emailAddress,
                          errorText: auth.emailError,
                        ),
                        SizedBox(height: 15),
      
                        LabeledPasswordField(
                          onChanged: (val) {
                            auth.clearPassError();
                            password = val;
                          },
                          hint: '****************',
                          label: l10.password,
                          errorText: auth.passwordError,
                        ),
                        SizedBox(height: 15),
      
                        LabeledPasswordField(
                          onChanged: (val) {
                            auth.clearConfirmPassError();
                            confirmPass = val;
                          },
                          hint: '****************',
                          label: l10.confirmPassword,
                          errorText: auth.confirmPasswordError,
                        ),
                        SizedBox(height: 10),
      
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10.passwordRequirementTitle,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                l10.passwordRequirementUppercase,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                l10.passwordRequirementLowercase,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                l10.passwordRequirementNumber,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                FilledBtn(
                  title: l10.signup,
                  onPressed: () async {
                    final tempEmail = email;
                    final tempPass = password;
                    final res = await auth.signUp(
                      name: name,
                      email: email.trim(),
                      password: password,
                      confirmPassword: confirmPass,
                      context: context,
                    );
                    if (res['success'] && context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerSignupTokenScreen(
                            email: tempEmail,
                            password: tempPass,
                          ),
                        ),
                      );
                    }
                  },
                  isLoading: auth.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
