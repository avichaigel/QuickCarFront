// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:quick_car/data_class/car_model.dart';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    this.cars,
  });

  List<Car> cars;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    cars: List<Car>.from(json["cars"].map((x) => Car.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cars": List<dynamic>.from(cars.map((x) => x.toJson())),
  };
}

class Car {
  Car({
//    this.year,
    this.id,
    this.horsepower,
    this.make,
    this.model,
    this.price,
    this.imgUrl,
  });

//  int year;
  int id;
  int horsepower;
  String make;
  String model;
  double price;
  String imgUrl;

  factory Car.fromJson(Map<String, dynamic> json) => Car(
//    year: json["year"],
    id: json["id"],
    horsepower: json["horsepower"],
    make: json["make"],
    model: json["model"],
    price: json["price"],
    imgUrl: json["img_url"],
  );

  Map<String, dynamic> toJson() => {
//    "year": year,
    "id": id,
    "horsepower": horsepower,
    "make": make,
    "model": model,
    "price": price,
    "img_url": imgUrl,
  };
}
