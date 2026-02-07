import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';

import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/vendors/screens/vendor_signup/buisness_info.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class VendorPersonalInfo extends StatefulWidget {
  const VendorPersonalInfo({
    super.key,
    required this.storeType,
  });

  final String storeType;

  @override
  State<VendorPersonalInfo> createState() => _VendorPersonalInfoState();
}

class _VendorPersonalInfoState extends State<VendorPersonalInfo> {
  String name = '';
  String email = '';
  String phoneNumber = '';

  void handleNext(auth, l10) {
    if (auth.validatePersonalInfo(
      email: email.trim(),
      name: name.trim(),
      phoneNumber: phoneNumber.trim(),
      l10: l10,
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
                storeType: widget.storeType,
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
    final l10 = AppLocalizations.of(context);
    final auth = Provider.of<VendorAuthProvider>(context);

    return PopScope(
      canPop: true, // allow popping
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) {
          final auth = Provider.of<VendorAuthProvider>(context, listen: false);
          auth.clearErrors();
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: l10.becomeVendor),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10.personalInformation,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 23),

                LabeledTextField(
                  onChanged: (v) {
                    name = v;
                    auth.clearNameError();
                  },
                  hint: l10.firstLastName,
                  label: l10.name,
                  errorText: auth.nameError,
                ),
                SizedBox(height: 15),
                LabeledTextField(
                  onChanged: (v) {
                    email = v;
                    auth.clearEmailError();
                  },
                  hint: 'example@gmail.com',
                  label: l10.email,
                  keyboardType: TextInputType.emailAddress,
                  errorText: auth.emailError,
                ),
                SizedBox(height: 15),
                LabeledPhoneField(
                  onChanged: (v) {
                    phoneNumber = v;
                    auth.clearErrors();
                  },
                  label: l10.phoneNumber,
                  hintText: "Enter your phone",
                  errorText: auth.phoneError,
                ),
                SizedBox(height: 11),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledBtn(
                    onPressed: () => handleNext(auth, l10),
                    title: l10.next,
                    stretch: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
