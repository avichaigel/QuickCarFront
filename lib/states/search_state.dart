import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/constants/globals.dart';
import 'package:quick_car/constants/strings.dart';
import '../data_class/car_data.dart';

class SearchState extends ChangeNotifier {

  Future<List<CarData>> carsList;
  List<CarData> testList;
  SearchState() {
    setDefaultValues();
  }
  String sortedByName = '';
  double _distFilter;
  bool _sortedByPrice;
  bool _sortedByDist;
  RangeValues _priceRange;
  DatePeriod _datePeriod;
  List<bool> _typesChecked;
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
    _distFilter = 50;
    _priceRange = RangeValues(0.0, 100.0);
    _sortedByDist = false;
    _sortedByPrice = false;
    _datePeriod = DatePeriod(DateTime.now(), DateTime.now().add(Duration(days: 4)));
    _typesChecked = List<bool>.filled(CarsGlobals.carTypes.length, true, growable: false);
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

  void refresh() => notifyListeners();

  void loadCars() async {
    carsList = Future.value(await Globals.carsApi.getCars(sortedByName).then<List<CarData>>((value) {
        print("in get cars search state, list length: " + value.length.toString());
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
        print("list length after filter and sort: " + value.length.toString());

        return value;
    }));
    // notify after completion
    notifyListeners();
 }

}