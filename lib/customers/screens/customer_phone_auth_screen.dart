import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/shared_widgets.dart/logo_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CustomerPhoneAuth extends StatelessWidget {
  const CustomerPhoneAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final customerAuth = Provider.of<CustomerAuthProvider>(context);
    String phoneNumber = "";
    int numLength = 0;

    return Scaffold(
      appBar: LogoAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: Text(
                "Phone",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  // color: hasError ? Colors.red : Colors.black,
                ),
              ),
            ),
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

              disableLengthCheck: true,

              onChanged: (phone) {
                phoneNumber = phone.completeNumber;
                numLength = phone.number.length;
              },
              style: const TextStyle(color: Colors.black),
            ),
            SizedBox(height: 20),
            AuthButton(
              onPressed: () async {
                final result = await customerAuth.checkPhoneExistsCustomer(
                  numLength,
                );
                print(result);
              },
              chiild: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
