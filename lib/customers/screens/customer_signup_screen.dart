import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/customers/screens/customer_home_screen.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CustomerSignUp extends StatelessWidget {
  const CustomerSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<CustomerAuthProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),

        child: Column(
          spacing: 25,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Continue with Email",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            ),

            LabeledTextField(
              onChanged: auth.setName,
              hint: 'First and Last Name',
              label: 'Name',
              errorText: auth.nameError,
            ),

            LabeledTextField(
              onChanged: auth.setEmail,
              hint: 'example@gmail.com',
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              errorText: auth.emailError,
            ),

            LabeledPasswordField(
              onChanged: auth.setPassword,
              hint: '****************',
              label: 'Password',
              errorText: auth.passwordError,
            ),

            LabeledPasswordField(
              onChanged: auth.setConfirmPassword,
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
                      final success = await auth.signUp();
                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerHomeScreen(),
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
