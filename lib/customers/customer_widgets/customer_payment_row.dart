import 'package:caterfy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PaymentRow extends StatelessWidget {
  const PaymentRow({super.key, required this.title, required this.price});

  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    // final colors = Theme.of(context).colorScheme;
    return Row(children: [Text(title), Spacer(), Text('${l10.jod} $price')]);
  }
}
