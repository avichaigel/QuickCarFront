import 'package:flutter/cupertino.dart';
import 'package:quick_car/data_class/quick_car/car_data.dart';

class UserState extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool isLoggedIn() => _isLoggedIn;
  bool isCarLicenseUploaded() => true;
  String _token;
  String _firstName;
  String getFirstName() => _firstName;
  String getToken() => _token;
  List<CarData> _myCars = [];
  List<CarData> getMyCars() => _myCars;
  void setToken(String token) {
    print("in set token");
    _token = token;
  }
  void addUserCar(CarData cd) {
    _myCars.add(cd);
    notifyListeners();
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