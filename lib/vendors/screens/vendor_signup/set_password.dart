<<<<<<< HEAD
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/spinner.dart';
=======
<<<<<<< HEAD
=======
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/spinner.dart';
>>>>>>> ab6d47e (Implement Google Sign-In login feature)
>>>>>>> save-google-signin
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/vendors/screens/vendor_home_screen.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD

=======
<<<<<<< HEAD
import 'package:flutter_spinkit/flutter_spinkit.dart';
=======

>>>>>>> ab6d47e (Implement Google Sign-In login feature)
>>>>>>> save-google-signin
import 'package:provider/provider.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({
    super.key,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.selectedBusiness,
    required this.businessName,
  });

  final String name;
  final String email;
  final String phoneNumber;
  final String selectedBusiness;
  final String businessName;

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  String password = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<VendorAuthProvider>(context);
<<<<<<< HEAD
    final colors = Theme.of(context).colorScheme;
=======
<<<<<<< HEAD
=======
    final colors = Theme.of(context).colorScheme;
>>>>>>> ab6d47e (Implement Google Sign-In login feature)
>>>>>>> save-google-signin
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 25,

            children: [
              const SizedBox(height: 60),

              const Center(
                child: Text(
                  "Set your Password",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                ),
              ),
              LabeledPasswordField(
                onChanged: (v) => setState(() {
                  password = v;
<<<<<<< HEAD
                  auth.clearPassError();
=======
<<<<<<< HEAD
=======
                  auth.clearPassError();
>>>>>>> ab6d47e (Implement Google Sign-In login feature)
>>>>>>> save-google-signin
                }),
                hint: '****************',
                label: 'Password',
                errorText: auth.passwordError,
              ),
              LabeledPasswordField(
                onChanged: (v) => setState(() {
                  confirmPassword = v;
<<<<<<< HEAD
                  auth.clearConfirmPassError();
=======
<<<<<<< HEAD
=======
                  auth.clearConfirmPassError();
>>>>>>> ab6d47e (Implement Google Sign-In login feature)
>>>>>>> save-google-signin
                }),
                hint: '****************',
                label: 'Confirm Password',
                errorText: auth.confirmPasswordError,
              ),
<<<<<<< HEAD
=======
<<<<<<< HEAD
              auth.isLoading
                  ? const Center(
                      child: SpinKitWanderingCubes(color: Color(0xFF577A80)),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (auth.validatePasswordInfo(
                          password: password,
                          confirmPassword: confirmPassword,
                        )) {
                          final success = await auth.signUp(
                            onlyPassword: true,
                            email: widget.email,
                            name: widget.name,
                            password: password,
                            confirmPassword: confirmPassword,
                            phoneNumber: widget.phoneNumber,
                            businessName: widget.businessName,
                            businessType: widget.selectedBusiness,
                          );
                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VendorHomeScreen(),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text("Sign Up"),
                    ),
=======
>>>>>>> save-google-signin
              AuthButton(
                chiild: (auth.isLoading)
                    ? Spinner()
                    : Text(
                        "Sign In",
                        style: TextStyle(color: colors.onPrimary),
                      ),
                onPressed: () async {
                  if (auth.validatePasswordInfo(
                    password: password,
                    confirmPassword: confirmPassword,
                  )) {
                    final success = await auth.signUp(
                      onlyPassword: true,
                      email: widget.email,
                      name: widget.name,
                      password: password,
                      confirmPassword: confirmPassword,
                      phoneNumber: widget.phoneNumber,
                      businessName: widget.businessName,
                      businessType: widget.selectedBusiness,
                    );
                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VendorHomeScreen(),
                        ),
                      );
                    }
                  }
                },
              ),
<<<<<<< HEAD
=======
>>>>>>> ab6d47e (Implement Google Sign-In login feature)
>>>>>>> save-google-signin
            ],
          ),
        ),
      ),
    );
  }
}
