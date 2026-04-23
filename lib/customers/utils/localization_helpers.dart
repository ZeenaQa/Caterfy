import 'package:caterfy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

String getLocalizedCategory(BuildContext context, String category) {
  final l10 = AppLocalizations.of(context);

  switch (category) {
    case 'food':
      return l10.food;
    case 'ceemart':
      return l10.ceemart;
    case 'groceries':
      return l10.groceries;
    case 'electronics':
      return l10.electronics;
    case 'pharmacy':
      return l10.pharmacy;
    case 'pets':
      return l10.pets;
    case 'myHouse':
      return l10.myHouse;
    case 'laundry':
      return l10.laundry;
    case 'myCar':
      return l10.myCar;
    case 'charity':
      return l10.charity;
    default:
      return category;
  }
}
