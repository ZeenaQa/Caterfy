import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/custom_toast.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class CustomerResetPassScreen extends StatefulWidget {
  const CustomerResetPassScreen({super.key});

  @override
  State<CustomerResetPassScreen> createState() =>
      _CustomerResetPassScreenState();
}

class _CustomerResetPassScreenState extends State<CustomerResetPassScreen> {
  String password = '';
  String confirmPass = '';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<CustomerAuthProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          LabeledPasswordField(
            onChanged: (val) {
              auth.clearPassError();
              password = val;
            },
            hint: '****************',
            label: 'Password',
            errorText: auth.passwordError,
          ),

          LabeledPasswordField(
            onChanged: (val) {
              auth.clearConfirmPassError();
              confirmPass = val;
            },
            hint: '****************',
            label: 'Confirm Password',
            errorText: auth.confirmPasswordError,
          ),
          FilledBtn(
            onPressed: () async {
              final success = await auth.resetPassword(
                password: password,
                confirmPassword: confirmPass,
              );
              if (context.mounted) {
                if (success) {
                  showCustomToast(
                    context: context,
                    type: ToastificationType.success,
                    message: "Password reset, sign in with the new password!",
                  );
                } else {
                  showCustomToast(
                    context: context,
                    type: ToastificationType.error,
                    message: "Something went wrong.",
                  );
                }
                Navigator.of(context)
                  ..pop()
                  ..pop();
              }
            },
            title: "Reset password",
            isLoading: auth.isLoading,
          ),
        ],
      ),
    );
  }
}
