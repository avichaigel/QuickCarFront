import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/api/quick_car_api/cars_api.dart';
import 'package:quick_car/constants/globals.dart';
import 'package:quick_car/states/new_car_state.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/pages/upload_car/upload_car_flow.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<UserState>(
        builder: (context, userState, child) {
          if (userState.isLoggedIn()) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                          CarsApi _carsListApi = Globals.carsListApi;

                          print("in profile after flow finished: ${newCar.companyName}");
                          _carsListApi.postCar(newCar);
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
                      onTap: () {},
                      title: Text("My cars"),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/cars.png'),
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
            );
          } else {
            return Center(
                child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
          );

          }
        },
      )
    );
  }
}
