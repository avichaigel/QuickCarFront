import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/constants/strings.dart';
import '../data_class/car_data.dart';

class SearchState extends ChangeNotifier {
  List<CarData> carsList = [];
  SearchState() {
    setDefaultValues();
    loadCars();
  }

  String sortedByName = '';
  double _distFilter;
  bool _init = false;
  bool _isLoading = true;
  bool _sortedByPrice;
  bool _sortedByDist;
  RangeValues _priceRange;
  DatePeriod _datePeriod;
  carTypes _typesChecked;
  bool _isError = false;
  String _errorMessage;
  String getErrorMessage() => _errorMessage;
  bool isError() => _isError;
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
    if (b)
      print("loading cars");
    else
      print("end loading");
    _isLoading = b;
    notifyListeners();
  }
  _setError(bool b, String msg) {
    _isError = b;
    _errorMessage = msg;
  }

  void refresh() => notifyListeners();
  void filterStartsWith(String s) {
    List<CarData> copiedList = copyList(carsList);
    copiedList = carsList.where((element) => element.model.startsWith(s) || element.brand.startsWith(s)).toList();

  }

  void loadCars() async {
    if (_init) {
      setIsLoading(true);
    } else {
      _init = true;
    }
    _setError(false, "");
    Map<String, String> qp = {};
    if (_typesChecked.index != 0)
      qp["type"] = CarsGlobals.carTypes[_typesChecked.index];
    qp["pricemorethen"]=_priceRange.start.toInt().toString();
    qp["pricecheaperthen"]=_priceRange.end.toInt().toString();
    qp["dateFrom"]=DateFormat("yyyy-MM-dd").format(_datePeriod.start);
    qp["dateTo"]=DateFormat("yyyy-MM-dd").format(_datePeriod.end);

    carsList = await CarsGlobals.carsApi.getCars(qp).then<List<CarData>>((value) {
      List<CarData> copiedList = copyList(value);
      print("List length from server: " + copiedList.length.toString());
        if (_distFilter != null) {
          copiedList.removeWhere((element) => element.distanceFromLocation > _distFilter);
        }
        if (_sortedByDist) {
          copiedList.sort((CarData a, CarData b) {
            if (a.distanceFromLocation > b.distanceFromLocation)
              return 1;
            else
              return 0;
          });
        }
        if (_sortedByPrice) {
          print("sort by price");
          int temp;
          if (sortedByName == Strings.SORT_BY_PRICE_CHEAP_TO_EXP)
            temp = 1;
          else {
            temp = 0;
          }
          copiedList.sort((CarData a, CarData b) {
            if (a.pricePerDayUsd > b.pricePerDayUsd)
              return temp;
            else {
              return (temp + 1) % 2;
            }
          });
        }
        print("List length after filter and sort: " + copiedList.length.toString());

        return copiedList;
    }).onError((error, stackTrace) {
      _setError(true, error.toString());
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