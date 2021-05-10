import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/data_class/quick_car/car_data.dart';
import 'package:quick_car/data_class/quick_car/cars_list_model.dart';

class CarsApi {
  Future<List<CarData>> getCars () {}
  Future<CarData> postCar(CarData cd) async {}
}
class MockCarsApi implements CarsApi {
  Future<CarData> postCar(CarData cd) async {
    return Future.value(cd);
  }
  Future<List<CarData>> getCars() async {
    List<CarData> myCars = [];
    CarData c1 = CarData("Toyota", "corola", 2000, 100, 32.0, 34.0, 20, "type", null, null);
    CarData c2 = CarData("Lamborghini", "urus", 2000, 100, 32.0, 34.0, 100, "type", null, null);
    return Future.delayed(
        Duration(seconds: 2), () {
      myCars.add(c1);
      myCars.add(c2);

      return myCars;
    });
  }

}
class QuickCarCarsApi implements CarsApi {
  var client = http.Client();

  Future<CarData> postCar(CarData cd) async {
    var stream = new http.ByteStream(DelegatingStream.typed(cd.image1.openRead()));
    var length = await cd.image1.length();

    var uri = Uri.parse(Strings.QUICKCAR_URL + "cars/");

    var request = http.MultipartRequest("POST", uri)
    ..fields['year'] = cd.year.toString()..fields['type'] = cd.type..fields['brand'] = cd.brand
    ..fields['model']=cd.model..fields['kilometers']=cd.kilometers.toString()..fields['longitude'
      ]=cd.longitude.toString()..fields['latitude']=cd.latitude.toString()..
      fields['price_per_day_usd']=cd.pricePerDayUsd.toString();
    var multipartFile = http.MultipartFile('image1', stream, length,
        filename: basename(cd.image1.path));
    //contentType: new MediaType('image', 'png'));
    request.files.add(multipartFile);
    request.headers['Authorization']= 'TOKEN ' + Strings.TOKEN;
    print("requset" +request.fields.toString());
    final response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 201) {
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      return cd;
    }
    throw Exception("Failed to post car");

  }


  Future<List<CarData>> getCars() async {
    var client = http.Client();
    var result;

    try {
      var url = Strings.QUICKCAR_URL + "cars/";
      var response = await client.get(Uri.parse(url),  headers: {
        'Authorization': 'TOKEN ${Strings.TOKEN}',
      });
      if (response.statusCode == 200) {
        var jsonString = response.body;
        jsonString = "{" + '"cars":' + jsonString + "}";
        var jsonMap = json.decode(jsonString);
        result = Cars.fromJson(jsonMap);
      }
    } catch (Exception) {
      print("error");
      return result;
    }
    return result;

  }

}