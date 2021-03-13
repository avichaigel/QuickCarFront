// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

CarMetadata welcomeFromJson(String str) => CarMetadata.fromJson(json.decode(str));

String welcomeToJson(CarMetadata data) => json.encode(data.toJson());

class CarMetadata {
  CarMetadata({
    this.cars,
  });

  List<Car> cars;

  factory CarMetadata.fromJson(Map<String, dynamic> json) => CarMetadata(
    cars: List<Car>.from(json["cars"].map((x) => Car.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cars": List<dynamic>.from(cars.map((x) => x.toJson())),
  };
}

class Car {
  Car({
    this.year,
    this.id,
    this.horsepower,
    this.make,
    this.model,
    this.price,
    this.imgUrl,
  });

  int year;
  int id;
  int horsepower;
  String make;
  String model;
  double price;
  String imgUrl;

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    year: json["year"],
    id: json["id"],
    horsepower: json["horsepower"],
    make: json["make"],
    model: json["model"],
    price: json["price"],
    imgUrl: json["img_url"],
  );

  Map<String, dynamic> toJson() => {
    "year": year,
    "id": id,
    "horsepower": horsepower,
    "make": make,
    "model": model,
    "price": price,
    "img_url": imgUrl,
  };
}
