import 'package:caterfy/customers/screens/favorite_stores_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';

ToastificationItem? _currentToast;

void showFavoriteToast({
  required BuildContext context,
  required bool isFavorite,
  String category = '',
}) {
  final l10 = AppLocalizations.of(context);

  if (_currentToast != null) {
    toastification.dismiss(_currentToast!);
  }

  _currentToast = toastification.show(
    context: context,
    borderSide: BorderSide(color: Colors.transparent),
    margin: EdgeInsets.only(bottom: 0),
    description: Row(
      spacing: 15,
      children: [
        Icon(
          isFavorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          color: Colors.white,
          size: 15,
        ),
        Text(
          isFavorite ? l10.favoriteText : l10.unfavoriteText,
          style: TextStyle(color: Colors.white),
        ),
        Spacer(),
        if (isFavorite)
          GestureDetector(
            onTap: () {
              toastification.dismiss(_currentToast!);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoriteStoresScreen(category: category),
                ),
              );
            },
            child: Text(
              l10.viewAll,
              style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
      ],
    ),
    alignment: Alignment.bottomCenter,
    autoCloseDuration: Duration(seconds: 8),
    animationDuration: Duration(milliseconds: 220),
    dismissDirection: DismissDirection.down,
    showIcon: false,
    borderRadius: BorderRadius.circular(15),
    backgroundColor: Color(0xff272727),
    closeButton: ToastCloseButton(showType: CloseButtonShowType.none),
    callbacks: ToastificationCallbacks(
      onAutoCompleteCompleted: (item) => _currentToast = null,
      onDismissed: (item) => _currentToast = null,
    ),
  );
}
