import 'package:caterfy/customers/screens/customer_settings/edit_account_info.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/outlined_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    setState(() {
      user = Supabase.instance.client.auth.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmailUser = user?.email != null;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Account Information',
        content: OutlinedBtn(
          title: 'Edit',
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditAccountInfo()),
            );
            _loadUser();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          children: [
            LabeledTextField(
              label: isEmailUser ? 'Email' : 'Phone Number',
              hint: isEmailUser ? user?.email : user?.phone,
              keyboardType: isEmailUser
                  ? TextInputType.emailAddress
                  : TextInputType.phone,
              readOnly: true,
              onChanged: (_) {},
            ),

            const SizedBox(height: 12),

            LabeledTextField(
              label: 'Name',
              hint: user?.userMetadata?['name'] ?? '',
              readOnly: true,
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
