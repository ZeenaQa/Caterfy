import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:caterfy/vendors/screens/vendor_signup/set_password.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class VendorBuisnessInfo extends StatefulWidget {
  const VendorBuisnessInfo({
    super.key,
    required this.email,
    required this.name,
    required this.phoneNumber,
  });

  final String name;
  final String email;
  final String phoneNumber;

  @override
  State<VendorBuisnessInfo> createState() => _VendorBuisnessInfoState();
}

class _VendorBuisnessInfoState extends State<VendorBuisnessInfo> {
  List<String> businessTypes = [
    "Restaurant",
    "Cafe",
    "Bakery",
    "Grocery",
    "Other",
  ];

  String selectedBusiness = 'Restaurant';
  String businessName = '';

  void handleNext(auth) async {
    if (auth.validateBusinessInfo(
      businessName: businessName,
      businessType: selectedBusiness,
    )) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => SetPassword(
            email: widget.email,
            name: widget.name,
            phoneNumber: widget.phoneNumber,
            selectedBusiness: selectedBusiness,
            businessName: businessName,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<VendorAuthProvider>(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          spacing: 25,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            Center(
              child: Text(
                "Vendor Sign Up",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
            ),

            LabeledTextField(
              onChanged: (v) {
                businessName = v;
              },
              hint: 'Enter your business name',
              label: 'Business Name',
              errorText: auth.businessNameError,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 6),
                  child: Text(
                    "Business Type",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                ),
                DropdownButtonFormField<String>(
                  initialValue: selectedBusiness,
                  items: businessTypes
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedBusiness = value;
                    }
                  },
                  decoration: InputDecoration(filled: false),
                  dropdownColor: colors.surface,
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FilledBtn(
                onPressed: () => handleNext(auth),
                title: "Next",
                stretch: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
