

import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/data_class/car_data.dart';

class Repository {
  Future<List<CarData>> carsListFuture;

  void updateCars(Object values) {
    carsListFuture = CarsGlobals.carsApi.getCars(values);
  }
}