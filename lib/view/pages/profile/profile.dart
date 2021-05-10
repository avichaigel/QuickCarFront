import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/api/quick_car_api/cars_api.dart';
import 'package:quick_car/constants/globals.dart';
import 'package:quick_car/data_class/quick_car/car_data.dart';
import 'package:quick_car/states/new_car_state.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/pages/my_cars/MyCars.dart';
import 'package:quick_car/view/pages/upload_car/upload_car_flow.dart';

class Profile extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    void _showDialog (String title, String body) {
      print("in show dialog");
      showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          ElevatedButton(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
    }
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
                          final NewCarState newCar = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UploadCarFlow()));
                          CarData cd = CarData(newCar.companyName, newCar.model, int.parse(newCar.manufYear),
                              newCar.kilometers, newCar.longitude, newCar.latitude, newCar.pricePerDay, newCar.type,
                              newCar.image1, newCar.images);
                          Globals.carsListApi.postCar(cd).
                          then((value) {
                              _showDialog("Upload car success", "You can now see it in your car list...");
                              value.lastUpdate = DateTime.now();
                              print("value image: "+ value.image1.path);
                              userState.addUserCar(value);
                          } ).
                          onError((error, stackTrace) {
                              _showDialog("Upload car failed", "There was an error with the connection the the server");
                          });

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
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyCars())),
                      title: Text("My cars"),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/cars.png'),
                        backgroundColor: Colors.white,
                      ),
                    ),

                  ),
                  Card(
                    child: ListTile(
                      onTap: () => print("on my reservations"),
                      title: Text("My reservations"),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/car-reservation.png'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      onTap: () {},
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
