import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_dialog.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/custom_spinner.dart';
import 'package:caterfy/shared_widgets.dart/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';
import 'package:toastification/toastification.dart';

class CustomerSignupTokenScreen extends StatefulWidget {
  final String email;
  final String password;
  const CustomerSignupTokenScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<CustomerSignupTokenScreen> createState() =>
      _CustomerSignupTokenScreenState();
}

class _CustomerSignupTokenScreenState extends State<CustomerSignupTokenScreen> {
  String token = '';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<CustomerAuthProvider>(context);
    final pinController = TextEditingController();
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

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
          title: l10n.verification,
          content: l10n.cancelVerificationQuestion,
          confirmText: l10n.confirmCancel,
          cancelText: l10n.stay,
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
                      l10n.verification,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                        color: colors.onSurface,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      l10n.enterCodeSent,
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
                        final success = await auth.verifySignupToken(
                          email: widget.email,
                          token: token,
                        );
                        if (!success && context.mounted) {
                          showCustomToast(
                            context: context,
                            type: ToastificationType.error,
                            message: l10n.invalidOrExpiredCode,
                          );
                          pinController.clear();
                        } else {
                          if (!context.mounted) return;
                          showCustomToast(
                            context: context,
                            type: ToastificationType.success,
                            message: l10n.emailVerified,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                    if (!auth.tokenIsLoading) ...[
                      Text(
                        l10n.didntReceiveCode,
                        style: TextStyle(fontSize: 16, color: colors.primary),
                      ),
                      SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () async {
                          auth.setTokenIsLoading(true);
                          final res = await auth.signUp(
                            name: '1',
                            email: widget.email.trim(),
                            password: widget.password,
                            confirmPassword: widget.password,
                          );
                          auth.setTokenIsLoading(false);
                          if (context.mounted) {
                            showCustomToast(
                              context: context,
                              type: ToastificationType.info,
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
                        child: Text(
                          l10n.resend,
                          selectionColor: colors.primary,
                        ),
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
