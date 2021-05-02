import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/data_class/quick_car/cars_list_model.dart';
import 'package:quick_car/states/new_car_state.dart';

class CarsApi {
  Future<Cars> getCars () {}
  void postCar(NewCarState ncs) async {}
}
class MockCarsApi implements CarsApi {
  List<Car> myCars = [];
  void postCar(NewCarState ncs) async {}

  MockCarsApi() {
    print("in MockCarsListApi C'tor");
  }
  Future<Cars> getCars() async {
    Car c1 = Car(id: 1, type: "family", color: "black", year: "200000");
    Car c2 = Car(id: 2, type: "private", color: "black", year: "1999");
    Car c3 = Car(id: 3, type: "----", color: "black", year: "1999");
    return Future.delayed(
        Duration(seconds: 2), () {
      myCars.add(c1);
      myCars.add(c2);
      myCars.add(c3);
      Cars cars = Cars(cars: myCars);
      return cars;
    });
  }

}
class QuickCarCarsApi implements CarsApi {
  var client = http.Client();

  void postCar(NewCarState ncs) async {
    try {
      int year = int.parse(ncs.manufYear);
      var response = await client.post(Strings.QUICKCAR_URL + "cars/",
          headers: {
            'Authorization': 'TOKEN ${Strings.TOKEN}'
//             'Content-Type':'application/json',
          },
          body: json.encode(ncs));
      if (response.statusCode == 201) {
        print("New car successfully added");
      }
      print("status code " + response.statusCode.toString());
    } catch (e) {
      print("Error: " + e.toString());
    }

  }
  Future<Cars> getCars() async {
    var client = http.Client();
    var result;

    try {
      var url = Strings.QUICKCAR_URL + "cars/";
      var response = await client.get(url,  headers: {
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