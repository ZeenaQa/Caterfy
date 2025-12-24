import 'package:caterfy/customers/customer_sections/customer_orders.dart';

import 'package:caterfy/customers/screens/customer_settings_screen.dart';
import 'package:caterfy/customers/screens/favorite_stores_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CustomerAccountSection extends StatelessWidget {
  const CustomerAccountSection({super.key});

  String getInitial(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    final user = Provider.of<GlobalProvider>(context).user;
    final List<Widget> items = [
      AccountButton(
        title: l10.yourOrders,
        icon: Icons.receipt_outlined,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: CustomAppBar(title: l10.yourOrders),
              body: SafeArea(child: CustomerOrdersSection(removeTitle: true)),
            ),
          ),
        ),
      ),
      AccountButton(title: l10.vouchers, icon: Icons.wallet_giftcard_outlined),
      AccountButton(
        title: l10.favorites,
        icon: Icons.favorite_border,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoriteStoresScreen()),
          );
        },
      ),

      AccountButton(title: l10.getHelp, icon: Icons.help_outline),
      AccountButton(title: l10.aboutApp, icon: Icons.info_outline),
    ];
    return SafeArea(
      child: (user == null)
          ? Text("LOADING", style: TextStyle(fontWeight: FontWeight.bold))
          : Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CustomerSettingsScreen()),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 3,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      spacing: 15,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colors.onPrimaryContainer,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              getInitial(user?['name'] ?? ''),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          user?['name'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.settings_outlined,
                          size: 22,
                          color: colors.onSurface,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () => (),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colors.primary),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Caterfy pay",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: colors.primary,
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.wallet,
                                size: 36,
                                color: colors.primary,
                              ),
                              SizedBox(width: 15),
                              Text(
                                "0.00 ${l10.jod}",
                                style: TextStyle(
                                  color: colors.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10),

                          SizedBox(
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                l10.viewDetails,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: colors.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: items,
                  ),
                ),
              ],
            ),
    );
  }
}

class AccountButton extends StatelessWidget {
  const AccountButton({
    super.key,
    this.icon,
    required this.title,
    this.rightText,
    this.onTap,
  });

  final IconData? icon;
  final String title;
  final String? rightText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap ?? () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: colors.onSurface),
              SizedBox(width: 15),
            ],
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: colors.onSurface,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: rightText != null
                    ? Text(
                        rightText!,
                        style: TextStyle(color: colors.onSurface),
                      )
                    : SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
