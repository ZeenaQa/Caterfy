import 'package:flutter/material.dart';

class GlobalProvider extends ChangeNotifier {
  dynamic user;

  void setUser(dynamic newUser) {
    user = newUser;
    notifyListeners();
  }

  void clear() {
    user = null;
    notifyListeners();
  }
}
