import 'package:flutter/cupertino.dart';
import 'package:quick_car/data_class/quick_car/currency.dart';

class UserState extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool isLoggedIn() => _isLoggedIn;
  String _token;
  String _firstName;
  Currency _chosenCurrency;
  Currency getChosenCurrency() => _chosenCurrency;
  String getFirstName() => _firstName;
  String getToken() => _token;

  void setToken(String token) {
    print("in set token");
    _token = token;
  }

  void setChosenCurrency(Currency currency) {
    print("in set currency");
    _chosenCurrency = currency;
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
