import 'package:caterfy/shared_widgets.dart/button-widget.dart';
import 'package:caterfy/shared_widgets.dart/logo-AppBar.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CustomerPhoneAuth extends StatelessWidget {
  const CustomerPhoneAuth({super.key});

  @override
  Widget build(BuildContext context) {
    String phoneNumber = "";

    return Scaffold(
      appBar: LogoAppBar(),
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
              initialCountryCode: 'JO',
              showDropdownIcon: false,
              disableLengthCheck: true,

              onChanged: (phone) {
                phoneNumber = phone.completeNumber;
                print(phoneNumber);
              },
              style: const TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            AuthButton(onPressed: () {}, chiild: const Text("Continue")),
          ],
        ),
      ),
    );
  }
}
