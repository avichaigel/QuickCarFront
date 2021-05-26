import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/states/start_drive_state.dart';
import 'package:quick_car/view/pages/reservation_interaction/car_photo.dart';

// TODO: add explanation page
List<Page> onGenerateStartDrivePages(StartDriveState state, List<Page> pages) {
  return [
    MaterialPage<void>(child: CarPhoto()),
  ];
}
class StartDriveFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlowBuilder(
      state: StartDriveState(carImages: []),
        onGeneratePages: onGenerateStartDrivePages);
  }
}