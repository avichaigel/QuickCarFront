import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quick_car/constants/strings.dart';


void addNewCarTest() async {
  Map<String, dynamic> newCarState = {
    "brand": "cds3",
    "model": "ncs.model",
    "type": "ncs.type",
    "year": 123

  };
  try {
    var client = http.Client();
    print("token: " + Strings.TOKEN);
    var response = await client.post(Strings.QUICKCAR_URL + "cars/",
        headers: {
          'Authorization': 'TOKEN 96f1d648cc2b4975ddb01ea2a683caedc6c9f69c',
            'Content-Type':'application/json',
        },
        body: json.encode(newCarState));
    if (response.statusCode == 201) {
      print("New car successfully added");
    }
    print("status code " + response.statusCode.toString());
  } catch (e) {
    print("Error: " + e.toString());
  }


}



class ApiTester extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  addNewCarTest();
                },
                child: (
                  Text("button")
                ),

              ),
            ],
          )
      ),
    );
  }
}
