import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/vendors/screens/vendor_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
                }),
                hint: '****************',
                label: 'Password',
                errorText: auth.passwordError,
              ),
              LabeledPasswordField(
                onChanged: (v) => setState(() {
                  confirmPassword = v;
                }),
                hint: '****************',
                label: 'Confirm Password',
                errorText: auth.confirmPasswordError,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
