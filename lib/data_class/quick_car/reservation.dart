import 'dart:io';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:quick_car/data_class/quick_car/car_data.dart';

class Reservation {
  int id;
  int ownerId;
  int renterId;
  CarData car;
  DatePeriod datePeriod;
  File image1;
  File image2;
  File image3;
  File image4;
}