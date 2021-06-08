import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
                    child: Image.network(car.images[0].path),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Text(car.brand + " " + car.model,
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Flexible(child: Text(car.pricePerDayUsd.toString() + "\$ per day",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black45
                        ),
                      ))
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
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width/1.2,
                          width: MediaQuery.of(context).size.width/1.2,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(car.latitude, car.longitude),
                              zoom: 16,
                            ),
                            markers: {(Marker(
                                markerId: MarkerId(car.id.toString()),
                                position: LatLng(car.latitude, car.longitude))
                            )
                            },
                            myLocationEnabled: true,

                          ),
                        ),
                      ],
                    ),
                  ),
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
