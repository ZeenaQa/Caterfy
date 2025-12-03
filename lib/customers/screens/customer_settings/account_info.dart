import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';

class AccountInfo extends StatelessWidget {
  const AccountInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar:  const CustomAppBar(title: 'Account Info'),
    body: Column(
   children: [
       LabeledTextField(
        onChanged: (){}),
         LabeledTextField(
        onChanged: (){}),
         LabeledTextField(
        onChanged: (){}),
        
    
   ],
    )
    );
  }
}