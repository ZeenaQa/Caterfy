import 'package:caterfy/customers/providers/auth_provider.dart';
import 'package:caterfy/customers/screens/home-screen.dart';
import 'package:caterfy/customers/screens/signup-screen.dart';
import 'package:caterfy/customers/widgets/textfields.dart';
import 'package:caterfy/sellers/screens/signup-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CustomerLoginScreen extends StatelessWidget {
  final String role;
  const CustomerLoginScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<CustomerAuthProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                const Center(
                  child: Text(
                    " Log In",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 164, 188, 192),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                CustomTextField(
                  labelText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  onChanged: auth.setEmail,
                ),
                const SizedBox(height: 20),
                PasswordTextField(onChanged: auth.setPassword),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot your password?",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerSignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                if (auth.Lerror != null)
                  Text(auth.Lerror!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 20),
                auth.isLoading
                    ? const Center(
                        child: SpinKitWanderingCubes(color: Color(0xFF577A80)),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          final success = await auth.logIn();
                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CustomerHomeScreen(),
                              ),
                            );
                          }
                        },
                        child: const Text("Log In"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
