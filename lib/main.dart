import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/botton_nav.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/pages/login/login.dart';
import 'package:quick_car/view/pages/signup/signup_form.dart';
import 'package:quick_car/view/pages/signup/signup_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _getLocationPermission();
    return ChangeNotifierProvider(
      create: (_) => UserState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => BottomNavigation(),
          '/login': (context) => Login(),
          '/signup': (context) => SignUpRoutes(context)
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

