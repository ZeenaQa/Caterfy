import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CustomerCheckout extends StatelessWidget {
  const CustomerCheckout({super.key, required this.store});

  final Store? store;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    final globalProvider = Provider.of<GlobalProvider>(context);

    final String storeNameToShow = store == null
        ? ''
        : (Localizations.localeOf(context).languageCode == 'ar' &&
                  store!.name_ar.isNotEmpty
              ? store!.name_ar
              : store!.name);

    return Scaffold(
      appBar: CustomAppBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10.checkout,
              style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold),
            ),
            Text(
              storeNameToShow,
              style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Column(
            spacing: 25,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckoutContainer(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(18, 10, 16, 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.delivery_dining_rounded,
                        size: 23,
                        color: colors.onSecondary,
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10.delivery,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${l10.arrivingIn} ${globalProvider.getDeliveryTime(store?.latitude, store?.longitude)} ${l10.min}',
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              PayWith(),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckoutContainer extends StatelessWidget {
  const CheckoutContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outline),
      ),
      child: child,
    );
  }
}

class PayWith extends StatefulWidget {
  const PayWith({super.key});

  @override
  State<PayWith> createState() => _PayWithState();
}

class _PayWithState extends State<PayWith> {
  bool useWallet = false;
  String payment = "cash";

  void pickMethod(String val) {
    setState(() {
      payment = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final globalProvider = Provider.of<GlobalProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 13,
      children: [
        Text(
          l10.payWith,
          style: TextStyle(
            color: colors.onSecondary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.outline),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: colors.outline)),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      18,
                      10,
                      16,
                      10,
                    ),
                    foregroundColor: colors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => setState(() {
                    useWallet = !useWallet;
                  }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10.useCaterfyPay,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${l10.availableCredit}: ${globalProvider.user["wallet_balance"]} ${l10.jod}',
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      IgnorePointer(
                        child: Switch(
                          value: useWallet,
                          onChanged: (_) {},
                          activeThumbColor: colors.surface,
                          activeTrackColor: colors.inverseSurface,
                          inactiveThumbColor: colors.surface,
                          inactiveTrackColor: colors.onSurfaceVariant,
                          trackOutlineColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            return Colors.transparent;
                          }),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RadioGroup<String>(
                groupValue: payment,
                onChanged: (String? value) {
                  setState(() => payment = value!);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PaymentMethod(value: "1", pickMethod: pickMethod),
                    AddCard(value: "2", pickMethod: pickMethod),
                    Cash(value: "cash", pickMethod: pickMethod),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({
    super.key,
    required this.value,
    required this.pickMethod,
  });

  final String value;
  final Function pickMethod;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.outline)),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsetsDirectional.fromSTEB(18, 10, 16, 10),
          foregroundColor: colors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () => pickMethod(value),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 15,
              children: [
                Icon(
                  FontAwesomeIcons.paypal,
                  size: 16,
                  color: Colors.blueAccent,
                ),
                Text('xxxx-5532'),
              ],
            ),
            IgnorePointer(
              child: Transform.scale(
                scale: 1.1,
                child: Radio<String>(
                  activeColor: colors.inverseSurface,
                  value: value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddCard extends StatelessWidget {
  const AddCard({super.key, required this.value, required this.pickMethod});

  final String value;
  final Function pickMethod;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.outline)),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsetsDirectional.fromSTEB(18, 10, 16, 10),
          foregroundColor: colors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () => pickMethod(value),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 15,
              children: [
                Icon(FontAwesomeIcons.plus, size: 16),
                Text(l10.addCard),
              ],
            ),
            IgnorePointer(
              child: Transform.scale(
                scale: 1.1,
                child: Radio<String>(
                  activeColor: colors.inverseSurface,
                  value: value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Cash extends StatelessWidget {
  const Cash({super.key, required this.value, required this.pickMethod});

  final String value;
  final Function pickMethod;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsetsDirectional.fromSTEB(18, 10, 16, 10),
        foregroundColor: colors.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: () => pickMethod(value),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 15,
            children: [
              Icon(FontAwesomeIcons.moneyBills, size: 16),
              Text(l10.cash),
            ],
          ),
          IgnorePointer(
            child: Transform.scale(
              scale: 1.1,
              child: Radio<String>(
                activeColor: colors.inverseSurface,
                value: value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
