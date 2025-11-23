import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/vendors/screens/vendor_signup/buisness_info.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class VendorPersonalInfo extends StatefulWidget {
  const VendorPersonalInfo({super.key});

  @override
  State<VendorPersonalInfo> createState() => _VendorPersonalInfoState();
}

class _VendorPersonalInfoState extends State<VendorPersonalInfo> {
  String name = '';
  String email = '';
  String phoneNumber = '';

  void handleNext(auth) {
    if (auth.validatePersonalInfo(
      email: email.trim(),
      name: name.trim(),
      phoneNumber: phoneNumber.trim(),
    )) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) =>
              VendorBuisnessInfo(
                name: name,
                email: email,
                phoneNumber: phoneNumber,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<VendorAuthProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        final auth = Provider.of<VendorAuthProvider>(context, listen: false);
        auth.clearErrors();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 25,
            children: [
              const SizedBox(height: 60),

              Center(
                child: Text(
                  l10n.personalInformation,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ),

              LabeledTextField(
                onChanged: (v) {
                  name = v;
                  auth.clearNameError();
                },
                hint: l10n.firstLastName,
                label: l10n.name,
                errorText: auth.nameError,
              ),

              LabeledTextField(
                onChanged: (v) {
                  email = v;
                  auth.clearEmailError();
                },
                hint: 'example@gmail.com',
                label: l10n.email,
                keyboardType: TextInputType.emailAddress,
                errorText: auth.emailError,
              ),
              LabeledPhoneField(
                onChanged: (v) {
                  phoneNumber = v;
                  auth.clearErrors();
                },
                label: l10n.phoneNumber,
                hintText: "Enter your phone",
                errorText: auth.phoneError,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: FilledBtn(
                  onPressed: () => handleNext(auth),
                  title: l10n.next,
                  stretch: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
