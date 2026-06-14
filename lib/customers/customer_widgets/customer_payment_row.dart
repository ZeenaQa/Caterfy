import 'package:caterfy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PaymentRow extends StatelessWidget {
  const PaymentRow({
    super.key,
    required this.title,
    required this.price,
    this.isDiscount = false,
  });

  final String title;
  final String price;
  final bool isDiscount;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final color = isDiscount ? const Color(0xFF22C55E) : null;
    return Row(
      children: [
        Text(title, style: TextStyle(color: color)),
        const Spacer(),
        Text('${l10.jod} $price', style: TextStyle(color: color)),
      ],
    );
  }
}
