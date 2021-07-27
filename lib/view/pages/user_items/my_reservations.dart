import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/data_class/car_data.dart';
import 'package:quick_car/data_class/reservation.dart';
import 'package:quick_car/states/search_state.dart';
import 'package:quick_car/states/end_drive_state.dart';
import 'package:quick_car/states/user_state.dart';
import '../../widgets/camera.dart';
import 'package:quick_car/view/pages/reservation_interaction/end_drive_flow.dart';
import 'package:quick_car/view/pages/user_items/my_reservation_details.dart';
import 'package:quick_car/view/widgets/buttons.dart';
import 'package:quick_car/view/widgets/messages.dart';

class MyReservations extends StatelessWidget {

  ElevatedButton buttons(Reservation reservation, BuildContext context, UserState state) {
    if (!reservation.isActive) {
      return ElevatedButton(
        onPressed: () {
          if (readyToStart(reservation)) {
            state.setReservationActive(reservation);
          }
        },
        child: Text("Start driving"),
        style: !readyToStart(reservation) ? disabled() : null,
      );
    } else if (reservation.isActive) {
      return ElevatedButton(
          onPressed: () async {
            final EndDriveState endDriveFlow = await Navigator
                .push(context, MaterialPageRoute(builder: (BuildContext context) => EndDriveFlow()));
            state.removeReservation(reservation);
            myShowDialog(context, "End driving", "Thank you for using this car!\n");
          },
          child: Text("End drive"),
          style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.red),)
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("My reservations"),
          ),
          body: Consumer<UserState>(
            builder: (context, state, child) {
              List<Reservation> myReservations = state.getMyReservation();
              return ListView.builder(
                itemCount: myReservations.length,
                  itemBuilder: (context, index) {
                  CarData car = myReservations[index].car;
                  Reservation reservation = myReservations[index];
                  return Card(
                    child: ListTile(
                      tileColor: reservation.isActive ? Colors.greenAccent : null,
                      leading: Image.network(car.images[0].path),
                        title: Text("${car.brand} ${car.model}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${DateFormat("yyyy-MM-dd").format(reservation.datePeriod.start)} until "
                              "${DateFormat("yyyy-MM-dd").format(reservation.datePeriod.end)}"),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyReservationDetails(myReservations[index]))),
                        child: Text("Reservation details")
                      ),
                        buttons(reservation, context, state),
                        ],
                      ),
                    ),
                  );
                  });
            },
          ),
        ));
  }

}

bool readyToStart(Reservation reservation) {
  if (DateTime.now() == reservation.datePeriod.start ||
      (DateTime.now().isAfter(reservation.datePeriod.start)) && DateTime.now().isBefore(reservation.datePeriod.end)) {
    return true;
  }
  return false;

}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month
        && this.day == other.day;
  }
}
