
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/data_class/quick_car/car_data.dart';
import 'package:quick_car/data_class/quick_car/cars_list_model.dart';


class CarItemView extends StatelessWidget {
  final CarData myCar;
  CarItemView(this.myCar);
  @override
  Widget build(BuildContext context) {
    return Container (
      height: 450,
      child: Column(
        children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        //child: Image.network(myCar.imgUrl.replaceAll("http", "https")),
//                    child: Text("image"),
                      ),
                    ),
                  ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            myCar.brand + " " + myCar.model,
                            style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w400),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(myCar.pricePerDayUsd.toString() + "\$ per day",
                            style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.w400),overflow: TextOverflow.visible,)
                          ,
                        ),
                      ],
                    )
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue
                ),
                child: InkWell(
                  child: Text("Book now",style: TextStyle(color: Colors.white),),
                  onTap: (){
                    print("hello");

                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}