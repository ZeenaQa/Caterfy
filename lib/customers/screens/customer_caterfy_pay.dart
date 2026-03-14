import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/customer_add_card.dart';
import 'package:caterfy/customers/screens/customer_add_credits.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/credit_card.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomerCaterfyPay extends StatefulWidget {
  const CustomerCaterfyPay({super.key});

  @override
  State<CustomerCaterfyPay> createState() => _CustomerCaterfyPayState();
}

class _CustomerCaterfyPayState extends State<CustomerCaterfyPay> {
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final customerProvider = Provider.of<LoggedCustomerProvider>(
        context,
        listen: false,
      );
      final gloablProvider = Provider.of<GlobalProvider>(
        context,
        listen: false,
      );
      await customerProvider.fetchPaymentMethods(context: context);
      await gloablProvider.fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final globalProvider = Provider.of<GlobalProvider>(context);
    final List<CreditCard> paymentMethods = customerProvider.paymentMethods;

    final bool isLoading =
        customerProvider.isCheckoutLoading || globalProvider.isFetchingUser;

    return Scaffold(
      appBar: CustomAppBar(title: l10.caterfyPay, titleSize: 16.5),
      body: SafeArea(
        child: Skeletonizer(
          enabled: isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(17, 17, 17, 0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 23, vertical: 20),
                  width: double.infinity,
                  // height: 100,
                  decoration: BoxDecoration(
                    color: isLoading ? colors.surfaceContainer : colors.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          Text(
                            l10.caterfyCredit,
                            style: TextStyle(
                              color: colors.surface,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: "${globalProvider.user['wallet_balance']} ",
                              style: TextStyle(
                                color: colors.surface,
                                fontSize: 17,
                              ),
                              children: [
                                TextSpan(
                                  text: l10.jod,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CustomerAddCredits(),
                            ),
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          l10.topUp,
                          style: TextStyle(
                            color: colors.surface,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (paymentMethods.isEmpty)
                AddCard(isWide: true)
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 10,
                    children: [
                      AddCard(),
                      ...List.generate(
                        paymentMethods.length,
                        (index) => PaymentMethod(
                          paymentMethod: paymentMethods[index],
                          isLastItem: index == paymentMethods.length - 1,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({
    super.key,
    this.isLastItem = false,
    required this.paymentMethod,
  });

  final bool isLastItem;
  final CreditCard paymentMethod;

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
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    String last4 = paymentMethod.cardNumber.substring(
      paymentMethod.cardNumber.length - 4,
    );
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsetsDirectional.only(end: isLastItem ? 17 : 0),
      child: GestureDetector(
        onTap: () => showCustomDialog(
          context,
          title: l10.removeCard,
          content: l10.removeCardWarning,
          confirmText: l10.remove,
          onConfirmAsync: () async {
            await customerProvider.removePaymentMethod(
              context: context,
              cardNumber: paymentMethod.cardNumber,
            );
          },
        ),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          width: 180,
          height: 94,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: colors.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 4,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(getCardIcon(), size: 18, color: getCardColor()),
                  Icon(Icons.arrow_forward_ios, size: 15),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "....$last4",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${l10.expiresIn} ${paymentMethod.expMonth}/${paymentMethod.expYear}",
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddCard extends StatelessWidget {
  const AddCard({super.key, this.isWide = false});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsetsDirectional.only(start: 17, end: isWide ? 17 : 0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CustomerAddCard()),
        ),
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: isWide ? double.infinity : 180,
          height: 94,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: colors.outline),
          ),
          child: Column(
            spacing: 4,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.plus, size: 17),
              Text(l10.addNewCard, style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
