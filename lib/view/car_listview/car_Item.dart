
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/data_class/tests/car_model.dart';

import 'car_data.dart';

class CarItemView extends StatelessWidget {
  final Car myCar;
  CarItemView({this.myCar});
  @override
  Widget build(BuildContext context) {
    return Container (
      height: 450,
      child: Column(
        children: <Widget>[
          Container(
              height: 300,
              child: (
                  Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(myCar.imgUrl.replaceAll("http", "https")),
//                    child: Text("image"),
                    ),
                  )
              )
          ),
          CarDataView(myCar: myCar,)
        ],
      ),
    );
  }

}