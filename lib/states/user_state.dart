import 'package:flutter/cupertino.dart';

class UserState extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool isLoggedIn() => _isLoggedIn;
  void setIsLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
}