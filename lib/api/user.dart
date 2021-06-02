import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_car/constants/strings.dart';
import '../data_class/user_signin.dart';

class UserApi {
  Future<String> login(UserSignIn usi) {}
}
class MockUserApi implements UserApi {
  Future<String> login(userSignIn) {
    // For test:
    return Future.value("123");

  }
}

class QuickCarUserApi implements UserApi {
  String myTok;
  Future<String> login(UserSignIn usi) async {
    try {
      Map body = {'username': usi.email, 'password': usi.password };
      print(body);
      var res = await http.post(Uri.parse(Strings.QUICKCAR_URL +"users/login/"), body: body);
      print(res.body);
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