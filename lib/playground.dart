import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:quick_car/constants/globals.dart';
import 'package:quick_car/view/pages/upload_car/car_photos.dart';
import 'package:quick_car/view/pages/upload_car/dates_availability.dart';
import 'package:quick_car/view/pages/upload_car/set_price.dart';

import 'data_class/quick_car/car_data.dart';


class PlayGroundPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayGroundState();

}

class _PlayGroundState extends State<PlayGroundPage> {
  CarData c1 = CarData("Toyota", "corola", 2000, 100, 32.0, 34.0, 20, "type", File("assets/car-marker.png"), null);

  @override
  Widget build(BuildContext context) {
    return DatesAvailability(1);
  }
}
