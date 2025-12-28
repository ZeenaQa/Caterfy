import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';
  bool _isSaving = false;

  Future<void> _changePassword() async {
    final auth = Provider.of<CustomerAuthProvider>(context, listen: false);
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    auth.clearPassError();
    auth.clearConfirmPassError();

    final l10 = AppLocalizations.of(context);

    if (newPassword != confirmPassword) {
      auth.confirmPasswordError = l10.passwordsNoMatch;
      setState(() {});
      return;
    }

    final validationError = auth.validatePassword(newPassword, l10);
    if (validationError != null) {
      auth.passwordError = validationError;
      setState(() {});
      return;
    }

    setState(() => _isSaving = true);

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      auth.passwordError = l10.errorUpdatingPassword;
      setState(() {});
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<CustomerAuthProvider>(context);
    final l10 = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: l10.changePassword),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          children: [
            LabeledPasswordField(
              label: l10.currentPassword,
              hint: l10.enterCurrentPassword,
              onChanged: (val) => currentPassword = val,
            ),
            const SizedBox(height: 12),

            LabeledPasswordField(
              label: l10.newPassword,
              hint: l10.enterNewPassword,
              errorText: auth.passwordError,
              onChanged: (val) => newPassword = val,
            ),
            const SizedBox(height: 12),

            LabeledPasswordField(
              label: l10.confirmPassword,
              hint: l10.confirmPasswordHint,
              errorText: auth.confirmPasswordError,
              onChanged: (val) => confirmPassword = val,
            ),
            const SizedBox(height: 20),
            FilledBtn(
              onPressed: () {
                if (!_isSaving) _changePassword();
              },
              title: l10.save,
              isLoading: _isSaving,
            ),
          ],
        ),
      ),
    );
  }
}
