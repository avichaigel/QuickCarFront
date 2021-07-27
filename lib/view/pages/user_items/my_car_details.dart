import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'dart:collection';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/data_class/car_data.dart';
import 'package:quick_car/data_class/car_detection_response.dart';
import 'package:quick_car/states/my_car_details_state.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/widgets/camera.dart';
import 'package:quick_car/view/widgets/date_picker.dart';
import 'package:quick_car/view/widgets/images.dart';
import 'package:quick_car/view/widgets/messages.dart';

class MyCarDetails extends StatefulWidget {
  CarData carData;
  MyCarDetails(this.carData);
  @override
  _MyCarDetailsState createState() => _MyCarDetailsState();
}

class _MyCarDetailsState extends State<MyCarDetails> {
  CarData carData;
  CarData clonedCar;
  int openNow;
  List<bool> _isLoadOpen = List.filled(3, false);
  MyCarDetailsState state;
  void openWindow(int index) {
    setState(() {
      _isLoadOpen = List.filled(3, false);
      if (openNow == null || openNow != index) {
        _isLoadOpen[index] = true;
        openNow = index;
      } else {
        openNow = null;
      }
    });
  }
  @override
  void initState() {
    print("init state");
    super.initState();
    carData = widget.carData;
    List<File> cloneImages = [];
    for (int i = 0; i < CarsGlobals.maximumCarImages; i++) {
      if (i < carData.images.length) {
        cloneImages.add(carData.images[i]);
      } else{
        cloneImages.add(null);
      }
    }

    clonedCar = carData.copyWith(cloneImages, carData.carDates,
        carData.latitude, carData.longitude );
  }
  @override
  Widget build(BuildContext context) {
    Icon arrowIcon(int index) {
      if (_isLoadOpen[index]) {
        return Icon(Icons.arrow_drop_up);
      } else {
        return Icon(Icons.arrow_drop_down);
      }
    }
    List<dp.DatePeriod> dates = [];
    for (int i = 0; i < clonedCar.carDates.length; i++) {
      dates.add(clonedCar.carDates[i].datePeriod);
    }
    MyCarDetailsState carDetailsState = MyCarDetailsState(clonedCar.images, clonedCar.latitude, clonedCar.longitude, dates);
    return ChangeNotifierProvider(create: (_)=>
        carDetailsState,
        child: Scaffold(
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
                        fontSize: 20, color: Colors.white
                    ),),
                    InkWell(
                      onTap: () {
                        openWindow(0);
                      },
                      child: arrowIcon(0),
                    )
                  ],
                )
            ),
          ),
          AnimatedOpacity(
              opacity: _isLoadOpen[0] ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              // The green box must be a child of the AnimatedOpacity widget.
              child: Visibility(
                  visible: _isLoadOpen[0],
                  child: _CarPhotos()
              )
          ),
          Card(
            child: ListTile(
                tileColor: Colors.lightBlue,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Set new location", style: TextStyle(
                        fontSize: 20, color: Colors.white
                    ),),
                    InkWell(
                      onTap: () {
                        openWindow(1);
                      },
                      child: arrowIcon(1),
                    )
                  ],
                )
            ),
          ),
          AnimatedOpacity(
              opacity: _isLoadOpen[1] ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              // The green box must be a child of the AnimatedOpacity widget.
              child: Visibility(
                  visible: _isLoadOpen[1],
                  child: _CarLocation()
              )
          ),
          Card(
            child: ListTile(
                tileColor: Colors.lightBlue,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Edit dates availability", style: TextStyle(
                        fontSize: 20, color: Colors.white
                    ),),
                    InkWell(
                      onTap: () {
                        openWindow(2);
                      },
                      child: arrowIcon(2),
                    )
                  ],
                )
            ),
          ),
          AnimatedOpacity(
              opacity: _isLoadOpen[2] ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              // The green box must be a child of the AnimatedOpacity widget.
              child: Visibility(
                  visible: _isLoadOpen[2],
                  child: _DatesAvailability()
              )
          ),
          ElevatedButton(
            onPressed: () {
              // carsApi-> delete car id
              state.removeCarToRentOut(carData.id);
              Navigator.pop(context);
            },
            child: Text("Remove Car"),
            style: ElevatedButton.styleFrom(primary: Colors.red),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                MyCarDetailsState currState = Provider.of<MyCarDetailsState>(context, listen: false);
                CarsGlobals.carsApi.updateCar(carData.id, clonedCar, currState.carDates).then((value) {
                  carData.images = clonedCar.images;
                  carData.latitude = clonedCar.latitude;
                  carData.longitude = clonedCar.longitude;
                  carData.carDates = clonedCar.carDates;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Update successful"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                });
              },
            child: Text("Submit"),
            ),
          )
        ],
      );

    }
    )
    ),
    )
    )

    );
  }
}

