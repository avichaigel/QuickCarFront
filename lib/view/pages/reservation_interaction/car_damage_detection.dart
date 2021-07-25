import 'dart:math';

import 'package:flow_builder/flow_builder.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/services/currency_service.dart';
import 'package:quick_car/services/payment_service.dart';
import 'package:quick_car/states/end_drive_state.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/widgets/messages.dart';
import 'package:stripe_payment/stripe_payment.dart';
import '../../widgets/camera.dart';
import 'package:quick_car/view/widgets/buttons.dart';

class CarDamageDetection extends StatefulWidget {

  @override
  _CarDamageDetectionState createState() => _CarDamageDetectionState();
}

class _CarDamageDetectionState extends State<CarDamageDetection> {

  File shownImage;
  String title;
  int currIndex;
  List<File> images = [];

  bool _isLoading = false;
  String _calculateStr = '';

  @override
  void initState() {
    currIndex = 0;
    title = CarsGlobals.startDriveAngles[currIndex];
  }

  void callBack(String path) {
    shownImage = File(path);
  }

  void _takePicture() async {
    await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Camera(callBack)));
    setState(() {

    });

  }

  void _uploadGalleryPhoto() async {
    PickedFile image = await CarsGlobals.picker.getImage(
        source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    File imageFile = File(image.path);
    shownImage = imageFile;

    int number = Random().nextInt(100000);
    try {
      // File newImage = await imageFile.copy(Strings.APPLICATION_DOCUMENTS_DIRECTORY_PATH +'/image$number.png');
      // await imageFile.delete();
      images[currIndex] = imageFile;
      setState(() {
      });

    } catch (e) {
      print("exception: " + e.toString());
    }

    setState(() {});
  }
  _continuePressed() {
    print("contineureccdscds");
    context.flow<EndDriveState>().update((state) => state.copyWith(passedDamaged: true));
  }
  _calculateDamage() async {
    int damageValue = 50;
    setState(() {
      _isLoading = true;
      _calculateStr = "Search for damages in the car";
    });
    int damagesCount = 0;
    bool isDamaged = false;
    for (int i = 0; i < 2; i++) {
      isDamaged = await CarsGlobals.mlApi.isCarDamaged(images[i]);
      if (isDamaged)
        damagesCount += 1;
    }
    setState(() {
      _isLoading = false;
    });
    if (damagesCount == 0) {
      myShowDialog(context, "Damage Detection passed", "It seems you left no damage");
      _continuePressed();

    } else if (damagesCount == 1) {
      functionalShowDialog(context, "We found a damage", "It seems that there is a damage in the car\nTherefore you will be charged"
          " ${CarsGlobals.currencyService.getPriceInCurrency(damageValue)}", () {
        _continuePressed();
      });
    } else if (damagesCount == 2) {
      functionalShowDialog(context, "We found a damage", "It seems that there is a damage in the car\nTherefore you will be charged"
          " ${CarsGlobals.currencyService.getPriceInCurrency(damageValue * 2)}", () {
        _continuePressed();
      });
    }



  }
  Future<void> startDirectCharge(PaymentMethod paymentMethod) async {
    print("Payment charge");
  }



  _nextPressed() {
    images.add(shownImage);
    if (currIndex == 1) {
      _calculateDamage();
      return;
    }
    setState(() {
      shownImage = null;
      currIndex += 1;
      title = CarsGlobals.startDriveAngles[currIndex];
    });
  }
  Widget _image() {
    if (shownImage == null) {
      return Image(
          image: AssetImage("assets/upload-image.png")
      );
    } else {
      return Image(
          image: FileImage(shownImage)
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
                         // TODO: change to _take picture
                         onPressed: ()=> _uploadGalleryPhoto(),
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
              Visibility(
                visible: _isLoading,
                child: Column(
                  children: [
                    Text(_calculateStr),
                    CircularProgressIndicator()
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (shownImage != null) {
                    _nextPressed();
                  }
                },
                child: Text("Next"),
                style: shownImage == null ? disabled() : null,
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

