import 'dart:io';
import 'dart:async';
import 'package:flow_builder/flow_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:quick_car/states/new_car_state.dart';
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
  bool _errorVisibility = false;
  int currIndex = 0;
  Future<File> file;
  final _picker = ImagePicker();

  chooseImage(ImageSource source) async {

    PickedFile image = await _picker.getImage(source: source);

      setState(() {
        if (image == null) {
          return;
        }
        images[currIndex] = File(image.path);
      });
  }
  void takePhoto(ImageSource source) async {
    await _picker.getImage(
               source: source);
        //
    // try {
    //   print("in take photo 1");
    //   PickedFile pickedFile = await _picker.getImage(
    //       source: source);
    //
    //     setState(() {
    //       if (pickedFile == null) {
    //         return;
    //       }
    //       images[currIndex] = File(pickedFile.path);
    //     });
    // } catch (Exception) {
    //   print("exception in take photo: " + Exception.toString() );
    // }
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
  Widget errorWidget() {
    return GestureDetector(
        onTap: () { setState(() {
          _errorVisibility = false;
        });},
        child: Container(
          height: 40,
          child: Visibility(
            visible: _errorVisibility,
            child: AnimatedContainer(
              duration: Duration(seconds: 4),
              child: Text("Please upload a least 4 photos"),
            )
            ,
          ),
        )
    );
  }
  void _continuePressed() {
    context
        .flow<NewCarState>()
        .update((carState) => carState.copywith(image1: images[0], images: images, imagesUploaded: true ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload photos"),
      ),
      body:  SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: imageBorder(0)),
                        child: GestureDetector(
                          child: images[0] != null ? newImage(Image.file(images[0])) : newImage(null),
                          onTap: () => setState(() => currIndex = 0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: imageBorder(1)),
                        child: GestureDetector(
                          child: images[1] != null ? newImage(Image.file(images[1])) : newImage(null),
                          onTap: () => setState(() => currIndex = 1),

                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: imageBorder(2)),
                        child: GestureDetector(
                          child: images[2] != null ? newImage(Image.file(images[2])) : newImage(null),
                          onTap: () => setState(() => currIndex = 2),

                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                          decoration: BoxDecoration(
                              border: imageBorder(3)
                          ),
                        child: GestureDetector(
                          child: images[3] != null ? newImage(Image.file(images[3])) : newImage(null),
                          onTap: () => setState(() => currIndex = 3),

                        ),
                      ),
                    ),

                  ],
                ),
              ),
              imageButtons(takePhoto, chooseImage),
              errorWidget(),
              SizedBox(
                height: 100,
              ),
              nextButton(onPressed: () {
                // for(var i=0;i<2;i++){
                //   if (images[i] == null) {
                //     setState(() {
                //     _errorVisibility = true;
                //     });
                //     return;
                //   }
                // }
                _continuePressed();
              })
            ],
          ),
        ),
      ),
    );
  }
}