class _CarPhotos extends StatefulWidget {
  @override
  _CarPhotosState createState() => _CarPhotosState();
}

class _CarPhotosState extends State<_CarPhotos> {
  int currIndex;
  Border imageBorder(int imageIdx) {
    if (currIndex == imageIdx)
    return Border.all(
        width: 3.0, color: imageIdx == currIndex ? Colors.greenAccent : Colors.grey.withOpacity(0));
  }
  String _errMsg;
  bool _err;
  Container photoWidget(File file, int index, bool isNew) {
    return Container(
      decoration: BoxDecoration(
          border: imageBorder(index)),
      child: GestureDetector(
      child: Container(
      width: 300,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black)
      ),
      child: file == null  ? emptyImage() : FittedBox(
        child: isNew ? Image(image: FileImage(file)) : Image.network(file.path),
      ),
    ),
    onTap: () => setState(() => currIndex = index)
    )
    );

  }
  List<File> myImages;
  File newImage;
  @override
  void initState() {
    super.initState();
    currIndex = 0;
    _err = false;
    _errMsg = '';
  }
  @override
  Widget build(BuildContext context) {
      return Consumer<MyCarDetailsState>(
          builder: (context, state, child) {
            myImages = state.carImages;
      List<Container> imagesWidget = [];
      for (int i = 0; i < CarsGlobals.maximumCarImages; i++) {
        if (i < myImages.length)
          imagesWidget.add(photoWidget(myImages[i], i, state.isImageNew[i]));
        else {
          myImages.add(null);
          imagesWidget.add(photoWidget(null, i, state.isImageNew[i]));
        }
      }
      return Column(
        children: [
          SizedBox(
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
          ),
          Visibility(
            visible: _err,
              child: showAlert(_errMsg, () { setState(() {_err = !_err;});},)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () => takePicture(state),
                label: Text("Camera"),
                icon: Icon(Icons.camera_alt),

              ),
              TextButton.icon(
                  onPressed: () => galleryPhoto(state),
                  icon: Icon(Icons.image),
                  label: Text("Gallery")
              ),
              TextButton.icon(
                  onPressed: () async{
                      try {
                        state.removePhoto(currIndex);
                      } catch (e) {
                        print("Exception delete photo: " + e.toString());
                      }
                  },
                  icon: Icon(Icons.delete),
                  label: Text("Delete"))
            ],
          ),
        ],
      );
    }
    );

  }
  void takePicture(MyCarDetailsState state) async {
    await Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) => Camera(callBack)));
    CarDetectionResponse cdr = await CarsGlobals.mlApi.isCar(newImage);
    if (!cdr.isCar) {
      setState(() {
        _err = true;
        _errMsg = "Image must contain a car";
      });
      return;
    }
    state.updatePhoto(newImage, currIndex);
  }
  void callBack(String path) {
    newImage = File(path);
  }
  void galleryPhoto(MyCarDetailsState state) async {
    PickedFile image = await CarsGlobals.picker.getImage(
        source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    try {
      File newImage = File(image.path);
      CarDetectionResponse cdr = await CarsGlobals.mlApi.isCar(newImage);
      if (!cdr.isCar) {
        setState(() {
          _err = true;
          _errMsg = "Image must contain a car";

        });
        return;
      }
      state.updatePhoto(newImage, currIndex);
      for (int i = 0; i < 4; i++) {
        if (myImages[i]  != null)
          print(myImages[i].path);
      }
    } catch (e) {
      print("Exception photo from gallery: " + e.toString());
      return;
    }

  }
  }

