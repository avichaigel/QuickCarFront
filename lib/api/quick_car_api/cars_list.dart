import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/data_class/car_model.dart';
import 'package:quick_car/data_class/quick_car/cars_list_model.dart';

class CarListApi {
  Future<Welcome> getCars() async {
    var client = http.Client();
    var result;

    try {
      var url = Strings.QUICKCAR_URL + "cars/";
      var response = await client.get(url,  headers: {'Authorization': "TOKEN 6a0e8231a37806b025940b9047d2fe3ad6a204c7"});
      if (response.statusCode == 200) {
        var jsonString = response.body;
        jsonString = "{" + '"cars":' + jsonString + "}";
        var jsonMap = json.decode(jsonString);
        result = Welcome.fromJson(jsonMap);
      }
    } catch (Exception) {
      print("error");
      return result;
    }
    return result;

  }
}