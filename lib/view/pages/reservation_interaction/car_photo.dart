import 'dart:math';

import 'package:flow_builder/flow_builder.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/states/start_drive_state.dart';
import '../../widgets/camera.dart';
import 'package:quick_car/view/widgets/buttons.dart';

class CarPhoto extends StatefulWidget {

  @override
  _CarPhotoState createState() => _CarPhotoState();
}

class _CarPhotoState extends State<CarPhoto> {

  File image;
  String title;
  int currIndex;
  List<File> images = [];

  @override
  void initState() {
    currIndex = 0;
    title = CarsGlobals.startDriveAngles[currIndex];
  }

  void callBack(String path) {
    image = File(path);
  }

  void _uploadPhotoNew() async {
    await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Camera(callBack)));
    setState(() {

    });

  }


  // old version, with lost connection to device
  Future<void> _uploadPhoto() async {
    if (Strings.APPLICATION_DOCUMENTS_DIRECTORY_PATH == null) {
      return;
    }
    final PickedFile pickedFile = await CarsGlobals.picker.getImage(source: ImageSource.camera);
    if (pickedFile == null) {
      return;
    }
    File imageFile = File(pickedFile.path);
    int number = Random().nextInt(100000);
    try {
      File newImage = await imageFile.copy(Strings.APPLICATION_DOCUMENTS_DIRECTORY_PATH +'/image$number.png');
      await imageFile.delete();
      image = newImage;

    } catch (e) {
      print("exception: " + e.toString());
    }
    setState(() {});

  }
  _continuePressed() {
    context.flow<StartDriveState>().
    complete((state) => state.copyWith(carImages: images));
  }
  _nextPressed() {
    images.add(image);
    if (currIndex == 3) {
      _continuePressed();
      return;
    }
    setState(() {
      image = null;
      currIndex += 1;
      title = CarsGlobals.startDriveAngles[currIndex];
    });
  }
  Widget _image() {
    if (image == null) {
      return Image(
          image: AssetImage("assets/upload-image.png")
      );
    } else {
      return Image(
          image: FileImage(image)
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    if (Strings.APPLICATION_DOCUMENTS_DIRECTORY_PATH == null) {
      CarsGlobals.setApplicationDocumentsDirectoryPath();
    }
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text("Take a picture of the ${title} of the car", style: TextStyle(fontSize: 20),),
             Padding(
               padding: const EdgeInsets.all(12.0),
               child: Container(
                 width: phoneWidth,
                   height: phoneHeight/2,
                   decoration: BoxDecoration(
                       border: Border.all(color: Colors.black),
                     borderRadius: BorderRadius.circular(8.0)
               ),
                 child: (
                 Stack(
                   alignment: AlignmentDirectional.center,
                   children: [
                      Container(
                          width: phoneWidth,
                          height: phoneHeight/2,
                          child: _image()),
                     Align(
                       alignment: Alignment.bottomRight,
                       child: FloatingActionButton(
                         onPressed: ()=>_uploadPhotoNew(),
                         child: Icon(Icons.add_a_photo),
                       ),
                     )
                   ],
                 )
                 ),
             ),
             ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  if (image != null) {
                    _nextPressed();
                  }
                },
                child: Text("Next"),
                style: image == null ? disabled() : null,
              )

            ],
          ),
        )
        ,
      )
    )
    );
  }
}
