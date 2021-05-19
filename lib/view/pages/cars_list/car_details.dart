import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/data_class/quick_car/car_data.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/pages/reserve_car/choose_dates.dart';
import 'package:quick_car/view/widgets/images.dart';

class CarDetails extends StatefulWidget {
  CarData car;
  CarDetails(this.car);
  @override
  _CarDetailsState createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  CarData car;
  DatePeriod dates;
  int totalPrice;
  @override
  void initState() {
    super.initState();
    car = widget.car;
  }
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
              ]
          ),
        ),
        bottomNavigationBar: Consumer<UserState>(
            builder: (context, state, child) {
              if (!state.isLoggedIn()) {
                return TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.lightBlue
                  ),

                  onPressed: () => print("hello1"),
                  child: Text("Please log-in or sign up")
                  ,
                ) ;
              } else if (!state.isCarLicenseUploaded()) {
                return TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.lightBlue
                  ),

                  onPressed: () => print("hello2"),
                  child: Text("Upload car license")
                  ,
                ) ;

                // return ;
              } else if (!state.isCarLicenseUploaded()) {
                return TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.lightBlue
                  ),

                  onPressed: () => print("hello3"),
                  child: Text("Upload credit card details")
                  ,
                ) ;

                // return ;
              }
              return
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.lightBlue
                  ),
                  onPressed: () async {
                    dates = await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChooseDates(selectedDatePeriod: dates, carDatePeriods: car.cardates)));
                    setState(() {
                    });
                  },
                  child: Text("Check availability"),
                );
            }

        ),
      ),


    );
  }
}

