import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/view/pages/user_items/my_car_details.dart';
import '../../../data_class/car_data.dart';
import 'package:quick_car/states/user_state.dart';

class MyCars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("My cars to rent out"),
            ),
            body: Consumer<UserState>(builder: (context, userState, child) {
              List<CarData> myCars = userState.getMyCars();
              return ListView.builder(
                  itemCount: myCars.length,
                  itemBuilder: (context, int index) {
                    CarData car = myCars[index];
                    return Card(
                        child: ListTile(
                            leading: Image.network(car.images[0].path,
                                width: 40, height: 40, fit: BoxFit.fill),
                            title: Text(car.brand + " " + car.model),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Price per day: " +
                                    CarsGlobals.currencyService
                                        .getPriceInCurrency(
                                            car.pricePerDayUsd)),
                                InkWell(
                                  child: Icon(Icons.edit),
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              MyCarDetails(car))),
                                )
                              ],
                            ),
                            onTap: () => print("show details")));
                  });
            })));
  }
}
