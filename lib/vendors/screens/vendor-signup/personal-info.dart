import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/vendors/screens/vendor-signup/buisness-info.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class VendorPersonalInfo extends StatelessWidget {
  const VendorPersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<VendorAuthProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 25,
          children: [
            const SizedBox(height: 60),
            const Center(
              child: Text(
                "Vendor Sign Up",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
              ),
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
            LabeledPhoneField(
              label: "Phone",
              hintText: "Enter your phone",
              onChanged: auth.setPhoneNumber,
              errorText: auth.phoneError,
            ),

            // LabeledPasswordField(
            //   onChanged: auth.setPassword,
            //   hint: '****************',
            //   label: 'Password',
            //   errorText: auth.passwordError,
            // ),
            // LabeledPasswordField(
            //   onChanged: auth.setConfirmPassword,
            //   hint: '****************',
            //   label: 'Confirm Password',
            //   errorText: auth.confirmPasswordError,
            // ),
            if (auth.signUpError != null)
              Text(
                auth.signUpError!,
                style: const TextStyle(color: Colors.red),
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
                : Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 300),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    VendorBuisnessInfo(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  final tween = Tween(begin: begin, end: end);
                                  final offsetAnimation = animation.drive(
                                    tween,
                                  );

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                          ),
                        );
                      },
                      child: const Text("Next"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
