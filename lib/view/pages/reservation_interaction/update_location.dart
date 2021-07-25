import 'package:flow_builder/flow_builder.dart';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:quick_car/states/end_drive_state.dart';

class UpdateLocation extends StatefulWidget {
  @override
  _UpdateLocationState createState() => _UpdateLocationState();
}

class _UpdateLocationState extends State<UpdateLocation> {
  LatLng _tappedLocation;
  void _getUserLocation() async {
    loc.LocationData position = await loc.Location().getLocation();
    setState(() {
      _tappedLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }
  @override
  Widget build(BuildContext context) {
    Set<Marker> _markers;
    if (_tappedLocation != null) {
      _markers = HashSet<Marker>();
      _markers.add(
          Marker(
            markerId: MarkerId("0"),
            position: _tappedLocation,
          )
      );
    }
    return SafeArea(
        child: Scaffold(
          body: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Please update car location", style: TextStyle(fontSize: 22),),
                  ),
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
                              target: _tappedLocation,
                              zoom: 15,
                            ),
                            markers: _markers,
                            onTap: (LatLng latLng) {
                              setState(() {
                                _tappedLocation = latLng;
                              });
                            },
                          )
                        ],
                      ),
                      height: MediaQuery.of(context).size.height/2
                  ),
                  FutureBuilder(
                      future: setAddress(_tappedLocation),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData)
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Address: " + snapshot.data),
                          );
                        else
                          return Text("Loading...");
                      }
                  ),

                  ElevatedButton(
                      onPressed: () {
                        _continuePressed();
                      } ,
                      child: Text("Confirm New Location")
                  ),

                ],
              )
          ),
        )
    );
  }

  void _continuePressed() {
    context.flow<EndDriveState>().
    complete((state) => state.copyWith(latitude: _tappedLocation.latitude, longitude: _tappedLocation.longitude));
  }

  Future<String> setAddress(LatLng latLng) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      return placeMarks[0].street + ", " + placeMarks[0].locality + ", " + placeMarks[0].country;
    } catch (e) {
      print("no address found");
      return "no address found";
    }
  }
}
