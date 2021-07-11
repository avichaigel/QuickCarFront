import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:quick_car/data_class/car_detection_response.dart';
import 'package:async/async.dart';

class MLApi {
  Future<CarDetectionResponse>isCar(File image) async {
    print("Check if image is car");
    var uri = Uri.parse("http://84434df4-4d6e-4025-9374-e00a4cb25e26.southcentralus.azurecontainer.io/score");
    var bytes = await image.readAsBytes();
    try {
      var response = await http.post(uri, body: bytes);
      if (response.statusCode == 200) {
        print("Successful post");
        if (response.body == "false")
          return CarDetectionResponse(false);
        else {
          String type = response.body.split("\"")[3];
          return CarDetectionResponse(true, type: type);
        }
      }
    } catch(e) {
      print(e.toString());
    }
  }
}