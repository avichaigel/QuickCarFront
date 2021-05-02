import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_car/view/widgets/images.dart';

class CarPhotos extends StatefulWidget {
  @override
  _CarPhotosState createState() => _CarPhotosState();
}

class _CarPhotosState extends State<CarPhotos> {
  File _imageFile;

  Future<File> file;
  chooseImage(ImageSource source) {
    file = ImagePicker.pickImage(
        source: source);
    file.then((value) {
      _imageFile = value;
      setState(() {});
    });
  }
  final ImagePicker _picker = ImagePicker();

  void takePhoto(ImageSource source) async {
    final _pickedFile = await ImagePicker.pickImage(
      source: source);
    setState(() {
      print("in set state");
      _imageFile = _pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload photos"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: image(_imageFile != null ? _imageFile.path : null)
              ),
              imageButtons(takePhoto, chooseImage),
            ],
          ),
        ),
      ),
    );
  }
}
