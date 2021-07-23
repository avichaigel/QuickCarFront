
import 'package:flutter/cupertino.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/data_class/car_data.dart';

class MapState extends ChangeNotifier {
  List<CarData> carsList = [];

  MapState() {
    loadCars();
  }
  void addCar(CarData cd) {
    carsList.add(cd);
    notifyListeners();
  }

  void loadCars() async {
    CarsGlobals.carsApi.getAllCars()
      .then((value) {
          carsList = value;
          notifyListeners();
        })
      .onError((error, stackTrace) {});
  }
}