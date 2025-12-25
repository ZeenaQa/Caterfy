import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/custom_toast.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

class EditAccountInfo extends StatefulWidget {
  const EditAccountInfo({super.key});

  @override
  State<EditAccountInfo> createState() => _EditAccountInfoState();
}

class _EditAccountInfoState extends State<EditAccountInfo> {
  String name = '';
  String email = '';
  bool _isSaving = false;
  late final l10 = AppLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      name = user.userMetadata?['name'] ?? '';
      if (user.email != null) {
        email = user.email!;
      }
    }
  }

  Future<void> _saveChanges() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'name': name}),
      );

      if (user.email != null && email != user.email) {
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(email: email),
        );
      }

      if (context.mounted) {
        showCustomToast(
          context: context,
          type: ToastificationType.success,
          message: ("Updated successfully!"),
          position: 'bottom',
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        showCustomToast(
          context: context,
          type: ToastificationType.error,
          message: ("Something went wrong"),
          position: 'bottom',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final isEmailUser = user?.email != null;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Account Info'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          children: [
            LabeledTextField(
              label: isEmailUser ? 'Email' : 'Phone Number',
              value: isEmailUser ? user!.email! : user!.phone!,
              keyboardType: isEmailUser
                  ? TextInputType.emailAddress
                  : TextInputType.phone,
              onChanged: (val) => email = val,
              readOnly: !isEmailUser,
            ),
            const SizedBox(height: 12),

            LabeledTextField(
              label: 'Name',
              value: name,
              onChanged: (val) => name = val,
            ),
            const SizedBox(height: 20),

            FilledBtn(
              onPressed: () {
                if (!_isSaving) _saveChanges();
              },
              title: 'Save',
              isLoading: _isSaving,
            ),
          ],
        ),
      ),
    );
  }
}
