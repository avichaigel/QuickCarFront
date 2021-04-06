
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/data_class/tests/car_model.dart';

class CarDataView extends StatelessWidget {
  final Car myCar;

  const CarDataView({this.myCar});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 200,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child:  Text(myCar.make.toString(),style: TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.w400),overflow: TextOverflow.fade,),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child:  Text(myCar.model,style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.w400),overflow: TextOverflow.visible,),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child:  Text(myCar.id.toString(),style: TextStyle(color: Colors.black54,fontSize: 13,fontWeight: FontWeight.w400),),
                  ),
                ],
              )
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.greenAccent
          ),
          child: InkWell(
            child: Text("Book now",style: TextStyle(color: Colors.white),),
            onTap: (){
              print("hello");

            },
          ),
        )
      ],
    );

  }
}