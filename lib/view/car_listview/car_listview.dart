
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/oripo/AndroidStudioProjects/quick_car/lib/view/car_listview/car_data.dart';
import 'file:///C:/Users/oripo/AndroidStudioProjects/quick_car/lib/api/api.dart';
import '../../models/car_model.dart';

class CarSearchView extends StatelessWidget {
  final Car myCar;
  CarSearchView({this.myCar});
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