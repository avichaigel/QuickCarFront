
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
    this.id,
    this.type,
    this.color,
    this.year,
  });

  int id;
  String type;
  String color;
  String year;

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    id: json["id"],
    type: json["type"],
    color: json["color"],
    year: json["year"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "color": color,
    "year": year,
  };
}
