import 'dart:io';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'car_data.dart';

class Reservation {
  int id;
  int ownerId;
  int renterId;
  int price;
  int numberOfDays;
  CarData car;
  DatePeriod datePeriod;
  File image1;
  File image2;
  File image3;
  File image4;
  bool isActive = false;
  Reservation(this.car, this.datePeriod, this.price, this.numberOfDays);
}