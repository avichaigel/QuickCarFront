
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:quick_car/states/new_car_state.dart';
import 'package:quick_car/states/start_drive_state.dart';
import 'package:quick_car/view/pages/reservation_interaction/start_drive_flow.dart';
import 'package:quick_car/view/widgets/buttons.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/view/pages/upload_car/dates_availability.dart';
import 'data_class/car_data.dart';


class PlayGroundPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayGroundState();

}

class _PlayGroundState extends State<PlayGroundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DatesAvailability(1),
    );
  }
}
// class Test2 extends StatelessWidget {
//
//   _onPressed(BuildContext context) async {
//     StartDriveState s = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => StartDriveFlow()));
//    print(s.carImages[0]);
//     print(s.carImages[1]);
//     print(s.carImages[2]);
//     print(s.carImages[3]);
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: TextButton(
//           onPressed: ()=>_onPressed(context),
//           child: Text("press"),
//         ),
//       ),
//     );
//   }
// }
//
//
// class Test extends StatefulWidget {
//   @override
//   _TestState createState() => _TestState();
// }
//
// class _TestState extends State<Test> {
//   String applicationDocumentsDirectoryPath;
//
//   void setApplicationDocumentsDirectoryPath() async {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     applicationDocumentsDirectoryPath = directory.path;
//   }
//   final _picker = ImagePicker();
//
// File image1;
//   void uploadPhoto() async {
//     PickedFile image = await _picker.getImage(
//         source: ImageSource.gallery);
//     if (image == null) {
//       return;
//     }
//     File imageFile = File(image.path);
//     int number = Random().nextInt(100000);
//     try {
//       File newImage = await imageFile.copy('$applicationDocumentsDirectoryPath/image$number.png');
//       await imageFile.delete();
//       image1 = newImage;
//
//     } catch (e) {
//       print("exception: " + e.toString());
//     }
//
//     setState(() {});
//   }
//   @override
//   void initState() {
//     super.initState();
//     setApplicationDocumentsDirectoryPath();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     CarData c1 = CarData("Mitsubishi","Outlander", 2019, 90, 32.32179718820727, 34.851590986800225, 35, "family", null, null);
//
//     List<DatePeriod> dates = [DatePeriod(DateTime.now(), DateTime.now().add(Duration(days: 4)))];
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 100,
//             ),
//             TextButton(
//                 onPressed: () async {
//                   await uploadPhoto();
//                   c1.image1 = image1;
//                   CarData newC1 = await Globals.carsApi.postCar(c1);
//                   await Globals.carsApi.postCarDates(newC1.id, dates);
//                 },
//                 child: Text("take picture and upload c1")
//             ),
//             TextButton(
//                 onPressed: () async {
//                   Globals.carsApi.getCars("values");
//                   print("got cars");
//                 },
//                 child: Text("get cars"))
//
//     ],
//         ),
//       ),
//     );
//   }
// }
