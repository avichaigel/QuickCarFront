import 'dart:convert';

import 'package:quick_car/constants/globals.dart';
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/data_class/quick_car/user_signup.dart';
import 'package:http/http.dart' as http;


class SignUpApi {
  void uploadCarLicense(String str) {}
  Future<UserSignUp> signUpNewUser(UserSignUp user) {}
}
class MockSignUpApi implements SignUpApi {
  var client = http.Client();
  MockSignUpApi._() {
    print("in c'tor of mock signup api");
  }
  static final MockSignUpApi _instance = MockSignUpApi._();
  factory MockSignUpApi() {
    return _instance;
  }

  @override
  Future<UserSignUp> signUpNewUser(UserSignUp user) {
    // on success
    Globals.users.add(user);
    return Future<UserSignUp>.value(user);

  }

  @override
  void uploadCarLicense(String str) {
    // TODO: implement uploadCarLicense
  }
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

  void uploadCarLicense(String str) async {
    try {
      print(str);
      var map = {'car_license': str};
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