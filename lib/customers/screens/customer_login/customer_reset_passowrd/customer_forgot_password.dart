import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String email = '';

  @override
  Widget build(BuildContext context) {
    final customerAuth = Provider.of<CustomerAuthProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        customerAuth.clearEmailError();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Forgot Password")),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              LabeledTextField(
                onChanged: (value) {
                  email = value;
                  customerAuth.clearEmailError();
                },
                hint: 'example@gmail.com',
                label: 'Email',
                errorText: customerAuth.emailError,
              ),
              const SizedBox(height: 20),
              FilledBtn(
                title: 'Continue',
                onPressed: () async {
                  if (!customerAuth.isLoading) {
                    await customerAuth.sendResetPasswordEmail(email, context);
                  }
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
