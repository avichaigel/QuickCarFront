
import 'package:flutter/cupertino.dart';

class CountryName extends ChangeNotifier {
  String _name;
  String get name => _name;
  void setName(String n) {
    _name = n;
    notifyListeners();
    print("in set name");
  }
}