import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/custom_dialog.dart';
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        await showCustomDialog(
          context,
          title: "Cancel password reset",
          content: "This will cancel the password reset process",
          confirmText: "Cancel",
          cancelText: "Stay",
          onConfirmAsync: () async => Navigator.of(context).pop(),
        );
      },
      child: Scaffold(
        appBar: CustomAppBar(title: "Forgotten password", titleSize: 15,),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        SizedBox(height: 15),

                        LabeledPasswordField(
                          onChanged: (val) {
                            auth.clearConfirmPassError();
                            confirmPass = val;
                          },
                          hint: '****************',
                          label: 'Confirm Password',
                          errorText: auth.confirmPasswordError,
                        ),

                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password must be at least 8 characters and should include:',
                                style: TextStyle(
                                  color: Color(0xff868686),
                                  fontSize: 11,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                '• 1 uppercase letter (A-Z)',
                                style: TextStyle(
                                  color: Color(0xff868686),
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                '• 1 lowercase letter (a-z)',
                                style: TextStyle(
                                  color: Color(0xff868686),
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                '• 1 number (0-9)',
                                style: TextStyle(
                                  color: Color(0xff868686),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FilledBtn(
                  onPressed: () async {
                    final res = await auth.resetPassword(
                      password: password,
                      confirmPassword: confirmPass,
                    );
                    if (context.mounted && res['message'] != 'mismatch') {
                      if (res['success']) {
                        showCustomToast(
                          context: context,
                          type: ToastificationType.success,
                          message:
                              "Password reset, sign in with the new password!",
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
          ),
        ),
      ),
    );
  }
}
