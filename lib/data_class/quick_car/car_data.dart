

import 'dart:io';

import 'package:flutter/cupertino.dart';

class CarData {
  CarData(String brand,
    String model,
    int year,
    int kilometers,
    double longitude,
    double latitude,
    int pricePerDayUsd,
    String type,
    File image1,
    List<File> images,
  ) {
    this.brand = brand;
    this.model = model;
    this.year = year;
    this.kilometers = kilometers;
    this.longitude = longitude;
    this.latitude = latitude;
    this.pricePerDayUsd = pricePerDayUsd;
    this.type = type;
    this.image1 = image1;
    this.images = images;

  }

  String brand;
  String model;
  int year;
  int kilometers;
  double longitude;
  double latitude;
  int pricePerDayUsd;
  String type;
  File image1;
  List<File> images;
  DateTime lastUpdate;

}