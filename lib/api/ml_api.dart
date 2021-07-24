import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:quick_car/data_class/car_detection_response.dart';

class MLApi {
  Future<CarDetectionResponse>isCar(File image) async {
    print("Check if image is car");
    var uri = Uri.parse('http://1a29cae6-58b5-4461-bec2-8bd5ab7728a6.centralus.azurecontainer.io/score');
    var bytes = await image.readAsBytes();
    var response = await http.post(uri, body: bytes);
    if (response.statusCode == 200) {
      print("Successful post");
      if (response.body == "false")
        return CarDetectionResponse(false);
      else {
        String type = response.body.split("\"")[3];
        return CarDetectionResponse(true, type: type);
      }
    } else {
      throw "Service is not available";
    }
  }
}