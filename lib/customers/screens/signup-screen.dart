import 'package:caterfy/customers/providers/auth_provider.dart';
import 'package:caterfy/customers/screens/home-screen.dart';
import 'package:caterfy/customers/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class CustomerSignUpScreen extends StatelessWidget {
  const CustomerSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<CustomerAuthProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            const Center(
              child: Text(
                "Customer Sign Up",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 131, 148, 138),
                ),
              ),
            ),
            const SizedBox(height: 40),

            CustomTextField(labelText: "Name", onChanged: auth.setName),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: "Email",
              keyboardType: TextInputType.emailAddress,
              onChanged: auth.setEmail,
            ),
            const SizedBox(height: 20),
            PasswordTextField(onChanged: auth.setPassword),
            const SizedBox(height: 20),
            PasswordTextField(
              labelText: "Confirm Password",
              onChanged: auth.setConfirmPassword,
            ),
            const SizedBox(height: 20),

            if (auth.Serror != null)
              Text(auth.Serror!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),

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
                            builder: (context) => const CustomerHomeScreen(),
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
