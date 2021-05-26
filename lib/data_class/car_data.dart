import 'dart:io';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:geocoding/geocoding.dart';

class CarData {
  CarData(String brand,
    String model,
    int year,
    int kilometers,
    double latitude,
    double longitude,
    int pricePerDayUsd,
    String type,
    File image1,
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
    this.image1 = image1;
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
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    this.cardates
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
  File image1;
  File image2;
  File image3;
  File image4;
  List<DatePeriod> cardates;
  List<File> images;
  DateTime lastUpdate;

  List<Placemark> placeMarks;
  double distanceFromLocation;

  factory CarData.fromJson(Map<dynamic, dynamic> json) {
    List<DatePeriod> datesPeriod = [];
    List<dynamic> dates =  json["cardates"];
    List<String> splitDatesStr = [];
    DateTime from;
    DateTime to;
    for (int i = 0; i < dates.length; i++) {
      splitDatesStr =  dates[i].toString().split(" ");
      from = DateTime.parse(splitDatesStr[1]);
      to = DateTime.parse(splitDatesStr[3]);
      datesPeriod.add(DatePeriod(from, to));
    }
    double d1;
    double d2;
    int i;
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
      image1: File(json["image1"]),
      // image2: File(json["image2"]),
      // image3: File(json["image3"]),
      // image4: File(json["image4"]),
      cardates: datesPeriod




    );
  }
}