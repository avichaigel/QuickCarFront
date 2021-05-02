import 'package:flutter/cupertino.dart';

class UserState extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool isLoggedIn() => _isLoggedIn;
  String _token;
  String _firstName;
  String getFirstName() => _firstName;
  String getToken() => _token;

  void setToken(String token) {
    print("in set token");
    _token = token;
  }

  void setIsLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
  void setFirstName(String fn) {
    _firstName = fn;
    notifyListeners();
  }
}