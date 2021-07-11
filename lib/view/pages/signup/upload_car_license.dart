import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/view/widgets/camera.dart';
import 'package:quick_car/states/signup_state.dart';
import 'package:quick_car/view/widgets/buttons.dart';
import 'package:quick_car/view/widgets/images.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_car/view/widgets/messages.dart';

class UploadCarLicense extends StatefulWidget {
  @override
  _UploadCarLicenseState createState() => _UploadCarLicenseState();
}

class _UploadCarLicenseState extends State<UploadCarLicense> {
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



  void _continuePressedWitSkip() {
    context.flow<SignUpState>()
        .update((signUpState) => signUpState.copyWith(carLicense: null, licenseCompleted: true));
  }
  void _continuePressed() {
    int userId = context.flow<SignUpState>().state.id;
    CarsGlobals.signUpApi.uploadCarLicense(imageFile, userId).then(
            (value) {
              if (value == null) {
                setState(() {
                  _error = "Image not found";
                });
                return;
              }
              context
                  .flow<SignUpState>()
                  .update((signUpState) => signUpState.copyWith(carLicense: value, licenseCompleted: true));}
            )
        .onError((error, stackTrace) {
      setState(() {
          _error = "Error uploading car license image";
        });
      });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Upload car license photo",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),),
                  ),
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
                  _error != null ? showAlert(_error, () {
                    setState(() {
                      _error = null;
                    });
                  }) : Text(""),

                  SizedBox(
                    height: 50,
                  ),
                      Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      skipButton(onPressed: () {
                        _continuePressedWitSkip();
                      }),
                      nextButton(onPressed: () {
                        _continuePressed();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
      )
    );
  }
  void callBack(String path) {
    setState(() {
      imageFile = File(path);
    });
  }




}

