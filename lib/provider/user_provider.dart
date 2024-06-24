import 'package:flutter/material.dart';

enum AppColorMode { light, dark }

class UserProvider extends ChangeNotifier {
  String _userId = 'User1';

  String get getUserId => _userId;

  UserProvider();

  changeUser(String id) async {
    _userId = id;

    notifyListeners();
  }
}
