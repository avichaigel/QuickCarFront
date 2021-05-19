import 'package:flutter/cupertino.dart';
import 'package:quick_car/data_class/quick_car/car_data.dart';
import 'package:quick_car/data_class/quick_car/reservation.dart';

class UserState extends ChangeNotifier {
  bool _isLoggedIn = false;
  //TODO: cancel comment
  bool isLoggedIn() => _isLoggedIn;
  // bool isLoggedIn() => true;
  bool isCarLicenseUploaded() => true;
  bool isCreditCardUploaded() => true;
  String _token;
  String _firstName;
  String getFirstName() => _firstName;
  String getToken() => _token;
  List<CarData> _carsAsRenterOut = [];
  List<Reservation> _reservationsAsBorrower = [];
  List<CarData> getMyCars() => _carsAsRenterOut;
  List<Reservation> getMyReservation() => _reservationsAsBorrower;
  void setToken(String token) {
    print("in set token");
    _token = token;
  }
  void addUserCar(CarData cd) {
    _carsAsRenterOut.add(cd);
    notifyListeners();
  }
  void addUserReservation(Reservation r) {
    _reservationsAsBorrower.add(r);
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