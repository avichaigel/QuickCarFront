import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/states/new_car_state.dart';
import 'package:quick_car/view/pages/upload_car/car_details.dart';
import 'package:quick_car/view/pages/upload_car/car_location.dart';
import 'package:quick_car/view/pages/upload_car/car_photos.dart';

List<Page> onGenerateSignUpPages(NewCarState carState, List<Page> pages) {
  return [
    MaterialPage<void>(child: CarPhotos()),
    if (carState.latitude != null && carState.longitude != null) MaterialPage(child: CarDetails()),
    if (carState.companyName != null) MaterialPage<void>(child: CarPhotos()),
  ];
}
class UploadCarFlow extends StatelessWidget  {

  @override
  Widget build(BuildContext context) {

    return FlowBuilder(
        state: NewCarState(),
        onGeneratePages: onGenerateSignUpPages);

  }
}