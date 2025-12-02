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
    final l10 = AppLocalizations.of(context);
    final auth = Provider.of<CustomerAuthProvider>(context);

    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        await showCustomDialog(
          context,
          title: l10.cancelPasswordResetTitle,
          content: l10.cancelPasswordResetMessage,
          confirmText: l10.confirmCancel,
          cancelText: l10.stay,
          onConfirmAsync: () async => Navigator.of(context).pop(),
        );
      },
      child: Scaffold(
        appBar: CustomAppBar(title: l10.forgotPassword, titleSize: 15),
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
                          label: l10.password,
                          errorText: auth.passwordError,
                        ),
                        SizedBox(height: 15),
                        LabeledPasswordField(
                          onChanged: (val) {
                            auth.clearConfirmPassError();
                            confirmPass = val;
                          },
                          hint: '****************',
                          label: l10.confirmPassword,
                          errorText: auth.confirmPasswordError,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10.passwordRequirementTitle,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                l10.passwordRequirementUppercase,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                l10.passwordRequirementLowercase,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                l10.passwordRequirementNumber,
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
                      context: context,
                    );
                    if (context.mounted && res['message'] != 'mismatch') {
                      if (res['success']) {
                        showCustomToast(
                          context: context,
                          type: ToastificationType.success,
                          message: l10.passwordResetSuccess,
                        );
                      } else {
                        showCustomToast(
                          context: context,
                          type: ToastificationType.error,
                          message: l10.somethingWentWrong,
                        );
                      }
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    }
                  },
                  title: l10.resetPassword,
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
