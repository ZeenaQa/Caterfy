import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/credit_card.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerAddCard extends StatefulWidget {
  const CustomerAddCard({super.key});

  @override
  State<CustomerAddCard> createState() => _CustomerAddCardState();
}

class _CustomerAddCardState extends State<CustomerAddCard> {
  IconData cardIcon = FontAwesomeIcons.creditCard;
  Color cardColor = Colors.grey;
  String? brand;

  bool isCardNumValid = true;
  bool isCcvValid = true;
  bool isExpiryValid = true;

  String cardNumber = '';
  String expiry = '';
  String ccv = '';

  void detectCardBrand(String input) {
    brand = null;
    String number = input.replaceAll(' ', '');
    IconData icon = FontAwesomeIcons.creditCard;
    Color color = Colors.grey;

    if (number.length > 3) {
      if (RegExp(r'^4[0-9]{0,}$').hasMatch(number)) {
        icon = FontAwesomeIcons.ccVisa;
        color = Color(0xFF1A1F71);
        brand = "visa";
      } else if (RegExp(r'^5[1-5][0-9]{0,}$').hasMatch(number)) {
        icon = FontAwesomeIcons.ccMastercard;
        color = Color(0xFFFF5F00);
        brand = "mastercard";
      } else if (RegExp(r'^3[47][0-9]{0,}$').hasMatch(number)) {
        icon = FontAwesomeIcons.ccAmex;
        color = Color(0xFF2E77BC);
        brand = "amex";
      } else if (RegExp(r'^6(?:011|5[0-9]{2})[0-9]{0,}$').hasMatch(number)) {
        icon = FontAwesomeIcons.ccDiscover;
        color = Color(0xFFFF6000);
        brand = "discover";
      }
    }

    if (icon != cardIcon || color != cardColor) {
      setState(() {
        cardIcon = icon;
        cardColor = color;
      });
    }
  }

  bool validateExpiry(String input) {
    if (input.length != 5 || !input.contains('/')) return false;

    final parts = input.split('/');
    if (parts.length != 2) return false;

    int? month = int.tryParse(parts[0]);
    int? year = int.tryParse(parts[1]);

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    int fourDigitYear = 2000 + year;

    DateTime now = DateTime.now();
    DateTime expiryDate = DateTime(fourDigitYear, month + 1, 0);

    return expiryDate.isAfter(now);
  }

  void onAddCardPressed() {
    bool cardValid =
        cardNumber.replaceAll(' ', '').length >= 13 && brand != null;
    bool expiryValid = validateExpiry(expiry);
    bool ccvValid = ccv.length == 3;

    setState(() {
      isCardNumValid = cardValid;
      isExpiryValid = expiryValid;
      isCcvValid = ccvValid;
    });

    if (cardValid && expiryValid && ccvValid) {
      final parts = expiry.split('/');
      int month = int.parse(parts[0]);
      int year = int.parse(parts[1]);

      int expMonth = month;
      int expYear = year;

      final customerId = Supabase.instance.client.auth.currentUser?.id;

      final card = CreditCard(
        customerID: customerId!,
        cardNumber: cardNumber,
        expMonth: expMonth,
        expYear: expYear,
        brand: brand!,
      );

      final customerProvider = Provider.of<LoggedCustomerProvider>(
        context,
        listen: false,
      );

      customerProvider.AddCard(context: context, card: card);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        content: Text(
          l10.addCard,
          style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold),
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: FilledBtn(
            onPressed:
                isCardNumValid &&
                    isExpiryValid &&
                    isCcvValid &&
                    cardNumber.length >= 13 &&
                    ccv.length == 3 &&
                    expiry.length == 5
                ? onAddCardPressed
                : null,
            isLoading: customerProvider.isAddCardLoading,
            title: "Add card",
            titleSize: 15,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Text(
                "Enter card details",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              // Card number
              CustomTextField(
                hint: "Card number",
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  cardNumber = val;
                  detectCardBrand(val);

                  if (!isCardNumValid &&
                      val.replaceAll(' ', '').length >= 13 &&
                      brand != null) {
                    setState(() => isCardNumValid = true);
                  } else if (isCardNumValid &&
                      val.replaceAll(' ', '').length < 13) {
                    setState(() => isCardNumValid = false);
                  }
                },
                digitsOnly: true,
                maxLength: 16,
                errorText: isCardNumValid ? null : 'Invalid card number',
                prefix: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 16.0,
                    end: 6,
                  ),
                  child: Icon(cardIcon, size: 16, color: cardColor),
                ),
              ),
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expiry
                  Expanded(
                    child: ExpiryTextField(
                      keyboardType: TextInputType.number,
                      hint: "mm/yy",
                      errorText: isExpiryValid ? null : 'Invalid expiry date',
                      onChanged: (val) {
                        setState(() {
                          expiry = val;
                          if (val.length < 5 && !isExpiryValid) {
                            isExpiryValid = true;
                          } else if (val.length == 5) {
                            isExpiryValid = validateExpiry(val);
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  // CCV
                  Expanded(
                    child: CustomTextField(
                      keyboardType: TextInputType.number,
                      digitsOnly: true,
                      maxLength: 3,
                      hint: "CCV code",
                      errorText: isCcvValid ? null : 'Invalid CCV',
                      onChanged: (val) {
                        ccv = val;
                        if (!isCcvValid && val.length == 3) {
                          setState(() => isCcvValid = true);
                        } else if (isCcvValid && val.length != 3) {
                          setState(() => isCcvValid = false);
                        }
                      },
                      suffix: Icon(FontAwesomeIcons.shieldHalved, size: 16),
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
