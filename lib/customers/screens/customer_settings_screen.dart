import 'package:caterfy/customers/providers/customer_auth_provider.dart';
import 'package:caterfy/providers/locale_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_dialog.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:caterfy/shared_widgets.dart/drawer_button.dart';
import 'package:caterfy/shared_widgets.dart/settings_button.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/util/l10n_helper.dart';
import 'package:caterfy/util/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerSettingsScreen extends StatelessWidget {
  const CustomerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final locale = Provider.of<LocaleProvider>(context).locale;
    final themeController = context.watch<ThemeController>();
    final isDark = themeController.themeMode == ThemeMode.dark;

    final customerAuth = Provider.of<CustomerAuthProvider>(context);

    Future<void> handleLogout() async {
      customerAuth.isLoading = true;
      customerAuth.notifyLis();

      try {
        await Future.delayed(Duration(milliseconds: 500));
        await Supabase.instance.client.auth.signOut();
      } finally {
        customerAuth.isLoading = false;
        customerAuth.notifyLis();
      }
    }

    final List<Widget> items = [
      SizedBox(height: 10),
      SettingsButton(title: L10n.t.accountInfo, icon: Icons.person_outline),
      SettingsButton(
        title: L10n.t.savedAddresses,
        icon: Icons.location_on_outlined,
      ),
      SettingsButton(title: L10n.t.changeEmail, icon: Icons.email_outlined),
      SettingsButton(title: L10n.t.changePassword, icon: Icons.key_outlined),
      SettingsButton(
        title: L10n.t.notifications,
        icon: Icons.notifications_outlined,
        rightText: L10n.t.enabled,
      ),
      SettingsButton(
        onTap: () {
          openDrawer(
            context,
            child: Column(
              children: [
                DrawerBtn(
                  isSelected: locale.languageCode == "ar",
                  colors: colors,
                  title: "العربية",
                  onPressed: () {
                    context.read<LocaleProvider>().setLocale(Locale('en'));
                    context.read<LocaleProvider>().toggleLocale();
                  },
                ),
                DrawerBtn(
                  isSelected: locale.languageCode == "en",
                  colors: colors,
                  title: "English",
                  onPressed: () {
                    context.read<LocaleProvider>().setLocale(Locale('ar'));
                    context.read<LocaleProvider>().toggleLocale();
                  },
                ),
              ],
            ),
          );
        },
        title: L10n.t.language,
        icon: Icons.language_outlined,
        rightText: locale.languageCode == "en" ? "English" : "العربية",
      ),
      SettingsButton(
        onTap: () {
          openDrawer(
            context,
            child: Column(
              children: [
                DrawerBtn(
                  isSelected: !isDark,
                  colors: colors,
                  title: L10n.t.lightTheme,
                  icon: Icons.wb_sunny_outlined,
                  onPressed: () => Provider.of<ThemeController>(
                    context,
                    listen: false,
                  ).setLight(),
                ),
                DrawerBtn(
                  isSelected: isDark,
                  colors: colors,
                  title: L10n.t.darkTheme,
                  icon: Icons.dark_mode_outlined,
                  onPressed: () => Provider.of<ThemeController>(
                    context,
                    listen: false,
                  ).setDark(),
                ),
              ],
            ),
          );
        },
        title: L10n.t.theme,
        icon: Icons.wb_sunny_outlined,
        rightText: isDark ? L10n.t.dark : L10n.t.light,
        isLastItem: true,
      ),
      Stack(
        children: [
          Column(
            children: [
              SettingsButton(
                title: L10n.t.logOut,
                onTap: () async {
                  showCustomDialog(
                    context,
                    title: L10n.t.logOut,
                    content: L10n.t.logOutConfirmation,
                    confirmText: L10n.t.logOut,
                    onConfirmAsync: handleLogout,
                    popAfterAsync: false,
                  );
                },
                icon: Icons.logout_outlined,
                isLastItem: true,
              ),
            ],
          ),
        ],
      ),
    ];
    return Scaffold(
      appBar: CustomAppBar(title: L10n.t.settings),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 19),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) => items[index],
      ),
    );
  }
}
