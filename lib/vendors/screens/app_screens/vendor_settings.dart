import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/providers/locale_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_dialog.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:caterfy/shared_widgets.dart/drawer_button.dart';
import 'package:caterfy/shared_widgets.dart/settings_button.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/util/theme_controller.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:caterfy/vendors/screens/app_screens/vendor_change_password.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VendorSettingsScreen extends StatelessWidget {
  const VendorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final locale = Provider.of<LocaleProvider>(context).locale;
    final themeController = context.watch<ThemeController>();
    final isDark = themeController.themeMode == ThemeMode.dark;
    final VendorAuth = Provider.of<VendorAuthProvider>(context);

    Future<void> handleLogout() async {
      VendorAuth.setLoading(true);
      try {
        await Future.delayed(Duration(milliseconds: 500));
        await Supabase.instance.client.auth.signOut();
      } finally {
        VendorAuth.setLoading(false);
      }
    }

    final user = Supabase.instance.client.auth.currentUser;
    final bool isEmailUser = user?.email != null;

    final List<Widget> items = [
      SizedBox(height: 10),

      if (isEmailUser) ...[
        SettingsButton(title: l10.changeEmail, icon: Icons.email_outlined),
        SettingsButton(
          title: l10.changePassword,
          icon: Icons.key_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VendorChangePassword()),
            );
          },
        ),
      ],
      SettingsButton(
        title: l10.notifications,
        icon: Icons.notifications_outlined,
        rightText: context.watch<GlobalProvider>().notificationsEnabled
            ? l10.enabled
            : l10.disabled,
        onTap: () {
          openDrawer(
            context,
            title: l10.notifications,
            child: Column(
              children: [
                DrawerBtn(
                  isSelected: context
                      .read<GlobalProvider>()
                      .notificationsEnabled,
                  colors: colors,
                  title: l10.enableNotifications,
                  onPressed: () {
                    context.read<GlobalProvider>().setNotificationsEnabled(
                      true,
                    );
                  },
                ),
                DrawerBtn(
                  isSelected: !context
                      .read<GlobalProvider>()
                      .notificationsEnabled,
                  colors: colors,
                  title: l10.disableNotifications,
                  onPressed: () {
                    context.read<GlobalProvider>().setNotificationsEnabled(
                      false,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      SettingsButton(
        onTap: () {
          openDrawer(
            context,
            title: l10.language,
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
        title: l10.language,
        icon: Icons.language_outlined,
        rightText: locale.languageCode == "en" ? l10.english : l10.arabic,
      ),
      SettingsButton(
        onTap: () {
          openDrawer(
            context,
            title: l10.theme,
            child: Column(
              children: [
                DrawerBtn(
                  isSelected: !isDark,
                  colors: colors,
                  title: l10.lightTheme,
                  icon: Icons.wb_sunny_outlined,
                  onPressed: () => Provider.of<ThemeController>(
                    context,
                    listen: false,
                  ).setLight(),
                ),
                DrawerBtn(
                  isSelected: isDark,
                  colors: colors,
                  title: l10.darkTheme,
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
        title: l10.theme,
        icon: Icons.wb_sunny_outlined,
        rightText: isDark ? l10.dark : l10.light,
        isLastItem: true,
      ),
      Stack(
        children: [
          Column(
            children: [
              SettingsButton(
                title: l10.logOut,
                onTap: () async {
                  showCustomDialog(
                    context,
                    title: l10.logOut,
                    content: l10.logOutConfirmation,
                    confirmText: l10.logOut,
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
      appBar: CustomAppBar(title: l10.settings),
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
