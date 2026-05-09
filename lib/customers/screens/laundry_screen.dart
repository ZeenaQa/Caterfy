import 'package:caterfy/customers/screens/laundry_checkout_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:caterfy/shared_widgets.dart/drawer_button.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/settings_button.dart';
import 'package:caterfy/util/WheelSelector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final today = DateTime.now();

final next7Days = List.generate(
  7,
  (i) => DateFormat(
    "dd MMM, EEE",
  ).format(DateTime(today.year, today.month, today.day + i + 1)),
);

class LaundryScreen extends StatefulWidget {
  const LaundryScreen({super.key});

  @override
  State<LaundryScreen> createState() => _LaundryScreenState();
}

class _LaundryScreenState extends State<LaundryScreen> {
  int selectedServiceIndex = 0;
  String? _phoneNum;
  String? selectedDelivery;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneNum = context.read<GlobalProvider>().user?['phone'] as String?;
    _phoneController = TextEditingController(text: _phoneNum ?? '');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool _canCheckout(GlobalProvider globalProvider) =>
      globalProvider.deliveryLocation != null &&
      (_phoneNum != null && _phoneNum!.trim().isNotEmpty) &&
      selectedDelivery != null;

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
                title: globalProvider.deliveryLocation ?? l10.pickLocation,
                rightText: l10.address,
                icon: Icons.location_on_sharp,
                iconSize: 25,
              ),
              SettingsButton(
                onTap: () {
                  _phoneController.text = _phoneNum ?? '';
                  openDrawer(
                    context,
                    padding: EdgeInsets.only(top: 20),
                    title: l10.phoneNumber,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                        spacing: 20,
                        children: [
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            autofocus: true,
                            style: const TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              hintText: l10.enterPhoneNumber,
                              prefixIcon: const Icon(Icons.phone_outlined),
                            ),
                          ),
                          FilledBtn(
                            onPressed: () {
                              final val = _phoneController.text.trim();
                              setState(() {
                                _phoneNum = val.isEmpty ? null : val;
                              });
                              Navigator.pop(context);
                            },
                            title: l10.confirm,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                title: _phoneNum ?? l10.enterPhoneNumber,
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
                onTap: () => openDrawer(
                  context,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  title: l10.selectDeliveryTime,
                  child: Column(
                    spacing: 20,
                    children: [
                      WheelSelector<String>(
                        items: next7Days,
                        initialItem: selectedDelivery ?? next7Days[0],
                        onChanged: (val) => setState(() {
                          selectedDelivery = val;
                        }),
                        itemLabel: (item) => item,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: FilledBtn(
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          title: l10.confirm,
                        ),
                      ),
                    ],
                  ),
                ),
                title: selectedDelivery != null
                    ? '$selectedDelivery, 1 PM - 10 PM'
                    : l10.selectDeliveryTime,
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
          onPressed: _canCheckout(globalProvider)
              ? () {
                  final pickupTime =
                      '${DateFormat("EEE, dd MMM").format(DateTime.now())} ~ 20 ${l10.min}';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LaundryCheckoutScreen(
                        service: services[selectedServiceIndex]['type'],
                        address: globalProvider.deliveryLocation!,
                        phone: _phoneNum!,
                        pickupTime: pickupTime,
                        deliveryDate: '$selectedDelivery, 1 PM - 10 PM',
                      ),
                    ),
                  );
                }
              : null,
          title: l10.checkout,
          titleSize: 15,
        ),
      ),
    );
  }
}
