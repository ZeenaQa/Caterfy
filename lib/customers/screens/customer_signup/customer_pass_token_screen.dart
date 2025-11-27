import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/customers/screens/customer_signup/customer_reset_pass_screen.dart';
import 'package:caterfy/shared_widgets.dart/custom_dialog.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/custom_spinner.dart';
import 'package:caterfy/shared_widgets.dart/custom_toast.dart';
import 'package:caterfy/util/l10n_helper.dart';
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
    
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultPinTheme = PinTheme(
      width: 55,
      height: 55,
      textStyle: TextStyle(
        fontSize: 20,
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2124) : const Color(0xfff3f4f7),
        borderRadius: BorderRadius.circular(18),
      ),
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        await showCustomDialog(
          context,
          title: L10n.t.verification,
          content: L10n.t.cancelVerificationQuestion,
          confirmText: L10n.t.cancel,
          cancelText: L10n.t.stay,
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
                      L10n.t.verification,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                        color: colors.onSurface,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      L10n.t.enterCodeSent,
                      style: TextStyle(
                        fontSize: 18,
                        color: colors.onSurfaceVariant,
                      ),
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
                            message: L10n.t.invalidOrExpiredCode,
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
                        L10n.t.didntReceiveCode,
                        style: TextStyle(fontSize: 16, color: colors.primary),
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
                          foregroundColor: colors.primary,
                          side: BorderSide(color: colors.outline),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(L10n.t.resend, selectionColor: colors.error),
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
