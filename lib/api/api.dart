import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/models/car_model.dart';
import 'package:quick_car/models/category_model.dart';
import 'package:quick_car/models/news_model.dart';


class API {
  Future<CarMetadata> getCars() async {
    print("in get cars");
    var client = http.Client();
    var result;

    try {
      var url = Strings.CAR_URL;
      var response = await client.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        jsonString = "{" + '"cars":' + jsonString + "}";
        var jsonMap = json.decode(jsonString);
        result = CarMetadata.fromJson(jsonMap);
      }
    } catch (Exception) {
      print("error");
      return result;
    }
    return result;

  }
}