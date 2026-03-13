import 'package:caterfy/customers/customer_widgets/customer_cart_section.dart';
import 'package:caterfy/customers/customer_widgets/customer_payment_row.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/customer_add_card.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/credit_card.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomerCheckout extends StatefulWidget {
  const CustomerCheckout({super.key, required this.store});

  final Store? store;

  @override
  State<CustomerCheckout> createState() => _CustomerCheckoutState();
}

class _CustomerCheckoutState extends State<CustomerCheckout> {
  @override
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

  String payment = "cash";
  bool useWallet = false;

  void pickMethod(String val) {
    setState(() {
      payment = val;
    });
  }

  bool toggleWallet() {
    bool willReturn = false;
    if (!useWallet) {
      final customerProvider = Provider.of<LoggedCustomerProvider>(
        context,
        listen: false,
      );
      final globalProvider = Provider.of<GlobalProvider>(
        context,
        listen: false,
      );
      final double deliveryPrice = globalProvider.getDeliveryPrice(
        widget.store?.latitude,
        widget.store?.longitude,
      );

      if (globalProvider.user['wallet_balance'] >=
          customerProvider.totalCartPrice + deliveryPrice) {
        willReturn = true;
        pickMethod('wallet');
      }
    } else {
      if (payment == "wallet") {
        pickMethod("cash");
      }
    }
    setState(() {
      useWallet = !useWallet;
    });
    return willReturn;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    final globalProvider = Provider.of<GlobalProvider>(context);
    final double deliveryPrice = globalProvider.getDeliveryPrice(
      widget.store?.latitude,
      widget.store?.longitude,
    );
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final bool isLoading =
        customerProvider.isCheckoutLoading || globalProvider.isFetchingUser;
    final bool isPlacingOrder = customerProvider.isPlaceOrderLoading;

    final String storeNameToShow = widget.store == null
        ? ''
        : (Localizations.localeOf(context).languageCode == 'ar' &&
                  widget.store!.name_ar.isNotEmpty
              ? widget.store!.name_ar
              : widget.store!.name);

    final bool isStoreOpen = widget.store?.isOpen ?? true;
    final walletBalance = globalProvider.user["wallet_balance"];
    final bool walletOnly =
        walletBalance >= customerProvider.totalCartPrice + deliveryPrice &&
        useWallet;

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
      bottomNavigationBar: isLoading
          ? null
          : Container(
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              decoration: BoxDecoration(
                color: colors.surface,
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 6,
                    offset: const Offset(0, 3.5),
                  ),
                ],
              ),
              width: double.infinity,
              child: FilledBtn(
                isLoading: isPlacingOrder,
                onPressed: !isStoreOpen
                    ? null
                    : () async {
                        if (payment == "add") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CustomerAddCard(),
                            ),
                          );
                          return;
                        }
                        await customerProvider.placeOrder(
                          context: context,
                          deliveryPrice: deliveryPrice,
                          isUsingWallet: useWallet,
                        );
                        if (context.mounted) {
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        }
                      },
                title: l10.placeOrder,
                titleSize: 15,
              ),
            ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: ListView(
            children: [
              Skeletonizer(
                enabled: isLoading,
                child: Column(
                  spacing: 25,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckoutContainer(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          18,
                          10,
                          16,
                          10,
                        ),
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
                                  '${l10.arrivingIn} ${globalProvider.getDeliveryTime(widget.store?.latitude, widget.store?.longitude)} ${l10.min}',
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
                    PayWith(
                      payment: payment,
                      pickMethod: pickMethod,
                      useWallet: useWallet,
                      toggleWallet: toggleWallet,
                      walletOnly: walletOnly,
                    ),
                    CartSection(
                      titlePadding: false,
                      sectionTitle: l10.paymentSummary,
                      content: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, bottom: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 11,
                            children: [
                              PaymentRow(
                                title: l10.subtotal,
                                price: customerProvider.totalCartPrice
                                    .toStringAsFixed(2),
                              ),
                              PaymentRow(
                                title: l10.deliveryFee,
                                price: deliveryPrice.toStringAsFixed(2),
                              ),
                              PaymentRow(title: l10.serviceFee, price: '0.20'),
                              Row(
                                children: [
                                  Text(
                                    l10.totalAmount,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    '${l10.jod} ${(customerProvider.totalCartPrice + deliveryPrice + 0.20).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              if (payment != "cash" && payment != "wallet")
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(l10.cardCheckoutTos),
                                      Text(
                                        l10.tos,
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
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
  const PayWith({
    super.key,
    required this.payment,
    required this.pickMethod,
    required this.useWallet,
    required this.toggleWallet,
    required this.walletOnly,
  });

  final String payment;
  final Function pickMethod;
  final Function toggleWallet;
  final bool useWallet;
  final bool walletOnly;

  @override
  State<PayWith> createState() => _PayWithState();
}

class _PayWithState extends State<PayWith> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final globalProvider = Provider.of<GlobalProvider>(context);
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final List<CreditCard> paymentMethods = customerProvider.paymentMethods;
    final walletBalance = globalProvider.user["wallet_balance"];

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
              if (walletBalance > 0)
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
                      bool willReturn = widget.toggleWallet();
                      if (willReturn) {
                        return;
                      }
                      if (widget.payment == "cash") {
                        if (paymentMethods.isEmpty) {
                          widget.pickMethod("add");
                          return;
                        }
                        widget.pickMethod(paymentMethods[0].cardNumber);
                      }
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
                              '${l10.availableCredit}: $walletBalance ${l10.jod}',
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        IgnorePointer(
                          child: Opacity(
                            opacity: Skeletonizer.of(context).enabled ? 0 : 1,
                            child: Switch(
                              value: widget.useWallet,
                              onChanged: (_) {},
                              activeThumbColor: colors.surface,
                              activeTrackColor: colors.inverseSurface,
                              inactiveThumbColor: colors.surface,
                              inactiveTrackColor: colors.onSurfaceVariant,
                              trackOutlineColor:
                                  WidgetStateProperty.resolveWith((states) {
                                    return Colors.transparent;
                                  }),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              RadioGroup<String>(
                key: ValueKey(paymentMethods.length),
                groupValue: widget.payment,
                onChanged: (String? value) {
                  widget.pickMethod(value!);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: paymentMethods.length + 2,
                      itemBuilder: (context, index) {
                        if (index < paymentMethods.length) {
                          final paymentMethod = paymentMethods[index];
                          return PaymentMethod(
                            value: paymentMethod.cardNumber,
                            pickMethod: widget.pickMethod,
                            card: paymentMethod,
                            disabled: widget.walletOnly,
                          );
                        }

                        if (index == paymentMethods.length) {
                          return AddCard(
                            value: "add",
                            pickMethod: widget.pickMethod,
                          );
                        }

                        return Cash(
                          value: "cash",
                          pickMethod: widget.pickMethod,
                          disabled: widget.useWallet,
                        );
                      },
                    ),
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
    required this.card,
    this.disabled = false,
  });

  final String value;
  final Function pickMethod;
  final CreditCard card;
  final bool disabled;

  IconData? getCardIcon() {
    final brand = card.brand;
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
    final brand = card.brand;
    return brand == "visa"
        ? Color(0xFF1A1F71)
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
    final colors = Theme.of(context).colorScheme;
    String last4 = card.cardNumber.substring(card.cardNumber.length - 4);

    return Opacity(
      opacity: disabled ? .4 : 1,
      child: IgnorePointer(
        ignoring: disabled,
        child: Container(
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
                    Icon(getCardIcon(), size: 16, color: getCardColor()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('xxxx-$last4'),
                        Text(
                          '${card.expMonth}/${card.expYear}',
                          style: TextStyle(color: colors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
                IgnorePointer(
                  child: Transform.scale(
                    scale: 1.1,
                    child: Opacity(
                      opacity: Skeletonizer.of(context).enabled ? 0 : 1,
                      child: Radio<String>(
                        activeColor: colors.inverseSurface,
                        value: value,
                      ),
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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CustomerAddCard()),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 15,
              children: [
                Icon(FontAwesomeIcons.plus, size: 16),
                Text(l10.addNewCard),
              ],
            ),
            IgnorePointer(
              child: Transform.scale(
                scale: 1.1,
                child: Opacity(
                  opacity: Skeletonizer.of(context).enabled ? 0 : 1,
                  child: Radio<String>(
                    activeColor: colors.inverseSurface,
                    value: value,
                  ),
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
  const Cash({
    super.key,
    required this.value,
    required this.pickMethod,
    this.disabled = false,
  });

  final String value;
  final Function pickMethod;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Opacity(
      opacity: disabled ? .4 : 1,
      child: IgnorePointer(
        ignoring: disabled,
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
                  Icon(FontAwesomeIcons.moneyBills, size: 16),
                  Text(l10.cash),
                ],
              ),
              IgnorePointer(
                child: Transform.scale(
                  scale: 1.1,
                  child: Opacity(
                    opacity: Skeletonizer.of(context).enabled ? 0 : 1,
                    child: Radio<String>(
                      activeColor: colors.inverseSurface,
                      value: value,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
