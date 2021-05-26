import 'dart:math';
import 'dart:io';
import 'package:flow_builder/flow_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/states/new_car_state.dart';
import 'package:quick_car/view/widgets/camera_demo.dart';
import 'package:quick_car/view/widgets/buttons.dart';

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

  void callBack(String path) {
    images[currIndex] = File(path);
  }

  void uploadPhotoNew() async {
    await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CameraDemo(callBack)));
    setState(() {

    });

  }
  void uploadPhoto(ImageSource source) async {
      PickedFile image = await CarsGlobals.picker.getImage(
          source: source);
    if (image == null) {
      return;
    }
    File imageFile = File(image.path);
      int number = Random().nextInt(100000);
      try {
        File newImage = await imageFile.copy(Strings.APPLICATION_DOCUMENTS_DIRECTORY_PATH +'/image$number.png');
        await imageFile.delete();
       images[currIndex] = newImage;

      } catch (e) {
        print("exception: " + e.toString());
      }

    setState(() {});
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
        .update((carState) => carState.copywith(image1: images[0], imagesUploaded: true ));
  }

  @override
  Widget build(BuildContext context) {
    if (Strings.APPLICATION_DOCUMENTS_DIRECTORY_PATH == null) {
      CarsGlobals.setApplicationDocumentsDirectoryPath();
    }
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
                          // child: Text(pathes[0]),
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)
                            ),
                            child: images[0] == null  ? Image(
                              image: AssetImage("assets/upload-image.png"),
                            ) : FittedBox(
                              // child: Image.file(images[0]),
                              // fit: BoxFit.fill,
                              child: Image(
                                image: FileImage(images[0]),
                              ),
                            ),
                          ),
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
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)
                            ),
                            child: images[1] == null  ? Image(
                              image: AssetImage("assets/upload-image.png"),
                            ) : FittedBox(
                              child: Image(
                                image: FileImage(images[1]),
                              ),
                            ),
                          ),
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
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)
                            ),
                            child: images[2] == null  ? Image(
                              image: AssetImage("assets/upload-image.png"),
                            ) : FittedBox(
                              child: Image(
                                image: FileImage(images[2]),
                              ),
                            ),
                          ),
                          // child: images[2] != null ? newImage(Image.file(images[2])) : newImage(null),
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
                          child: Container(
                            width: 300,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)
                            ),
                            child: images[3] == null  ? Image(
                              image: AssetImage("assets/upload-image.png"),
                            ) : FittedBox(
                              child: Image(
                                image: FileImage(images[3]),
                              ),
                            ),
                          ),
                          // child: images[3] != null ? newImage(Image.file(images[3])) : newImage(null),
                          onTap: () => setState(() => currIndex = 3),

                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () => uploadPhotoNew(),
                    label: Text("Camera"),
                    icon: Icon(Icons.camera_alt),

                  ),
                  TextButton.icon(
                      onPressed: () => uploadPhoto(ImageSource.gallery),
                      icon: Icon(Icons.image),
                      label: Text("Gallery")
                  ),
                  TextButton.icon(
                      onPressed: () async{
                        if (images[currIndex] != null) {
                          try {
                            await images[currIndex]
                                .delete();
                            images[currIndex] = null;
                            setState(() { });
                          } catch (e) {
                            print("exception " + e.toString());
                          }
                        }
                      },
                      icon: Icon(Icons.delete),
                      label: Text("Delete"))
                ],
              ),
              errorWidget(),
              SizedBox(
                height: 100,
              ),
              nextButton(onPressed: () {
                for(var i = 0; i < 2; i++){
                  if (images[i] == null) {
                    setState(() {
                    _errorVisibility = true;
                    });
                    return;
                  }
                }
                _continuePressed();
              })
            ],
          ),
        ),
      ),
    );
  }
}
