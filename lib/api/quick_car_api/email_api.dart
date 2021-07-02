import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/data_class/quick_car/cars_list_model.dart';

Future<bool> validateEmail(String email) async {
  var client = http.Client();
  var result;

  try {
    var url = "https://zerobounce1.p.rapidapi.com/v2/validate?email=" +
        email +
        "&ip_address=%20";
    var response = await client.get(url, headers: {
      "x-rapidapi-key": "cec120a60dmsha3ae2f4ff86c4dfp10736djsn0a7c7d7c5056",
      "x-rapidapi-host": "zerobounce1.p.rapidapi.com",
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      // jsonString = "{" + '"cars":' + jsonString + "}";
      var jsonMap = json.decode(jsonString);
      print(jsonMap);
    }
  } catch (Exception) {
    print("error");
    return result;
  }
  return result;
}
