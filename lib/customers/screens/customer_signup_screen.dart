import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/customers/customer_widgets/authenticated_customer.dart';
import 'package:caterfy/shared_widgets.dart/logo_appbar.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
      resizeToAvoidBottomInset: true,
      appBar: LogoAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),

        child: Column(
          spacing: 25,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Continue with Email",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            ),

            LabeledTextField(
              onChanged: (val) => setState(() {
                auth.clearNameError();
                name = val;
              }),
              hint: 'First and Last Name',
              label: 'Name',
              errorText: auth.nameError,
            ),

            LabeledTextField(
              onChanged: (val) => setState(() {
                auth.clearEmailError();
                email = val;
              }),
              hint: 'example@gmail.com',
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              errorText: auth.emailError,
            ),

            LabeledPasswordField(
              onChanged: (val) => setState(() {
                auth.clearPassError();
                password = val;
              }),
              hint: '****************',
              label: 'Password',
              errorText: auth.passwordError,
            ),

            LabeledPasswordField(
              onChanged: (val) => setState(() {
                auth.clearConfirmPassError();
                confirmPass = val;
              }),
              hint: '****************',
              label: 'Confirm Password',
              errorText: auth.confirmPasswordError,
            ),
            if (auth.successMessage != null)
              Text(
                auth.successMessage!,
                style: const TextStyle(color: Colors.green),
              ),

            auth.isLoading
                ? const Center(
                    child: SpinKitWanderingCubes(color: Color(0xFF577A80)),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      final success = await auth.signUp(
                        name: name,
                        email: email.trim(),
                        password: password,
                        confirmPassword: confirmPass,
                      );
                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthenticatedCustomer(),
                          ),
                        );
                      }
                    },
                    child: const Text("Sign Up"),
                  ),
          ],
        ),
      ),
    );
  }
}
