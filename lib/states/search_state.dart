import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/repository/repository.dart';
import '../data_class/car_data.dart';

class SearchState extends ChangeNotifier {

  List<CarData> carsList = [];
  SearchState() {
    setDefaultValues();
    loadCars();
  }
  String sortedByName = '';
  double _distFilter;
  bool _isLoading = false;
  bool _sortedByPrice;
  bool _sortedByDist;
  RangeValues _priceRange;
  DatePeriod _datePeriod;
  carTypes _typesChecked;
  bool isLoading() => _isLoading;
  bool sortedByPrice() => _sortedByPrice;
  bool sortedByDist() => _sortedByDist;
  RangeValues priceRange() => _priceRange;
  DatePeriod datePeriod() => _datePeriod;
  double distanceFilter() => _distFilter;
  carTypes getTypesChecked() => _typesChecked;
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
    _typesChecked = carTypes.allTypes;
    notifyListeners();
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
  setTypesChecked(carTypes type) {
    _typesChecked = type;
  }
  setIsLoading(bool b) {
    _isLoading = b;
    notifyListeners();
  }

  void refresh() => notifyListeners();

  void loadCars() async {
    setIsLoading(true);
    // var qp = {'type': CarsGlobals.carTypes[_typesChecked.index] == 0 ? "" : CarsGlobals.carTypes[_typesChecked.index]
    //   };
    Map<String, String> qp = {};
    if (_typesChecked.index != 0)
      qp["type"] = CarsGlobals.carTypes[_typesChecked.index];
    CarsGlobals.repository.updateCars(qp);
    carsList = await CarsGlobals.repository.carsListFuture.then<List<CarData>>((value) {
      List<CarData> copiedList = copyList(value);
              print("get cars search state, list length: " + copiedList.length.toString());
        if (_distFilter != null) {
          copiedList.removeWhere((element) => element.distanceFromLocation > _distFilter);
        }
        print("list length after filter and sort: " + copiedList.length.toString());

        return copiedList;
    });
    // notify after completion
    setIsLoading(false);
 }
 List<CarData> copyList(List<CarData> existList) {
    List<CarData> newList = [];
    for (int i = 0; i < existList.length; i++){
      newList.add(existList[i]);
    }
    return newList;
 }

}