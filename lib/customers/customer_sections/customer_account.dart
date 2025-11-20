import 'package:caterfy/customers/screens/customer_orders_screen.dart';
import 'package:caterfy/customers/screens/customer_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomerAccountSection extends StatelessWidget {
  const CustomerAccountSection({super.key});
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final List<Widget> items = [
      AccountButton(
        title: "Your orders",
        icon: Icons.receipt_outlined,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CustomerOrdersScreen(appBarTitle: "Orders"),
          ),
        ),
      ),
      AccountButton(
        title: "Vouchers",
        icon: Icons.wallet_giftcard_outlined,
        rightText: '0',
      ),
      AccountButton(title: "Get  help", icon: Icons.help_outline),
      AccountButton(title: "About app", icon: Icons.info_outline),
    ];
    return SafeArea(
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CustomerSettingsScreen(title: 'Settings'),
              ),
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
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/images/waseem_pfp.jpg'),
                  ),
                  Text(
                    "Waseem Alamad",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.settings_outlined,
                        size: 22,
                        color: colors.onSurface,
                      ),
                    ),
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
                // height: 190,
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
                          "0.00 JD",
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    // Make sure Column fills width to allow Align to work properly
                    SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "View details",
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
