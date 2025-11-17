import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/customers/screens/customer_signup/customer_reset_pass_screen.dart';
import 'package:caterfy/shared_widgets.dart/custom_dialog.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/custom_spinner.dart';
import 'package:caterfy/shared_widgets.dart/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';
import 'package:toastification/toastification.dart';

class CustomerPassTokenScreen extends StatefulWidget {
  final String email;
  const CustomerPassTokenScreen({super.key, required this.email});

  @override
  State<CustomerPassTokenScreen> createState() =>
      _CustomerPassTokenScreenState();
}

class _CustomerPassTokenScreenState extends State<CustomerPassTokenScreen> {
  String token = '';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<CustomerAuthProvider>(context);
    final pinController = TextEditingController();

    final defaultPinTheme = PinTheme(
      width: 55,
      height: 55,
      textStyle: TextStyle(fontSize: 20, color: Colors.black),
      decoration: BoxDecoration(
        color: Color(0xfff3f4f7),
        borderRadius: BorderRadius.circular(18),
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        await showCustomDialog(
          context,
          title: "Cancel verification",
          content: "This will cancel the verification process",
          confirmText: "Cancel",
          cancelText: "Stay",
          onConfirmAsync: () async => Navigator.of(context).pop(),
        );
      },
      child: Scaffold(
        appBar: CustomAppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 90.0, left: 35, right: 35),
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
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
                      "Enter the code sent to your email",
                      style: TextStyle(fontSize: 18, color: Color(0xff96a4b2)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    Text(
                      widget.email,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff5f6770),
                      ),
                    ),
                    SizedBox(height: 55),
                    Pinput(
                      controller: pinController,
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      onChanged: (value) {
                        token = value;
                      },
                      onCompleted: (pin) async {
                        final success = await auth.verifyResetPassEmail(
                          email: widget.email,
                          token: token,
                        );
                        if (!success && context.mounted) {
                          showCustomToast(
                            context: context,
                            type: ToastificationType.error,
                            message:
                                "The verification code is invalid or has expired",
                          );
                          pinController.clear();
                        } else {
                          if (!context.mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerResetPassScreen(),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                    if (!auth.tokenIsLoading) ...[
                      Text(
                        "Didn't receive code?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff8a50f6),
                        ),
                      ),
                      SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () async {
                          auth.setTokenIsLoading(true);
                          final res = await auth.sendForgotPasswordPassEmail(
                            email: widget.email,
                          );
                          auth.setTokenIsLoading(false);
                          if (context.mounted && !res['success']) {
                            showCustomToast(
                              context: context,
                              type: ToastificationType.error,
                              message: res['message'],
                            );
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xff8a50f6),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Resend", selectionColor: Colors.red),
                      ),
                    ] else
                      CustomThreeLineSpinner(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
