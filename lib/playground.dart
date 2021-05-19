import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:flow_builder/flow_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:quick_car/constants/globals.dart';
import 'package:quick_car/states/new_car_state.dart';
import 'package:quick_car/view/widgets/buttons.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/view/pages/upload_car/dates_availability.dart';
import 'data_class/quick_car/car_data.dart';


class PlayGroundPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayGroundState();

}

class _PlayGroundState extends State<PlayGroundPage> {
  CarData c1 = CarData("Toyota", "corola", 2000, 100, 32.0, 34.0, 20, "type", File("assets/car-marker.png"), null);

  @override
  Widget build(BuildContext context) {
    return Test();
  }
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  String applicationDocumentsDirectoryPath;

  void setApplicationDocumentsDirectoryPath() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    applicationDocumentsDirectoryPath = directory.path;
  }
  final _picker = ImagePicker();
  CarData c1 = CarData("Toyota", "corola", 2000, 100, 41.379442728352956, 2.1745192577523897, 20, "type", null, null);

File image1;
  void uploadPhoto() async {
    PickedFile image = await _picker.getImage(
        source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    File imageFile = File(image.path);
    int number = Random().nextInt(100000);
    try {
      File newImage = await imageFile.copy('$applicationDocumentsDirectoryPath/image$number.png');
      await imageFile.delete();
      image1 = newImage;

    } catch (e) {
      print("exception: " + e.toString());
    }

    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    setApplicationDocumentsDirectoryPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            TextButton(
                onPressed: () async {
                  await uploadPhoto();
                  c1.image1 = image1;
                  Globals.carsApi.postCar(c1);
                },
                child: Text("take picte")
            ),

    ],
        ),
      ),
    );
  }
}
