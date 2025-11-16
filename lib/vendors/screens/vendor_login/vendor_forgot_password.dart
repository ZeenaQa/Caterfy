import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/logo_appbar.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorForgotPassword extends StatefulWidget {
  const VendorForgotPassword({super.key});

  @override
  State<VendorForgotPassword> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<VendorForgotPassword> {
  String email = '';

  @override
  Widget build(BuildContext context) {
    final vendorAuth = Provider.of<CustomerAuthProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        vendorAuth.clearEmailError();
        return true;
      },
      child: Scaffold(
        appBar: LogoAppBar(title: 'Forgot Password'),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              LabeledTextField(
                onChanged: (value) {
                  email = value;
                  vendorAuth.clearEmailError();
                },
                hint: 'example@gmail.com',
                label: 'Email',
                errorText: vendorAuth.emailError,
              ),
              const SizedBox(height: 20),
              FilledBtn(
                title: 'Continue',
                onPressed: () async {
                  if (!vendorAuth.isLoading) {
                    await vendorAuth.sendResetPasswordEmail(email, context);
                  }
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
