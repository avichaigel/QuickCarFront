

import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/data_class/car_data.dart';

class Repository {
  Future<List<CarData>> _carsListFuture;

  Future<List<CarData>> updateCars(Object values) {
    print("update carsListFuture in repository");
    _carsListFuture = CarsGlobals.carsApi.getCars(values);
    return _carsListFuture;
  }
}