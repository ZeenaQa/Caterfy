import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/customers/customer_widgets/authenticated_customer.dart';
import 'package:caterfy/customers/screens/customer_signup_screen.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/logo_appbar.dart';
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
    final customerAuth = Provider.of<CustomerAuthProvider>(context);

    return Scaffold(
      appBar: LogoAppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              LabeledTextField(
                onChanged: (v) {
                  email = v.trim();
                  customerAuth.clearEmailError();
                },
                hint: 'example@gmail.com',
                label: 'Email',
                errorText: customerAuth.emailError,
              ),
              SizedBox(height: 20),
              LabeledPasswordField(
                onChanged: (v) {
                  password = v.trim();
                  customerAuth.clearPassError();
                },
                hint: ('****************'),
                label: 'Password',
                errorText: customerAuth.passwordError,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color(0xFF665B86),
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FilledBtn(
                title: "Sign In",
                onPressed: () async {
                  final cSuccess = await customerAuth.logIn(
                    email: email.trim(),
                    password: password,
                  );

                  if (cSuccess && context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AuthenticatedCustomer(),
                      ),
                    );
                  }
                },
                isLoading: customerAuth.isLoading,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
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
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        color: Color(0xFF665B86),
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
