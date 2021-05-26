import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quick_car/data_class/car_data.dart';
import 'package:quick_car/data_class/reservation.dart';

class MyReservationDetails extends StatelessWidget {
  Reservation reservation;
  CarData car;
  MyReservationDetails(this.reservation) {
    this.car = reservation.car;
  }
  Text locationText() {
    if (car.placeMarks != null) {
      return Text("Current location: " + car.placeMarks[0].administrativeArea +
          ", ${car.distanceFromLocation.toInt().toString()} km away",
          style: TextStyle(fontSize: 16)
      );
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
                    child: Image.network(car.image1.path),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Align(
                        child: Text(car.brand + " " + car.model,
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        ),

                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Align(
                        child: Text(car.pricePerDayUsd.toString() + "\$ per day",
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.black45
                          ),
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
                      child:   Text("Type: " + car.type, style: TextStyle(fontSize: 20),)),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Kilometers on road: " + car.kilometers.toString() + "km",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
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
                    child: Text("Owner email: " + car.owner,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Rental period: ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                Text("From: " + DateFormat("yyyy-MM-dd").format(reservation.datePeriod.start), style: TextStyle(fontSize: 20),),
                Text("Until: " + DateFormat("yyyy-MM-dd").format(reservation.datePeriod.end),style: TextStyle(fontSize: 20)),
                Text("${reservation.numberOfDays} days", style: TextStyle(fontSize: 18, color: Colors.black45),),
                SizedBox(
                  height: 10,
                ),
                Text("Total price: " + reservation.price.toString() + "\$",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 20,
                )
              ]
          ),
        ),
      ),


    );
  }
}
