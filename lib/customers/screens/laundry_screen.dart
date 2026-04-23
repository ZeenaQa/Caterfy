import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/main.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:caterfy/shared_widgets.dart/drawer_button.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/settings_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LaundryScreen extends StatefulWidget {
  const LaundryScreen({super.key});

  @override
  State<LaundryScreen> createState() => _LaundryScreenState();
}

class _LaundryScreenState extends State<LaundryScreen> {
  int selectedServiceIndex = 0;
  final phoneNum = navigatorKey.currentContext!
      .read<GlobalProvider>()
      .user['phone'];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final globalProvider = Provider.of<GlobalProvider>(context);
    final l10 = AppLocalizations.of(context);

    final List<Map> services = [
      {"type": l10.washAndPress, "details": l10.washPressDetails},
      {"type": l10.dryClean, "details": l10.dryCleanDetails},
      {"type": l10.pressOnly, "details": l10.pressOnlyDetails},
    ];

    return Scaffold(
      appBar: CustomAppBar(
        // title: "Laundry",
        content: Row(
          spacing: 10,
          children: [
            SvgPicture.asset(
              'assets/icons/rounded_logo.svg',
              height: 30,
              width: 30,
            ),
            Text(
              l10.laundry,
              style: TextStyle(
                fontSize: 17.5,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Image.asset('assets/images/laundry.png', width: 65, height: 65),
              SizedBox(height: 20),
              Center(
                child: Text(
                  l10.fastAndEasyLaundry,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  l10.selectLaundry,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ),
              SizedBox(height: 30),
              SettingsButton(
                title: services[selectedServiceIndex]['type'],
                rightText: l10.selectService,
                icon: Icons.local_laundry_service_rounded,
                iconSize: 25,
                onTap: () => openDrawer(
                  context,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  title: l10.selectService,
                  child: Column(
                    children: services.asMap().entries.map((entry) {
                      final index = entry.key;
                      final service = entry.value;
                      final String title = service['type'];

                      final details = service['details']
                          .split('-')
                          .map((e) => e.trim())
                          .toList();

                      return DrawerBtn(
                        isSelected: selectedServiceIndex == index,
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.onSurface,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 5),
                            ...details.map(
                              (detail) => Text(
                                "• $detail",
                                style: TextStyle(color: colors.secondary),
                              ),
                            ),
                          ],
                        ),

                        onPressed: () => setState(() {
                          selectedServiceIndex = index;
                        }),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SettingsButton(
                title: globalProvider.deliveryLocation!,
                rightText: l10.address,
                icon: Icons.location_on_sharp,
                iconSize: 25,
                // iconSize: 20,
              ),
              SettingsButton(
                title: phoneNum ?? l10.enterPhoneNumber,
                rightText: l10.phone,
                icon: Icons.phone,
                iconSize: 25,
              ),
              SettingsButton(
                title:
                    '${DateFormat("EEE, dd MMM").format(DateTime.now())} ~ 20 minutes',
                rightText: l10.pickUp,
                icon: Icons.date_range,
                iconSize: 25,
              ),
              SettingsButton(
                title: "Wed, 23 Apr ~ 20 minutes",
                rightText: l10.delivery,
                icon: Icons.date_range,
                iconSize: 25,
                isLastItem: true,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
          // isLoading: isPlacingOrder,
          onPressed: () {},
          title: l10.checkout,
          titleSize: 15,
        ),
      ),
    );
  }
}
