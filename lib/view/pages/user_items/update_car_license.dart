

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/widgets/camera.dart';
import 'package:quick_car/view/widgets/images.dart';
import 'package:quick_car/view/widgets/messages.dart';

class UpdateCarLicense extends StatefulWidget {
  @override
  _UpdateCarLicenseState createState() => _UpdateCarLicenseState();
}

class _UpdateCarLicenseState extends State<UpdateCarLicense> {
  File imageFile;
  Future<PickedFile> file;
  ImagePicker _picker;
  String _error;


  chooseImage() {
    file =  _picker.getImage(source: ImageSource.gallery);
    file.then((value) {
      setState(() {
        imageFile = File(value.path);
      });
    });

  }
  void uploadPhoto() async {
    PickedFile image = await CarsGlobals.picker.getImage(
        source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    try {
      imageFile = File(image.path);
    } catch (e) {
      print("exception: " + e.toString());
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            imageContainer(imageFile),
            SizedBox(height: 20,),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Camera(callBack)));
                    },
                    label: Text("Camera"),
                    icon: Icon(Icons.camera_alt),
                  ),
                  TextButton.icon(
                      onPressed: () => uploadPhoto(),
                      icon: Icon(Icons.image),
                      label: Text("Gallery")
                  ),
                ]
            ),
            _error != null ?showAlert(_error, () {
              setState(() {
                _error = null;
              });
            }) : Text(""),

            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  CarsGlobals.signUpApi.uploadCarLicense(imageFile)
                      .then((value) {
                        Provider.of<UserState>(context, listen: false).setCarLicensePhoto(imageFile);
                        Navigator.pop(context);
                      })
                      .onError((error, stackTrace) {
                        setState(() {
                          _error = "Failed to upload photo";
                        });
                      });

                }, child: Text("Submit")
            )
          ],
        ),
      ),
    );
  }
  void callBack(String path) {
    setState(() {
      imageFile = File(path);
    });
  }
}
