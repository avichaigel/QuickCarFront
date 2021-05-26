import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../data_class/car_data.dart';
import '../data_class/reservation.dart';
import 'package:stripe_payment/stripe_payment.dart';

class UserState extends ChangeNotifier {
  bool _isLoggedIn = false;
  CreditCard _creditCard;
  bool isLoggedIn() => _isLoggedIn;
  bool isCarLicenseUploaded() => true;
  CreditCard getCreditCard() => _creditCard;
  //TODO: maybe need to delete token from user state
  String _token;
  String _firstName;
  String getFirstName() => _firstName;
  String getToken() => _token;
  List<CarData> _carsAsRenterOut = [];
  List<Reservation> _reservationsAsBorrower = [];
  List<CarData> getMyCars() => _carsAsRenterOut;
  List<Reservation> getMyReservation() => _reservationsAsBorrower;
  void setToken(String token) {
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
  void setReservationActive(Reservation r) {
    r.isActive = true;
    notifyListeners();
  }
  void removeReservation(Reservation r) {
    _reservationsAsBorrower.remove(r);
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
  void addCreditCard(CreditCard cd) {
    _creditCard = cd;
    notifyListeners();
  }
}