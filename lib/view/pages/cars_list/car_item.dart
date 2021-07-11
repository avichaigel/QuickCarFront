
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/view/widgets/messages.dart';
import '../../../data_class/car_data.dart';
import 'package:quick_car/models/distance.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/pages/reserve_car/choose_dates.dart';
import 'package:location/location.dart' as loc;

import '../reserve_car/reservation_details.dart';


class CarItem extends StatelessWidget {
  final CarData myCar;
  CarItem(this.myCar);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: myCar.images != null ? Container(
                      child: GestureDetector(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: myCar.images[0] != null ? Image.network(myCar.images[0].path) : Text("no image"),
                          ),
                        ),
                        onTap: () async {
                          // try {
                          //   this.myCar.placeMarks = await placemarkFromCoordinates(this.myCar.latitude, this.myCar.longitude);
                          // } catch (e) {
                          //   print("no location found");
                          // }
                          // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CarDetails(this.myCar)));
                        },
                      ),
                    ) : Text("car is missing images")

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
                                myCar.distanceFromLocation.toInt().toString() + " km away",
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
                  return bookNowButton(myCar, context);
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
ElevatedButton bookNowButton(CarData car, BuildContext context) {
  return ElevatedButton(
    child: Text("Book now",style: TextStyle(color: Colors.white),),
    onPressed: () async {
      if (car.images == null) {
        print("car images is null");
        return null;
      }
      try {

      } catch (e) {
        print("error:");
        print(e.toString());
      }
      final userState = Provider.of<UserState>(context, listen: false);
      if (car.owner == userState.getEmail()) {
        myShowDialog(context, "Book car failed", "You cannot book your own car");
        return;
      }
      try {
        car.placeMarks = await placemarkFromCoordinates(car.latitude, car.longitude);
      } catch (e) {
        print("no location found");
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ReservationDetails(car)));
    },
  );
}