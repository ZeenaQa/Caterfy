import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/vendors/screens/vendor_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SetPassword extends StatelessWidget {
  const SetPassword({super.key});

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
              auth.isLoading
                  ? const Center(
                      child: SpinKitWanderingCubes(color: Color(0xFF577A80)),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (auth.validatePasswordInfo()) {
                          final success = await auth.signUp(onlyPassword: true);
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