class _CarLocation extends StatefulWidget {
  @override
  _CarLocationState createState() => _CarLocationState();
}

class _CarLocationState extends State<_CarLocation> {
  @override
  Widget build(BuildContext context) {

    Future<String> setAddress(LatLng latLng) async {
      try {
        List<Placemark> placeMarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
        return placeMarks[0].street + ", " + placeMarks[0].locality + ", " + placeMarks[0].country;
      } catch (e) {
        print("no address found");
        return "no address found";
      }
    }
    return Consumer<MyCarDetailsState> (
      builder:  (context, state, child) {
        LatLng currLoc = LatLng(state.latitude, state.longitude);
        Set<Marker> _markers = HashSet<Marker>();
        _markers.add(
            Marker(
              markerId: MarkerId("0"),
              position: currLoc,
            )
        );
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 3,
                          color: Colors.black
                      )
                  ),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(state.latitude, state.longitude),
                      zoom: 15,
                    ),
                    markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onTap: (LatLng latLng) {
                      state.updateLocation(latLng.latitude, latLng.longitude);}
                  ),
                  height: MediaQuery.of(context).size.height/2
              ),
            ),
            FutureBuilder(
              future: setAddress(currLoc),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData)
                  return Text("Address: " + snapshot.data);
                else
                  return Text("Loading...");
                }
                ),
          ],
        );
      } ,
    );


  }
}

class _DatesAvailability extends StatefulWidget {
  @override
  _DatesAvailabilityState createState() => _DatesAvailabilityState();
}

class _DatesAvailabilityState extends State<_DatesAvailability> {
  DatePeriod _currDatePeriod = DatePeriod(DateTime.now().add(Duration(days: 4)), DateTime.now());
  List<dp.DatePeriod> _availabilityDates;

  void onChangeDate(datePeriod) {
    setState(() {
      _currDatePeriod = datePeriod;
    });
  }
  Table createTable(MyCarDetailsState state) {
    List<TableRow> rows = [];
    rows.add( TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("Start date", style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text("End date", style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          Text("")
        ]
    )
    );
    for (int i = 0; i < _availabilityDates.length; i++) {
      rows.add(TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(DateFormat("yyyy-MM-dd").format(_availabilityDates[i].start)),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(DateFormat("yyyy-MM-dd").format(_availabilityDates[i].end)),
            ),
            InkWell(
              onTap: () {
                state.removeDates(_availabilityDates[i]);
              } ,
              child: Icon(Icons.clear),
            )
          ]
      ));
    }
    return Table(
      columnWidths: {
        0: FlexColumnWidth(4),
        1: FlexColumnWidth(4),
        2: FlexColumnWidth(1),
      },
      border: TableBorder.all(),
      children: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyCarDetailsState>(
      builder: (context, state, child) {
        _availabilityDates = state.carDates;
        return Column(
      children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: createTable(state),
        ),
        Container(
          child: dp.RangePicker(
            selectedPeriod: _currDatePeriod,
            onChanged: onChangeDate,
            // selectableDayPredicate: _isSelectable,
            datePickerStyles: styles,
            firstDate: DateTime(2021),
            lastDate: DateTime(2023),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              state.addDates(_currDatePeriod);
            },
            child: Text("Add")
        )
      ],
    );
  });
  }
}
