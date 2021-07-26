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
  Future<bool>isCarDamaged(File image) async {
    var uri = Uri.parse('http://f33ddebb-ea87-400c-88ef-6bf5e2e23ba0.centralus.azurecontainer.io/score');
    var bytes = await image.readAsBytes();
    try {
    var response = await http.post(uri, body: bytes).timeout(Duration(seconds: 5));
    if (response.statusCode == 200) {
      print("Successful post");
      if (response.body == "false") {
        print("Car is not damaged");
        return false;
      }
      else {
        print("Car is damaged");
        return true;
      }
    } else {
      throw "Service is not available";
    }
    } catch (Exception) {
      return false;
    }
  }
}