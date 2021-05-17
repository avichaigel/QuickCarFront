import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/data_class/quick_car/car_data.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/pages/reserve_car/confirm_dates.dart';
import 'package:quick_car/view/widgets/images.dart';

class CarDetails extends StatelessWidget {
  CarData car;
  CarDetails(this.car);

  Text locationText() {
    if (car.placeMarks != null) {
      return Text("Current location: " + car.placeMarks[0].administrativeArea +
          ", ${car.distanceFromLocation.toInt().toString()} km away",
          style: TextStyle(fontSize: 16));
    } else {
        return Text("Distance: " + car.distanceFromLocation.toInt().toString() + " km away",style: TextStyle(fontSize: 16));
    }
    }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 350,
                    child: Image(
                      image: FileImage(car.image1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Align(
                        child:                 Text(car.brand + " " + car.model, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),

                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Align(
                        child: Text(car.pricePerDayUsd.toString() + "\$ per day",
                          style: TextStyle(
                            fontSize: 22,
                              color: Colors.black45),
                        ),
                      )
                    ],
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child:   Text("Year: " + car.year.toString(), style: TextStyle(fontSize: 20),)),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child:   Text("Kilometers on road: " + car.kilometers.toString() + "km", style: TextStyle(fontSize: 20),),),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child:
              locationText()),
          ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Owner email: " + car.owner),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Consumer<UserState>(
                    builder: (context, state, child) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
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
                        ),
                      );
                }),

              ],
            ),
          ),
        )
    );
  }
}
