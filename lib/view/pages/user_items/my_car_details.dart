import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/data_class/car_data.dart';
import 'package:quick_car/states/user_state.dart';

class MyCarDetails extends StatefulWidget {
  CarData carData;
  MyCarDetails(this.carData);
  @override
  _MyCarDetailsState createState() => _MyCarDetailsState();
}

class _MyCarDetailsState extends State<MyCarDetails> {
  CarData carData;
  bool _isLoading = false;
  bool _isEditPhotos = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carData = widget.carData;
  }
  @override
  Widget build(BuildContext context) {


    Icon arrowIcon(bool b) {
      if (b) {
        return Icon(Icons.arrow_drop_up);
      } else {
        return Icon(Icons.arrow_drop_down);
      }
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<UserState>(
              builder: (context, state, child) {
                return Column(
                  children: [
                    Card(
                      child: ListTile(
                          tileColor: Colors.lightBlue,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Edit car photos", style: TextStyle(
                                fontSize: 20
                              ),),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _isEditPhotos = !_isEditPhotos;
                                  });
                                },
                                child: arrowIcon(_isEditPhotos),
                              )
                            ],
                          )
                      ),
                    ),

                    AnimatedOpacity(
                      // If the widget is visible, animate to 0.0 (invisible).
                      // If the widget is hidden, animate to 1.0 (fully visible).
                      opacity: _isEditPhotos ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      // The green box must be a child of the AnimatedOpacity widget.
                      child: Visibility(
                        visible: _isEditPhotos,
                        child: _CarPhotos(carData.images)
                      )
                    ),
                    Text("Set new location"),
                    Text("Edit dates availability"),
                    TextButton.icon(
                      onPressed: () {
                      },
                      icon: Icon(Icons.delete),
                      label: Text("Remove credit card"),

                    )
                  ],
                );

              }
          )
      ),
    )
    );
  }
}

class _CarPhotos extends StatefulWidget {
  List<File> images;
  _CarPhotos(this.images);
  @override
  _CarPhotosState createState() => _CarPhotosState();
}

class _CarPhotosState extends State<_CarPhotos> {
  int currIndex;
  Border imageBorder(int imageIdx) {
    return Border.all(
        width: 3.0, color: imageIdx == currIndex ? Colors.greenAccent : Colors.grey.withOpacity(0));
  }

  Container photoWidget(File file, int index) {
    return Container(
      decoration: BoxDecoration(
          border: imageBorder(1)),
      child: GestureDetector(
      child: Container(
      width: 300,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black)
      ),
      child: file == null  ? Image(
        image: AssetImage("assets/upload-image.png"),
      ) : FittedBox(
        // child: Image(
        //   image: FileImage(file),
        child: Image.network(file.path),

      ),
    ),
    onTap: () => setState(() => currIndex = index)
    )
    );

  }
  List<Container> imagesWidget = [];
  @override
  void initState() {
    super.initState();
    print("in init state: len of files: ${widget.images.length}");
    currIndex = 0;
    for (int i = 0; i < CarsGlobals.maximumCarImages; i++) {
      if (i < widget.images.length)
        imagesWidget.add(photoWidget(widget.images[i],i));
      else
        imagesWidget.add(photoWidget(null,i));
    }
  }
  @override
  Widget build(BuildContext context) {
    print("in build");

      return SizedBox(
      height: 300,
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(3.0),
            sliver: SliverGrid.count(
                mainAxisSpacing: 1, //horizontal space
                crossAxisSpacing: 1, //vertical space
                crossAxisCount: 3, //number of images for a row
                children: imagesWidget
            ),
          ),
        ],
      ),
    );
  }
}

//https://www.google.com/maps/uv?pb=!1s0x151d4b713718af91%3A0x4a89eeb1228eaf77!3m1!7e115!4shttps%3A%2F%2Flh5.googleusercontent.com%2Fp%2FAF1QipPKYAyKqRF3dtIFAPnN7aCmuchbgU3HyhVRKiZE%3Dw355-h200-k-no!5zY2FyIGltYWdlIC0g15fXmdek15XXqSDXkS1Hb29nbGU!15sCgIgAQ&imagekey=!1e10!2sAF1QipPKYAyKqRF3dtIFAPnN7aCmuchbgU3HyhVRKiZE&hl=iw&sa=X&ved=2ahUKEwjP0e-A1PjwAhWXhf0HHV0EA4MQoiowHnoECEcQAw#
