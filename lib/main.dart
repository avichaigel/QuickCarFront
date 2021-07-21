import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/botton_nav.dart';
import 'package:quick_car/states/map_state.dart';
import 'package:quick_car/states/search_state.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/pages/login/login.dart';
import 'package:quick_car/view/pages/signup/upload_car_license.dart';
import 'package:quick_car/view/pages/signup/signup_form.dart';
import 'package:quick_car/view/pages/signup/signup_flow.dart';
import 'package:quick_car/view/pages/upload_car/upload_car_flow.dart';


List<CameraDescription> cameras;

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _getLocationPermission();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> UserState()),
        ChangeNotifierProvider(create: (_)=> SearchState()),
        ChangeNotifierProvider(create: (_)=> MapState()),
      ],
      child: MaterialApp(
        title: 'QuickCar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => BottomNavigation(),
          '/login': (context) => Login(),
          '/signup': (context) => SignupFlow(),
          'upload-car': (context) => UploadCarFlow()
        },
        initialRoute: '/',
      )
    );
  }
  void _getLocationPermission() async {
    var location = new Location();
    try {
      location.requestPermission();
    } on Exception catch (_) {
      print('There was a problem allowing location access');
    }
  }
}

