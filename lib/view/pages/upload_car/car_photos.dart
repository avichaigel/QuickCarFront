import 'dart:math';
import 'dart:io';
import 'package:flow_builder/flow_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/data_class/car_detection_response.dart';
import 'package:quick_car/states/new_car_state.dart';
import 'package:quick_car/view/widgets/camera.dart';
import 'package:quick_car/view/widgets/buttons.dart';
import 'package:quick_car/view/widgets/images.dart';
import 'package:quick_car/view/widgets/messages.dart';

class CarPhotos extends StatefulWidget {
  @override
  _CarPhotosState createState() => _CarPhotosState();
}

class _CarPhotosState extends State<CarPhotos> {

  List<File> images = [];
  bool _errorVisibility = false;
  String _errorMsg = '';
  int currIndex = 0;
  bool _loading = false;
  void callBack(String path) {
    images[currIndex] = File(path);
  }

  void takePicture() async {
    await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Camera(callBack)));
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
    for (int i = 0; i < CarsGlobals.maximumCarImages; i++)
      images.add(null);

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
              child: showAlert(_errorMsg, () {
                setState(() {_errorVisibility = false;}
                );
              }),
            )
            ,
          ),
        )
    );
  }
  void _continuePressed() {
    print("continue pressed");
    for (int i = 0; i < images.length; i++) {
      print(images[i].path);
    }
    context
        .flow<NewCarState>()
        .update((carState) => carState.copywith(images: images));
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
                            child: images[0] == null  ? emptyImage() : FittedBox(
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
                            child: images[1] == null  ? emptyImage() : FittedBox(
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
                            child: images[2] == null ? emptyImage() : FittedBox(
                              child: Image(
                                image: FileImage(images[2]),
                              ),
                            ),
                          ),
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
                            child: images[3] == null  ? emptyImage() : FittedBox(
                              child: Image(
                                image: FileImage(images[3]),
                              ),
                            ),
                          ),
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
                    onPressed: () => takePicture(),
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
              Visibility(
                visible: _loading,
                  child: Column(
                    children: [
                      Text("Make sure all images contain a car"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      )
                    ],
                  )),
              nextButton(onPressed: () async {
                setState(() {
                  _loading = true;
                });
                for(var i = 0; i < 4; i++){
                  if (images[i] == null) {
                    setState(() {
                      _errorMsg = "Please upload 4 photos";
                    _errorVisibility = true;
                    _loading = false;
                    });
                    return;
                  }
                  try {
                    CarDetectionResponse cdr = await CarsGlobals.mlApi.isCar(images[i]);
                    if (!cdr.isCar) {
                      setState((){
                        _errorMsg = "Seems that image number ${i+1} does not contain car";
                        _errorVisibility = true;
                        _loading = false;
                      });
                      return;
                    } else {
                      // TODO: update the state of the new car's type
                      print("Detected type:");
                      print(cdr.type);
                      // context
                      //     .flow<NewCarState>()
                      //     .update((carState) => carState.copywith(type: ));
                    }

                  } catch (e) {
                    print(e.toString());
                    setState(() {
                      _loading = false;
                      _errorVisibility = true;
                      _errorMsg = e.toString();
                    });
                    _continuePressed();
                  }

                }
                setState(() {
                  _loading = false;
                });
                _continuePressed();
              })
            ],
          ),
        ),
      ),
    );
  }
}
