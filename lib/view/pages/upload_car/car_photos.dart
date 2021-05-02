import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_car/view/widgets/buttons.dart';
import 'package:quick_car/view/widgets/images.dart';

class CarPhotos extends StatefulWidget {
  @override
  _CarPhotosState createState() => _CarPhotosState();
}

class _CarPhotosState extends State<CarPhotos> {
  File _imageFile1;
  File _imageFile2;
  File _imageFile3;
  File _imageFile4;

  List<File> images = [];


  Future<File> file;

  chooseImage(ImageSource source) {
    file = ImagePicker.pickImage(
        source: source);
    file.then((value) {
      images[currIndex] = value;
      setState(() {});
    });
  }
  final ImagePicker _picker = ImagePicker();
  int currIndex = 0;
  void takePhoto(ImageSource source) async {
    final _pickedFile = await ImagePicker.pickImage(
      source: source);
    setState(() {
      images[currIndex] = _pickedFile;
    });
  }

  @override
  void initState() {
    super.initState();
    images.add(_imageFile1);
    images.add(_imageFile2);
    images.add(_imageFile3);
    images.add(_imageFile4);

  }
  Border imageBorder(int imageIdx) {
    return Border.all(
        width: 3.0, color: imageIdx == currIndex ? Colors.greenAccent : Colors.grey.withOpacity(0));
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
              Container(
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: imageBorder(0)),
                        child: GestureDetector(
                          child: image(images[0] != null ? images[0].path : null),
                          onTap: () => setState(() => currIndex = 0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: imageBorder(1)),
                        child: GestureDetector(
                          child: image(images[1] != null ? images[1].path : null),
                          onTap: () => setState(() => currIndex = 1),

                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: imageBorder(2)),
                        child: GestureDetector(
                          child: image(images[2] != null ? images[2].path : null),
                          onTap: () => setState(() => currIndex = 2),

                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                              border: imageBorder(3)
                          ),
                        child: GestureDetector(
                          child: image(images[3] != null ? images[3].path : null),
                          onTap: () => setState(() => currIndex = 3),

                        ),
                      ),
                    ),

                  ],
                ),
              ),
              imageButtons(takePhoto, chooseImage),
              SizedBox(
                height: 100,
              ),
              nextButton(onPressed: () => print("next pressed"))
            ],
          ),
        ),
      ),
    );
  }
}
