import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/customers/screens/customer_signup/customer_email_token_screen.dart';
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
    final auth = Provider.of<CustomerAuthProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(title: "Welcome to Caterfy", titleSize: 14),
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
                        'Continue with email',
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
                        hint: 'First and Last Name',
                        label: 'Name',
                        errorText: auth.nameError,
                      ),
                      SizedBox(height: 15),

                      LabeledTextField(
                        onChanged: (val) {
                          auth.clearEmailError();
                          email = val;
                        },
                        hint: 'example@gmail.com',
                        label: 'Email',
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
                        label: 'Password',
                        errorText: auth.passwordError,
                      ),
                      SizedBox(height: 15),

                      LabeledPasswordField(
                        onChanged: (val) {
                          auth.clearConfirmPassError();
                          confirmPass = val;
                        },
                        hint: '****************',
                        label: 'Confirm Password',
                        errorText: auth.confirmPasswordError,
                      ),
                      SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password must be at least 8 characters and should include:',
                              style: TextStyle(
                                color: Color(0xff868686),
                                fontSize: 11,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              '• 1 uppercase letter (A-Z)',
                              style: TextStyle(
                                color: Color(0xff868686),
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              '• 1 lowercase letter (a-z)',
                              style: TextStyle(
                                color: Color(0xff868686),
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              '• 1 number (0-9)',
                              style: TextStyle(
                                color: Color(0xff868686),
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
                title: "Sign Up",
                onPressed: () async {
                  final tempEmail = email;
                  final tempPass = password;
                  final res = await auth.signUp(
                    name: name,
                    email: email.trim(),
                    password: password,
                    confirmPassword: confirmPass,
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
    );
  }
}
