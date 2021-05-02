import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/api/quick_car_api/sign_up.dart';
import 'package:quick_car/states/signup_state.dart';
import 'package:quick_car/view/widgets/buttons.dart';
import 'package:quick_car/view/widgets/images.dart';
import 'package:quick_car/view/widgets/upload_photo.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:image_picker/image_picker.dart';

class PhotoMenu extends StatefulWidget {
  @override
  _PhotoMenuState createState() => _PhotoMenuState();
}

class _PhotoMenuState extends State<PhotoMenu> {
  String imagePath;
  File tmpFile;
  Future<File> file;

  chooseImage() {
    file = ImagePicker.pickImage(source: ImageSource.gallery);
    file.then((value) {
      imagePath = value.path;
      setState(() {});
    });
  }
//https://www.coderzheaven.com/2019/04/30/upload-image-in-flutter-using-php/ send picture to server
  String base64Image;



  void _continuePressed() {
    context
        .flow<SignUpState>()
        .update((signupState) => signupState.copyWith(picture: "there is a picture", licenseCompleted: true));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload car license")),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                image(imagePath),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 150,
                      child: OutlinedButton(
                        child: Text("Take a picture"),
                        onPressed: () async {
                          WidgetsFlutterBinding.ensureInitialized();
                          final cameras = await availableCameras();
                          final firstCamera = cameras.first;
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadPhoto(firstCamera, (String p) {
                            print("in set path");
                            setState(() {
                              imagePath = p;
                            });
                          })
                          ));
                        },
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: OutlinedButton(
                        onPressed: chooseImage,
                        child: Text('Choose Image'),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    skipButton(onPressed: () {
                      _continuePressed();
                    }),
                    nextButton(onPressed: () {
                      _continuePressed();
                      SignUpApi().uploadCarLicense(imagePath);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
    );
  }
  @override
  void dispose() {
    print("photo menu in dispose");
    super.dispose();
  }
  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          imagePath = tmpFile.path;
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }



}

