import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/shared_widgets.dart/logo_appbar.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerPhoneAuth extends StatefulWidget {
  const CustomerPhoneAuth({super.key});

  @override
  State<CustomerPhoneAuth> createState() => _CustomerPhoneAuthState();
}

class _CustomerPhoneAuthState extends State<CustomerPhoneAuth> {
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    final customerAuth = Provider.of<CustomerAuthProvider>(context);

    return Scaffold(
      appBar: LogoAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            LabeledPhoneField(
              onChanged: (phoneNumber) {},
              label: 'phone number',
            ),
            SizedBox(height: 20),
            AuthButton(
              onPressed: () async {
                final result = await customerAuth.checkPhoneExistsCustomer(
                  phoneNumber: phoneNumber,
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
