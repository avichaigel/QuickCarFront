import 'dart:async';

import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_car/constants/strings.dart';
import '../data_class/car_data.dart';
import 'package:quick_car/models/distance.dart';

class CarsApi {
  Future<List<CarData>> getCars (Map<String, String> values) {}

  Future<CarData> postCar(CarData cd) async {}
  Future<CarData> postCarDates(int carId, List<DatePeriod> datePeriod) async {}
  Future<CarData> updateCar(int id, CarData cd) async {}


}
class QuickCarCarsApi implements CarsApi {
  var client = http.Client();

  Future<CarData> postCarDates(int carId, List<DatePeriod> datesPeriod) async {
    print("in post");
    DatePeriod datePeriod = datesPeriod[0];
    var uri = Uri.parse(Strings.QUICKCAR_URL + "cars/cardates/");
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    try {
      Map body = { 'dateFrom': formatter.format(datePeriod.start), 'dateTo': formatter.format(datePeriod.end),'car': carId };
      var res = await http.post(uri,
          headers: {
            'Content-Type':'application/json',
          },
          body: jsonEncode(body));
      if (res.statusCode == 201) {
        print("car dates successful");
      }
    } catch (e) {
      print(e);
    }

  }



  Future<List<Object>> setImages(CarData cd) async {
    List<Object> multipartFileList = [];
    List<File> files = cd.images;
    for (int i = 0; i < files.length; i++) {
      var stream = new http.ByteStream(DelegatingStream.typed(files[i].openRead()));
      var length = await files[i].length();
      String name = (i+1).toString();
      var multipartFile = http.MultipartFile('image' + name, stream, length,
          filename: basename(files[i].path), contentType: new http_parser.MediaType('image', 'png'));
      multipartFileList.add(multipartFile);

    }
    return multipartFileList;
  }

  Future<CarData> postCar(CarData cd) async {
    var uri = Uri.parse(Strings.QUICKCAR_URL + "cars/");

    var request = http.MultipartRequest("POST", uri)
    ..fields['year'] = cd.year.toString()..fields['type'] = cd.type..fields['brand'] = cd.brand
    ..fields['model']=cd.model..fields['kilometers']=cd.kilometers.toString()..fields['longitude'
      ]=cd.longitude.toString()..fields['latitude']=cd.latitude.toString()..
      fields['price_per_day_usd']=cd.pricePerDayUsd.toString();

    List<Object> filesToUpload = await setImages(cd);
    for (int i = 0; i < filesToUpload.length; i++) {
      request.files.add(filesToUpload[i]);
    }
    request.headers['Authorization']= 'TOKEN ' + Strings.TOKEN;
    print("request: " + request.fields.toString());
    final response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 201) {
      response.stream.transform(utf8.decoder).listen((value) {
        print("value returned: " + value.toString());
        cd.id = json.decode(value)['id'];
        print("id: " + cd.id.toString());
      });
      //TODO: delete it
      Timer(Duration(seconds: 3), () => print("after timer"));
      return cd;

    }
    throw Exception("Failed to post car");

  }

  void setLocation(loc.LocationData _myLoc, CarData cd) {
    if (cd.longitude == null || cd.latitude == null) {
      return;
    }
    cd.distanceFromLocation = calculateDistance(_myLoc.latitude, _myLoc.longitude, cd.latitude, cd.longitude);
  }
  Future<List<CarData>> upgradeCars(String responseBody) async {
    final _myLocation = await loc.Location().getLocation();
    Map carsMap = json.decode(responseBody) as Map<String, dynamic>;
    List<CarData> list = [];
    for(int i = 0; i < carsMap['cars'].length; i++) {
      CarData cd = CarData.fromJson(carsMap['cars'][i]);
      setLocation(_myLocation, cd);


      list.add(cd);
    }
    return list;
  }



  Future<List<CarData>> getCars(Map<String, String> queryParameters) async {
    String queryString = "";
    if (!queryParameters.isEmpty)
      queryString = "?" + Uri(queryParameters: queryParameters).query;
    else
      print("there are no query parameters");
    var client = http.Client();
    Future<List<CarData>> result;
    var uri = Strings.QUICKCAR_URL + "cars/";
    var response = await client.get(Uri.parse(uri + queryString));
    if (response.statusCode == 200) {
      var json = response.body;
      json = "{" + '"cars":' + json + "}";
      result = upgradeCars(json);
      print("get cars successful");
      return result;
    }
  }
  Future<CarData> updateCar(int id,CarData cd) async {
    await Future.delayed(Duration(seconds: 3), () {
      print("end calculation");
    });
    return await cd;
  }

}
