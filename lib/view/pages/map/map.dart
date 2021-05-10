import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  Set<Marker> _markers = HashSet<Marker>();
  bool _showMapStyle = false;
  LocationData _currentLocation;

  GoogleMapController _mapController;
  BitmapDescriptor _markerIcon;

  @override
  void initState() {
    super.initState();
    _setMarkerIcon();

  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  void _setMarkerIcon() async {
    _markerIcon = BitmapDescriptor.fromBytes(await _getBytesFromAsset('assets/car-marker.png', 100));
  }
  void _getLocation() async {
    try {
      _currentLocation = await Location().getLocation();
      setState(() {

      });
    } catch (e) { }
  }


  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() async {
      _markers.add(
        Marker(
            markerId: MarkerId("0"),
            position: LatLng(37.77483, -122.41942),
            infoWindow: InfoWindow(
              title: "Los Angeles",
              snippet: "An Interesting city",
            ),
            icon: _markerIcon
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentLocation != null ? LatLng(_currentLocation.latitude, _currentLocation.longitude)
                 : LatLng(41.9, 12.49),
                zoom: 12,
              ),
              //markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
              child: Text("Car data"),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.map),
        onPressed: () {
          setState(() {
            print("map pressed");
          });
        },
      ),
      );
  }
}