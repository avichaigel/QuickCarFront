import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_car/constants/globals.dart';
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/data_class/quick_car/user_signin.dart';
import 'package:quick_car/data_class/quick_car/user_signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApi {
  Future<String> login(UserSignIn usi) {}
}
class MockUserApi implements UserApi {
  Future<String> login(userSignIn) {
    // For test:
    return Future.value("123");

    // Mocked Sign-up users:
    List<UserSignUp> myUsers = Globals.users;

    for(final userSignUp in myUsers) {
      if (userSignUp.password == userSignIn.password && userSignUp.email == userSignIn.email) {
        // get somehow the full user details from the server
        return Future.value("123");
      } else {
        throw Exception("no user found");
      }
    }
  }
}

class QuickCarUserApi implements UserApi {
  String myTok;
  Future<String> login(UserSignIn usi) async {
    try {
      Map body = {'username': usi.email, 'password': usi.password };
      print(body);
      var res = await http.post(Uri.parse(Strings.QUICKCAR_URL +"users/login/"), body: body);
      if (res.statusCode == 200) {
        print("login successful");
        var tokenResponse = await http.post(Uri.parse(Strings.QUICKCAR_URL +"api-token-auth/"), body: body);
        var map = jsonDecode(tokenResponse.body);
        return map['token'];
      } else {
        // TODO: do the reasons of fail
        throw 'login failed';
      }
    } catch (Exception) {
      throw Exception;
    }

  }
}