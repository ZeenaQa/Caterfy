import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';

class CustomerSignupTokenScreen extends StatefulWidget {
  final String email;
  const CustomerSignupTokenScreen({super.key, required this.email});

  @override
  State<CustomerSignupTokenScreen> createState() =>
      _CustomerSignupTokenScreenState();
}

class _CustomerSignupTokenScreenState extends State<CustomerSignupTokenScreen> {
  String token = '';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<CustomerAuthProvider>(context);

    final defaultPinTheme = PinTheme(
      width: 55,
      height: 55,
      textStyle: TextStyle(fontSize: 20, color: Colors.black),
      decoration: BoxDecoration(
        color: Color(0xfff3f4f7),
        borderRadius: BorderRadius.circular(18),
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 90.0, left: 35, right: 35),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Verification",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 27,
                    color: Color(0xff212121),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Enter the code sent to the email",
                  style: TextStyle(fontSize: 20, color: Color(0xff96a4b2)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  "waseemalamad@gmail.com",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff5f6770),
                  ),
                ),
                SizedBox(height: 60),
                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  onChanged: (value) {
                    token = value;
                  },
                  onCompleted: (pin) async {
                    await auth.verifySignupToken(
                      email: widget.email,
                      token: token,
                    );
                  },
                ),
                const SizedBox(height: 40),
                Text(
                  "Didn't receive code?",
                  style: TextStyle(fontSize: 17, color: Color(0xff642ad0)),
                ),
                Text(
                  "Resend",
                  style: TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                    color: Color(0xff642ad0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
