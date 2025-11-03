import 'package:caterfy/shared_widgets.dart/button-widget.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneAuthScreen extends StatelessWidget {
  const PhoneAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String phoneNumber = "";

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IntlPhoneField(
              decoration: InputDecoration(
                hintText: "Phone Number",
                filled: true,
                fillColor: const Color(0xFFf2f2f2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              initialCountryCode: 'IN',
              onChanged: (phone) {
                phoneNumber = phone.completeNumber;
                print(phoneNumber);
              },
              dropdownIcon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),
            AuthButton(onPressed: () {}, chiild: const Text("Continue")),
          ],
        ),
      ),
    );
  }
}
