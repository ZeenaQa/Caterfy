import 'package:caterfy/shared_widgets.dart/spinner.dart';
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
                "Personal Information",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
              ),
            ),

            LabeledTextField(
              onChanged: (v) => setState(() {
                name = v;
<<<<<<< HEAD
                auth.clearNameError();
=======
<<<<<<< HEAD
=======
                auth.clearNameError();
>>>>>>> ab6d47e (Implement Google Sign-In login feature)
>>>>>>> save-google-signin
              }),
              hint: 'First and Last Name',
              label: 'Name',
              errorText: auth.nameError,
            ),

            LabeledTextField(
              onChanged: (v) => setState(() {
                email = v;
<<<<<<< HEAD
                auth.clearEmailError();
=======
<<<<<<< HEAD
=======
                auth.clearEmailError();
>>>>>>> ab6d47e (Implement Google Sign-In login feature)
>>>>>>> save-google-signin
              }),
              hint: 'example@gmail.com',
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              errorText: auth.emailError,
            ),
            LabeledPhoneField(
              onChanged: (v) => setState(() {
                phoneNumber = v;
<<<<<<< HEAD
                auth.clearErrors();
=======
<<<<<<< HEAD
=======
                auth.clearErrors();
>>>>>>> ab6d47e (Implement Google Sign-In login feature)
>>>>>>> save-google-signin
              }),
              label: "Phone",
              hintText: "Enter your phone",
              errorText: auth.phoneError,
            ),

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
                ? const Center(child: Spinner())
                : Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (auth.validatePersonalInfo(
                          email: email.trim(),
                          name: name.trim(),
                          phoneNumber: phoneNumber.trim(),
                        )) {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 300),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      VendorBuisnessInfo(
                                        name: name,
                                        email: email,
                                        phoneNumber: phoneNumber,
                                      ),
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
                        }
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
