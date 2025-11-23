import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/vendors/screens/vendor_home_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({
    super.key,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.selectedBusiness,
    required this.businessName,
  });

  final String name;
  final String email;
  final String phoneNumber;
  final String selectedBusiness;
  final String businessName;

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  String password = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<VendorAuthProvider>(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 25,

            children: [
              const SizedBox(height: 60),

              Center(
                child: Text(
                  l10n.setYourPassword,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              LabeledPasswordField(
                onChanged: (v) {
                  password = v;
                  auth.clearPassError();
                },
                hint: '****************',
                label: l10n.password,
                errorText: auth.passwordError,
              ),
              LabeledPasswordField(
                onChanged: (v) {
                  confirmPassword = v;
                  auth.clearConfirmPassError();
                },
                hint: '****************',
                label: l10n.confirmPassword,
                errorText: auth.confirmPasswordError,
              ),
              FilledBtn(
                title: l10n.signup,
                onPressed: () async {
                  if (auth.validatePasswordInfo(
                    password: password,
                    confirmPassword: confirmPassword,
                  )) {
                    print("nice");
                    final success = await auth.signUp(
                      onlyPassword: true,
                      email: widget.email,
                      name: widget.name,
                      password: password,
                      confirmPassword: confirmPassword,
                      phoneNumber: widget.phoneNumber,
                      businessName: widget.businessName,
                      businessType: widget.selectedBusiness,
                    );
                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VendorHomeScreen(),
                        ),
                      );
                    }
                  }
                },
                isLoading: auth.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
