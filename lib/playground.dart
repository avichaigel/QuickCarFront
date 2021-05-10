import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/view/pages/upload_car/car_photos.dart';
import 'package:quick_car/view/pages/upload_car/set_price.dart';


class PlayGroundPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PalyGround();

}

class PalyGround extends State<PlayGroundPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: CarPhotos()
    );
  }
}
