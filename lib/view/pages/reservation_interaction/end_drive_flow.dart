import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/states/end_drive_state.dart';
import 'package:quick_car/view/pages/reservation_interaction/car_damage_detection.dart';
import 'package:quick_car/view/pages/reservation_interaction/update_location.dart';

List<Page> onGenerateStartDrivePages(EndDriveState state, List<Page> pages) {
  return [
    MaterialPage(child: CarDamageDetection()),
    if (state.passedDamageDetection) MaterialPage<void>(child: UpdateLocation()),
  ];
}
class EndDriveFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlowBuilder(
      state: EndDriveState(carImages: [], passedDamageDetection: false),
        onGeneratePages: onGenerateStartDrivePages);
  }
}