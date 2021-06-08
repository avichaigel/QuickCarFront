import 'dart:io';
import 'dart:convert';

import 'package:quick_car/constants/strings.dart';
import '../data_class/user_signup.dart';
import 'package:http/http.dart' as http;


class SignUpApi {
  Future<String> uploadCarLicense(File imageFile) {}
  Future<UserSignUp> signUpNewUser(UserSignUp user) {}
}


class QuickCarSignUpApi implements SignUpApi {
  var client = http.Client();
  QuickCarSignUpApi._() {
    print("in c'tor of signup api");
  }
  static final QuickCarSignUpApi _instance = QuickCarSignUpApi._();
  factory QuickCarSignUpApi() {
    return _instance;
  }

  Future<String> uploadCarLicense(File imageFile) async {
    return "car license uploaded";
    try {
      print(imageFile.path);
      var map = {'car_license': imageFile.path};
      String url = Strings.QUICKCAR_URL + "user";
      var response = await client.put(Uri.parse(url),
          headers: {
            'Content-Type':'application/json',
            // 'Authorization': "TOKEN 6a0e8231a37806b025940b9047d2fe3ad6a204c7",
          },
          body: jsonEncode(map));
      if (response.statusCode == 200) {
        print("user successfully added car license photo");
      }
      print(response.statusCode.toString());

    } catch (e) {
      print("Error: " + e.toString());
    }


  }
  Future<UserSignUp> signUpNewUser(UserSignUp user) async {
    print("in signUpNewUser:");
    print("user: " + user.toJson().toString());
    try {
      String url = Strings.QUICKCAR_URL + "users/";
      var response = await client.post(Uri.parse(url),
          headers: {
            'Content-Type':'application/json',
          },
        body: jsonEncode(user.toJson()));
      if (response.statusCode == 201) {
        print("user successfully created");
        return UserSignUp.fromJson(jsonDecode(response.body));
      }
      print("status code " + response.statusCode.toString());
    } catch (e) {
      print("Error: " + e.toString());
    }


  }
}