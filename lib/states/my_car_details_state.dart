import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:quick_car/constants/cars_globals.dart';

class MyCarDetailsState extends ChangeNotifier {
  List<File> carImages;
  List<bool> isImageNew;

  double latitude;
  double longitude;
  String address;

  List<DatePeriod> carDates;
  MyCarDetailsState(this.carImages, this.latitude, this.longitude, this.carDates) {
    isImageNew = List<bool>.filled(CarsGlobals.maximumCarImages, false);
    for (int i = carImages.length; i < CarsGlobals.maximumCarImages; i++)
      carImages.add(null);
    print("MyCarDetailsState c'tor");
  }
  void updatePhoto(File file, int index) {
    carImages[index] = file;
    isImageNew[index] = true;
    notifyListeners();
  }
  void removePhoto(int index) {
    carImages[index] = null;
    notifyListeners();
  }
  void updateLocation(double lat, double lon) {
    latitude = lat;
    longitude = lon;
    notifyListeners();
  }

}