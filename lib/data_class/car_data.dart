import 'dart:io';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:geocoding/geocoding.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/data_class/car_dates.dart';

class CarData {
  CarData(String brand,
    String model,
    int year,
    int kilometers,
    double latitude,
    double longitude,
    int pricePerDayUsd,
    String type,
    List<File> images,
      ) {
    this.brand = brand;
    this.model = model;
    this.year = year;
    this.kilometers = kilometers;
    this.latitude = latitude;
    this.longitude = longitude;
    this.pricePerDayUsd = pricePerDayUsd;
    this.type = type;
    this.images = images;

  }

  CarData.fromCarData({
    this.id,
    this.brand,
    this.model,
    this.year,
    this.kilometers,
    this.owner,
    this.latitude,
    this.longitude,
    this.pricePerDayUsd,
    this.type,
    this.images,
    this.carDates
});

  int id;
  String brand;
  String model;
  int year;
  int kilometers;
  String owner;
  double latitude;
  double longitude;
  int pricePerDayUsd;
  String type;
  List<CarDates> carDates;
  List<File> images;
  DateTime lastUpdate;

  List<Placemark> placeMarks;
  double distanceFromLocation;

  factory CarData.fromJson(Map<dynamic, dynamic> json) {

    double d1;
    double d2;
    List<File> images = [];
    for (int i = 0; i < CarsGlobals.maximumCarImages; i++) {
      if (json["image${i+1}"] != null) {
        images.add(File(json["image${i+1}"]));
      }
    }
    try {
    d1 = double.parse(json["latitude"]);
    d2 = double.parse(json["longitude"]);
    } catch (e) {}
    return CarData.fromCarData(
        id: json["id"],
        brand: json["brand"],
        model: json["model"],
        year: json["year"],
        kilometers: json["kilometers"],
        owner: json["owner"],
        latitude: d1,
        longitude: d2,
        pricePerDayUsd: json["price_per_day_usd"] as int,
        type: json["type"],
        images: images,
    );
  }
  CarData copyWith(List<File> images, List<CarDates> dates, double lat, double lon) {
    return CarData.fromCarData(images: images, carDates: dates, latitude: lat, longitude: lon);

  }

}