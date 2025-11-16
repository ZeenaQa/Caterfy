import 'package:flutter/material.dart';

class UnauthenticatedCustomer extends StatelessWidget {
  const UnauthenticatedCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [Text("Please verify your email")]),
    );
  }
}
