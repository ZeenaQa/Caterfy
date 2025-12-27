import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/vendors/screens/app_screens/vendor_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorAccountSection extends StatefulWidget {
  const VendorAccountSection({super.key});

  @override
  State<VendorAccountSection> createState() => _VendorAccountSectionState();
}

class _VendorAccountSectionState extends State<VendorAccountSection> {
  bool isStoreOpen = true;

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
      AccountButton(title: l10.getHelp, icon: Icons.help_outline),
      AccountButton(title: l10.aboutApp, icon: Icons.info_outline),
    ];

    return SafeArea(
      child: (user == null)
          ? Center(
              child: Text(
                l10.loading,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                /// Profile Header
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VendorSettingsScreen(),
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
                              getInitial(user['name'] ?? ''),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          user['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.settings_outlined,
                          size: 22,
                          color: colors.onSurface,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// Store Status Section (NEW)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10.storeStatus,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Icon(
                            Icons.storefront,
                            size: 36,
                            color: colors.primary,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              isStoreOpen ? l10.opened : l10.closed,
                              style: TextStyle(
                                color: isStoreOpen
                                    ? colors.onSurface
                                    : colors.onSurfaceVariant,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Switch(
                            value: isStoreOpen,
                            activeThumbColor: colors.primary,
                            onChanged: (val) {
                              setState(() {
                                isStoreOpen = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                /// Account Buttons
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    physics: const NeverScrollableScrollPhysics(),
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
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: colors.onSurface),
              const SizedBox(width: 15),
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
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
