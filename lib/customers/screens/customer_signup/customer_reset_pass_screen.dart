import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        await showCustomDialog(
          context,
          title: l10n.cancelPasswordResetTitle,
          content: l10n.cancelPasswordResetMessage,
          confirmText: l10n.confirmCancel,
          cancelText: l10n.stay,
          onConfirmAsync: () async => Navigator.of(context).pop(),
        );
      },
      child: Scaffold(
        appBar: CustomAppBar(title: l10n.forgotPassword, titleSize: 15),
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
                          label: l10n.password,
                          errorText: auth.passwordError,
                        ),
                        SizedBox(height: 15),
                        LabeledPasswordField(
                          onChanged: (val) {
                            auth.clearConfirmPassError();
                            confirmPass = val;
                          },
                          hint: '****************',
                          label: l10n.confirmPassword,
                          errorText: auth.confirmPasswordError,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.passwordRequirementTitle,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                l10n.passwordRequirementUppercase,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                l10n.passwordRequirementLowercase,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                l10n.passwordRequirementNumber,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
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
                          message: l10n.passwordResetSuccess,
                        );
                      } else {
                        showCustomToast(
                          context: context,
                          type: ToastificationType.error,
                          message: l10n.somethingWentWrong,
                        );
                      }
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    }
                  },
                  title: l10n.resetPassword,
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
