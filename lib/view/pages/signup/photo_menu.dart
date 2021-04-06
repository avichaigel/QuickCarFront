

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/models/new_user.dart';
import 'package:quick_car/view/widgets/upload_photo.dart';

class PhotoMenu extends StatefulWidget {
  NewUser user;
  PhotoMenu(this.user);
  @override
  _PhotoMenuState createState() => _PhotoMenuState();
}

class _PhotoMenuState extends State<PhotoMenu> {
  String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload your car license")),
      body: Column(
        children: [
          Center(
            child: TextButton(
              child: Text("to camera"),
              onPressed: () async {
                WidgetsFlutterBinding.ensureInitialized();
                final cameras = await availableCameras();
                final firstCamera = cameras.first;
                Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadPhoto(firstCamera, (String p) {
                  print("in set path");
                  setState(() {
                  imagePath = p;
                }); }) ) );
              },
            ),
          ),
          imagePath != null ? Image.file(File(imagePath)) : Text("no image"),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/credit-card');
            },
            child: Text("submit"),


          )
        ],
      ),
    );
  }
  @override
  void dispose() {
    print("photo menu in dispose");
    super.dispose();
  }
}

