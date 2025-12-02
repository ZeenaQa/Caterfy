import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/providers/locale_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:caterfy/shared_widgets.dart/drawer_button.dart';
import 'package:caterfy/shared_widgets.dart/settings_button.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';

import 'package:caterfy/util/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthSettingsScreen extends StatelessWidget {
  const AuthSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final locale = Provider.of<LocaleProvider>(context).locale;
    final themeController = context.watch<ThemeController>();
    final isDark = themeController.themeMode == ThemeMode.dark;
    final colors = Theme.of(context).colorScheme;

    final List<Widget> items = [
      SizedBox(height: 10),
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
        title: l10.language,
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
