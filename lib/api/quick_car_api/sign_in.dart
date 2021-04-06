import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/data_class/quick_car/cars_list_model.dart';
import 'package:quick_car/data_class/quick_car/user_signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  String myTok;
  void signIn(UserSignIn usi) async {
    var client = http.Client();

    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      Map body = {'username': usi.username, 'password': usi.password };
      var jsonResponse;
      var res = await http.post(Strings.QUICKCAR_URL +"api-token-auth/", body: body);
      if (res.statusCode == 200) {
        jsonResponse = json.decode(res.body);
        print(jsonResponse);
        sharedPreferences.setString("myTok", jsonResponse['token']);
      }
    } catch (Exception) {
      print("error");
      return;
    }
    return;

  }
}