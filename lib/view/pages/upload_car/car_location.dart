import 'package:flow_builder/flow_builder.dart';

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quick_car/states/new_car_state.dart';
import 'package:quick_car/view/widgets/messages.dart';

class CarLocation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CarLocationState();

}

class _CarLocationState extends State<CarLocation> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: GeoListenPage()
        )
    );
  }

}class GeoListenPage extends StatefulWidget {
  @override
  _GeoListenPageState createState() => _GeoListenPageState();
}

class _GeoListenPageState extends State<GeoListenPage> {
  Location _location;
  bool _locNotFound = false;
  LatLng tappedLocation;
  TextEditingController _streetController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  final _cityFocusNode = FocusNode();

  void onTapTextField() {
    setState(() {
      _locNotFound = false;
    });
  }


  @override
  void initState() {
    super.initState();

  }
  void _continuePressed() {
    _location = Location(latitude: tappedLocation.latitude, longitude: tappedLocation.longitude,
    timestamp: DateTime.now());
    context
        .flow<NewCarState>()
        .update((carState) => carState.copywith(latitude: _location.latitude, longitude: _location.longitude)
    );
  }
  @override
  Widget build(BuildContext context) {
    Set<Marker> _markers;
    if (tappedLocation != null) {
      _markers = HashSet<Marker>();
      _markers.add(
          Marker(
            markerId: MarkerId("0"),
            position: tappedLocation,
          )
      );    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Car location"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            TextField(
              onTap: onTapTextField,
              keyboardType: TextInputType.text,
              controller: _streetController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Street',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              onTap: onTapTextField,
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Number',
              ),
            ),
            SizedBox(
              height: 30,
            ),

            TextField(
              onTap: onTapTextField,
              focusNode: _cityFocusNode,
              controller: _cityController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'City',
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onLongPress: () => print("hello from long press"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // background
                  onPrimary: Colors.white, // foreground
                ),
                child: Text(
                  "Get Location",
                  style: TextStyle(color: Colors.white),
                ),

                onPressed: () async {
                  _locNotFound = false;
                  this._cityFocusNode.unfocus();
                  try {
                    var x = _streetController.text + " " + _numberController.text + ", " + _cityController.text;
                    print("address: " + x);
                    List<Location> locations = await locationFromAddress(x);
                    setState(() {
                      tappedLocation = LatLng(locations[0].latitude, locations[0].longitude);
                      _location = locations[0];
                    });

                  } catch (e) {
                    print(e);
                    print("address is not found");
                    setState(() {
                      _locNotFound = true;
                    });
                  }
                },
              ),
            ),
            Visibility(
              child: showAlert("Address is not found", () {
                setState(() {
                  _locNotFound = false;
                });
              }),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: _locNotFound,
            ),
            tappedLocation != null && _markers != null ? Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 3,
                            color: Colors.black
                        )
                    ),
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: tappedLocation,
                            zoom: 15,
                          ),
                          markers: _markers,
                          onTap: (LatLng latLng) {
                            setState(() {
                              tappedLocation = latLng;
                            });
                          },
                        )
                      ],
                    ),
                    height: MediaQuery.of(context).size.height/2
                ),
                ElevatedButton(
                    onPressed: () {
                      _continuePressed();
                    } ,
                    child: Text("Confirm Location")
                ),

              ],
            ) : Text("")

          ],
        ),
      ),
    );
  }

  createMapDialog() {
    return showDialog(context: context, builder: (context) {
      print("in here");
      Set<Marker> _markers = HashSet<Marker>();
      _markers.add(
          Marker(
            markerId: MarkerId("0"),
            position: tappedLocation,
          )
      );

      return Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 3,
                      color: Colors.black
                  )
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: tappedLocation,
                  zoom: 15,
                ),
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onTap: (LatLng latLng) {
                  setState(() {
                    tappedLocation = latLng;
                  });
                },
              ),
              height: MediaQuery.of(context).size.height/2
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                    _continuePressed();
                    } ,
                  child: Text("Confirm Location")
              ),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Back")
              ),

            ],
          ),

        ],
      );
    });
  }
}
