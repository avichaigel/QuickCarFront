import 'package:provider/provider.dart';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/data_class/car_data.dart';
import 'package:quick_car/states/map_state.dart';
import 'package:quick_car/view/pages/cars_list/car_item.dart';

class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  Set<Marker> _markers = HashSet<Marker>();
  CarData currCar;
  bool _isCardVisible = false;
  List<CarData> cars = [];

  static LatLng _initialPosition;
  void _getUserLocation() async {
    LocationData position = await Location().getLocation();
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }
  GoogleMapController _mapController;
  static BitmapDescriptor _markerIcon;

  @override
  void initState() {
    super.initState();
    _setMarkerIcon();
    _getUserLocation();
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  void _setMarkerIcon() async {
    _markerIcon = BitmapDescriptor.fromBytes(await _getBytesFromAsset('assets/car-marker.png', 50));
  }



  void _onMapCreated(GoogleMapController controller) {
    if (_mapController == null) {
      _mapController = controller;
    }

    cars.forEach((element) {
          _markers.add(Marker(
            markerId: MarkerId(element.id.toString()),
            position: LatLng(element.latitude, element.longitude),
            infoWindow: InfoWindow(
              title: "${element.brand} ${element.model}",
              snippet: element.distanceFromLocation != null ? "${element.distanceFromLocation.toInt()} km away" : "",
            ),
            onTap: () {
              setState(() {
                _isCardVisible = !_isCardVisible;
                currCar = element;
              });
            },
            icon: _markerIcon
          ));
        });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _initialPosition == null ? Container(
          child: Center(
            child:Text('loading map..', style: TextStyle(fontFamily: 'Avenir-Medium', color: Colors.grey[400]),),
          ),
        ) : Container(
              child: Stack(
                children: <Widget>[
                  Consumer<MapState>(
                    builder: (context, state, child) {
                      print("map state builder");
                      print(state.carsList.length);
                      cars = state.carsList;
                      _onMapCreated(_mapController);
                      return GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _initialPosition,
                          zoom: 12,
                        ),
                        markers: _markers,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        onTap: (LatLng latLng) {
                          print("on tap");
                          setState(() {
                            if (_isCardVisible)
                              _isCardVisible = !_isCardVisible;
                          });
                        },
                      );
                    }
                  ),
            Visibility(
              visible: _isCardVisible,
              child: Container(
                margin: const EdgeInsets.only(bottom: 60.0),
                alignment: Alignment.bottomCenter,
                  child: carCard()
              ),
            ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Icon(Icons.refresh),
                      onTap: () => Provider.of<MapState>(context, listen: false).loadCars()
                      ,
                    ),
                  )
          ],
        ),
      )
      ),
      );
  }
  Card carCard() {
    if (currCar == null) {
      return Card();
    }
    double height = MediaQuery.of(context).size.height;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: height/4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: height/4,
              child: SingleChildScrollView(
                child:Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text(currCar.brand + " " + currCar.model, style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20,/* overflow: TextOverflow.fade*/
                        ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(currCar.pricePerDayUsd.toString() + "\$ per day"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(currCar.type + " car"),
                    ),
                    bookNowButton(currCar, context)
                  ],
                ) ,
              ) ,
            ),
            Container(
              height: height/4,
              width: height/4,

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        color: Colors.lightBlue.shade50,
                          child: Image.network(currCar.images[0].path))
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}