import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/custom_dialog.dart';
import 'package:caterfy/shared_widgets.dart/custom_toast.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:caterfy/util/l10n_helper.dart';
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
    
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        await showCustomDialog(
          context,
          title: L10n.t.cancelPasswordResetTitle,
          content: L10n.t.cancelPasswordResetMessage,
          confirmText: L10n.t.confirmCancel,
          cancelText: L10n.t.stay,
          onConfirmAsync: () async => Navigator.of(context).pop(),
        );
      },
      child: Scaffold(
        appBar: CustomAppBar(title: L10n.t.forgotPassword, titleSize: 15),
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
                          label: L10n.t.password,
                          errorText: auth.passwordError,
                        ),
                        SizedBox(height: 15),
                        LabeledPasswordField(
                          onChanged: (val) {
                            auth.clearConfirmPassError();
                            confirmPass = val;
                          },
                          hint: '****************',
                          label: L10n.t.confirmPassword,
                          errorText: auth.confirmPasswordError,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                L10n.t.passwordRequirementTitle,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                L10n.t.passwordRequirementUppercase,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                L10n.t.passwordRequirementLowercase,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                L10n.t.passwordRequirementNumber,
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
                          message: L10n.t.passwordResetSuccess,
                        );
                      } else {
                        showCustomToast(
                          context: context,
                          type: ToastificationType.error,
                          message: L10n.t.somethingWentWrong,
                        );
                      }
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    }
                  },
                  title: L10n.t.resetPassword,
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
