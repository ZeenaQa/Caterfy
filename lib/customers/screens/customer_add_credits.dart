import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/customer_add_card.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/credit_card.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/money_input.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CustomerAddCredits extends StatefulWidget {
  const CustomerAddCredits({super.key});

  @override
  State<CustomerAddCredits> createState() => _CustomerAddCreditsState();
}

class _CustomerAddCreditsState extends State<CustomerAddCredits> {
  final _amountController = TextEditingController();

  void setAmount(int val) {
    setState(() {
      _amountController.text = val.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<GlobalProvider>(context);
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final paymentMethods = customerProvider.paymentMethods;
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final amount = int.tryParse(_amountController.text) ?? 0;

    return Scaffold(
      appBar: CustomAppBar(title: l10.topUp2),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: FilledBtn(
            onPressed: amount < 5 || amount > 50
                ? null
                : () {
                    FocusManager.instance.primaryFocus?.unfocus(
                      disposition: UnfocusDisposition.previouslyFocusedChild,
                    );
                    FocusScope.of(context).unfocus();
                    openDrawer(
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2,
                        children: [
                          SizedBox(height: 13),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              l10.paymentMethod,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(l10.selectPaymentMethod),
                          ),
                          SizedBox(height: 20),
                          ...List.generate(
                            paymentMethods.length,
                            (index) => PaymentMethod(
                              paymentMethod: paymentMethods[index],
                              pickMethod: () async {
                                final navigator = Navigator.of(context);
                                await globalProvider.addCredits(
                                  context: context,
                                  addition: amount,
                                );

                                if (!mounted) {
                                  return;
                                }
                                navigator.pop();
                              },
                            ),
                          ),
                          AddCard(),
                        ],
                      ),
                    );
                  },
            isLoading: globalProvider.isAddingCredits,
            title: l10.continuee,
            titleSize: 15,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                MoneyInput(controller: _amountController),
                Text(
                  l10.jod,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                SizedBox(height: 0),
                Text(
                  "${l10.enterCreditAmount} 5 ${l10.jod} - 50 ${l10.jod}",
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  l10.quicklyAmount,
                  style: TextStyle(fontSize: 14, color: colors.onSurface),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 15,
                    children: [
                      AmountBox(
                        value: 5,
                        selected: amount == 5,
                        onTap: () => setAmount(5),
                      ),
                      AmountBox(
                        value: 10,
                        selected: amount == 10,
                        onTap: () => setAmount(10),
                      ),
                      AmountBox(
                        value: 20,
                        selected: amount == 20,
                        onTap: () => setAmount(20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddCard extends StatelessWidget {
  const AddCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0),
        foregroundColor: colors.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CustomerAddCard()),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            spacing: 20,
            children: [Icon(FontAwesomeIcons.plus), Text(l10.addNewCard)],
          ),
        ),
      ),
    );
  }
}

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({
    super.key,
    required this.paymentMethod,
    required this.pickMethod,
  });

  final CreditCard paymentMethod;
  final Function pickMethod;

  IconData? getCardIcon() {
    final brand = paymentMethod.brand;
    return brand == "visa"
        ? FontAwesomeIcons.ccVisa
        : brand == "mastercard"
        ? FontAwesomeIcons.ccMastercard
        : brand == "amex"
        ? FontAwesomeIcons.ccAmex
        : brand == "discover"
        ? FontAwesomeIcons.ccDiscover
        : null;
  }

  Color? getCardColor() {
    final brand = paymentMethod.brand;
    return brand == "visa"
        ? Color(0xFF1435cb)
        : brand == "mastercard"
        ? Color(0xFFFF5F00)
        : brand == "amex"
        ? Color(0xFF2E77BC)
        : brand == "discover"
        ? Color(0xFFFF6000)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    String last4 = paymentMethod.cardNumber.substring(
      paymentMethod.cardNumber.length - 4,
    );

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(0),
          foregroundColor: colors.secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        onPressed: () {
          pickMethod();
          Navigator.of(context).pop();
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              children: [
                Icon(getCardIcon(), color: getCardColor()),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: colors.outline)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'xxxx-$last4',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${l10.expiresIn} ${paymentMethod.expMonth}/${paymentMethod.expYear}',
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AmountBox extends StatelessWidget {
  const AmountBox({
    super.key,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final int value;
  final bool selected;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? colors.onSurface : colors.surface,
          border: Border.all(
            color: selected ? Colors.transparent : colors.outline,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          "$value ${l10.jod}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selected ? colors.surface : colors.onSurface,
          ),
        ),
      ),
    );
  }
}
