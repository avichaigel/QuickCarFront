

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/constants/globals.dart';
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/data_class/quick_car/car_data.dart';

class SearchState extends ChangeNotifier {

  Future<List<CarData>> carsList = Globals.carsApi.getCars(null);
  String sortedByName = '';
  double _distFilter = 0;
  bool _sortedByPrice = false;
  bool _sortedByDist = false;
  RangeValues _priceRange = RangeValues(0.0, 100.0);
  DatePeriod _datePeriod = DatePeriod(DateTime.now(), DateTime.now().add(Duration(days: 4)));
  List<bool> _typesChecked = List<bool>.filled(CarsGlobals.carTypes.length, true, growable: false);
  bool sortedByPrice() => _sortedByPrice;
  bool sortedByDist() => _sortedByDist;
  RangeValues priceRange() => _priceRange;
  DatePeriod datePeriod() => _datePeriod;
  double distanceFilter() => _distFilter;
  List<bool> typesChecked() => _typesChecked;
  setSortedByPrice() {
    _sortedByDist = false;
    _sortedByPrice = true;
  }
  setSortedByDist() {
    _sortedByDist = true;
    _sortedByPrice = false;
  }
  setDefaultValues() {

  }
  setDistFilter(double d) {
    _distFilter = d;
  }
  setPriceRange(RangeValues rv) {
    _priceRange = rv;
  }
  setDatePeriod(DatePeriod dp) {
    _datePeriod = dp;
  }
  setTypesChecked(int index) {
    _typesChecked[index] = !_typesChecked[index];
  }

  Future<CarData> getCars() async {
    print("in get cars");
    Globals.carsApi.getCars(sortedByName).then((value) {
      if (_distFilter != null) {
        value.removeWhere((element) => element.distanceFromLocation > _distFilter);
      }
      if (_sortedByDist == true) {
        value.sort((a, b){
          return a.distanceFromLocation.compareTo(
              b.distanceFromLocation.toInt()
          );
        });
      } else if (_sortedByPrice == true && sortedByName == Strings.SORT_BY_PRICE_EXP_TO_CHEAP) {
        value.sort((a, b)=> b.pricePerDayUsd.compareTo(a.pricePerDayUsd));
      } else if (_sortedByPrice == true && sortedByName == Strings.SORT_BY_PRICE_CHEAP_TO_EXP) {
        value.sort((a, b)=> a.pricePerDayUsd.compareTo(b.pricePerDayUsd));
      }

      carsList = Future.value(value);
      notifyListeners();
    });



  }

}