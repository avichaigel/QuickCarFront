
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/data_class/quick_car/car_data.dart';
import 'package:quick_car/data_class/quick_car/cars_list_model.dart';
import 'package:quick_car/models/distance.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/pages/reserve_car/confirm_dates.dart';
import 'package:location/location.dart' as loc;

import 'car_details.dart';


class CarItemView extends StatelessWidget {
  final CarData myCar;
  CarItemView(this.myCar);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          // not working:
                          // child: myCar.image1 != null ? Image.network(myCar.image1.path + ".jpg") : Text("no image"),
                          child: Text("no image"),
                        ),
                      ),
                      onTap: () async {
                        try {
                          this.myCar.placeMarks = await placemarkFromCoordinates(this.myCar.latitude, this.myCar.longitude);
                        } catch (e) {
                          print("no location found");
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CarDetails(this.myCar))); },
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
                        myCar.distanceFromLocation != null ?
                        Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            children: [
                              Icon(Icons.location_pin, size: 12,),
                              Text(
                                myCar.distanceFromLocation.toInt().toString() + " km",
                                style: TextStyle(color: Colors.black45,fontSize: 12,fontWeight: FontWeight.w400),
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        ) : Text(""),
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
              Consumer<UserState>(
                builder: (context, state, child) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue
                    ),
                    child: InkWell(
                      child: Text("Book now",style: TextStyle(color: Colors.white),),
                      onTap: () {
                        if (!state.isLoggedIn()) {
                          print("user is not logged in");
                          return;
                        }
                        if (!state.isCarLicenseUploaded()) {
                          print("car license is not uploaded");
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ConfirmDates()));

                      },
                    ),
                  )
                  ;
                },
              )

            ],
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

}