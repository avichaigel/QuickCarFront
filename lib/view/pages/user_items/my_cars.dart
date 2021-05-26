import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data_class/car_data.dart';
import 'package:quick_car/states/user_state.dart';

class MyCars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
      Scaffold(
        appBar: AppBar(
          title: Text("My cars to rent out"),
        ),
        body: Consumer<UserState>(
          builder: (context, userState, child) {
            List<CarData> myCars = userState.getMyCars();
             return ListView.builder(
              itemCount: myCars.length,
                  itemBuilder: (context, int index) {
                CarData car = myCars[index];
                return Card(
                  child: ListTile(
                    leading: Image.file(car.image1),
                    title: Text(car.brand + " " + car.model)
                  ),
                );
            });
          }
        )
      )
    );
  }
}
