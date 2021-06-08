import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/states/map_state.dart';
import '../../../api/cars_api.dart';
import 'package:quick_car/view/widgets/messages.dart';
import '../../../data_class/car_data.dart';
import 'package:quick_car/states/new_car_state.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/pages/profile/personal_details.dart';
import 'package:quick_car/view/pages/upload_car/dates_availability.dart';
import 'package:quick_car/view/pages/upload_car/upload_car_flow.dart';
import 'package:quick_car/view/pages/user_items/my_cars.dart';
import 'package:quick_car/view/pages/user_items/my_reservations.dart';

class Profile extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(

      child: Consumer<UserState>(
        builder: (context, userState, child) {
          if (userState.isLoggedIn()) {
            return SafeArea(child:
              Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 180,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundImage: AssetImage("assets/car-marker.png"),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Welcome " + userState.getFirstName(),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () async {
                        if (userState.getCreditCard() == null) {
                          myShowDialog(context, "Error", "You need to upload your credit card before upload a new car");
                          return;
                        }
                          final NewCarState newCar = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UploadCarFlow()));
                        print(newCar.pricePerDay);
                          if (newCar.pricePerDay == null)
                            return;
                          print("p"+ newCar.manufYear);
                          CarData cd = CarData(newCar.companyName, newCar.model, int.parse(newCar.manufYear),
                              newCar.kilometers, newCar.latitude, newCar.longitude, newCar.pricePerDay, newCar.type,
                              newCar.images);
                          CarsGlobals.carsApi.postCar(cd).
                          then((value) {
                              myShowDialog(context, "Upload car success", "You can now see it in your car list and update it");
                              value.lastUpdate = DateTime.now();
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DatesAvailability(value.id)));
                              try{
                                Provider.of<MapState>(context, listen: false).addCar(value);
                              } catch (e) {
                                print(e);
                              }
                          } ).
                          onError((error, stackTrace) {
                            myShowDialog(context, "Upload car failed", "There was an error with the connection the the server");
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Uploading new car"),
                              duration: Duration(seconds: 2),
                            ),

                          );

                      },
                      title: Text("Upload new car"),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/car-upload.png'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () async {
                        if (userState.getMyCars().length == 0) {
                          print("get cars from server");
                          var qp = {'owner': Provider.of<UserState>(context, listen: false).getId().toString() };
                          CarsGlobals.carsApi.getCars(qp)
                              .then((value) {
                                userState.setUserCars(value);
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyCars()));
                              })
                              .onError((error, stackTrace) {
                                myShowDialog(context, "Error", "Could not load cars from server");
                              });
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyCars()));
                        }
                      },
                      title: Text("My cars"),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/cars.png'),
                        backgroundColor: Colors.white,
                      ),
                    ),

                  ),
                  Card(
                    child: ListTile(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyReservations())),
                      title: Text("My reservations"),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/car-reservation.png'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => PersonalDetails())),
                      title: Text("Personal details"),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/person.png'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Logout"),
                      onTap: () {
                        userState.setIsLoggedIn(false);
                      },
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/logout.png'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )
            );
          } else {
            return SafeArea(child: Center(
                child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          CircleAvatar(
                            radius: 40.0,
                            backgroundImage: AssetImage("assets/car-marker.png"),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Welcome guest",
                            style: TextStyle(
                            fontSize: 20,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Card(
                            child: ListTile(
                              title: Text("Login"),
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('assets/login.png'),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          )

                        ],
                    )
            )
          )
            );

          }
        },
      )
    );


  }
}
Future<CarData> test(CarData cd) async {
  print("in test");
  return cd;
}