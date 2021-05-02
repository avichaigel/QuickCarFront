
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quick_car/api/api_tester.dart';
import 'package:quick_car/view/pages/upload_car/car_photos.dart';
import 'package:quick_car/view/widgets/country_list_pick.dart';
import 'package:quick_car/view/widgets/images.dart';

class PlayGroundPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PalyGround();

}

class PalyGround extends State<PlayGroundPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarPhotos()
    );
  }

}class GeoListenPage extends StatefulWidget {
  @override
  _GeoListenPageState createState() => _GeoListenPageState();
}

class _GeoListenPageState extends State<GeoListenPage> {
  Location _location;
  bool _locNotFound = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
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
                  style: TextStyle(color: Colors.black),
                ),

               onPressed: () async {
                  this._cityFocusNode.unfocus();
                  try {
                    List<Location> locations = await locationFromAddress(
                      _streetController.text + _numberController.text + ", " + _cityController.text
                    );
                    setState(() {
                      print("in set state");
                      createMapDialog(LatLng(locations[0].latitude, locations[0].longitude));
                      _location = locations[0];
                    });

                  } catch (e) {
                    print("address is not found");
                    setState(() {
                      _locNotFound = true;

                    });
                  }
                  },
                ),
              ),
            Visibility(
              child: Text("Address is not found",
                style: TextStyle(
                  color: Colors.red
                ),
              ),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: _locNotFound,
            ),


          ],
        ),
      ),
    );
  }

  createMapDialog(LatLng latLng) {
    return showDialog(context: context, builder: (context) {
      Set<Marker> _markers = HashSet<Marker>();
      _markers.add(
        Marker(
            markerId: MarkerId("0"),
            position: latLng,
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
                  target: latLng,
                  zoom: 15,
                ),
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
              height: MediaQuery.of(context).size.height/2
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("confirm")
                ),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("back")
                ),

              ],
            )

          ],
        );
    });
  }
}