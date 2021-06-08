import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_car/constants/strings.dart';
import 'package:quick_car/data_class/user_signup.dart';
import '../data_class/user_signin.dart';

class UserApi {
  Future<UserSignIn> login(UserSignIn usi) {}
}


class QuickCarUserApi implements UserApi {
  String myTok;
  Future<UserSignIn> login(UserSignIn usi) async {
    Map body = {'username': usi.email, 'password': usi.password };
    var res = await http.post(Uri.parse(Strings.QUICKCAR_URL +"users/login/"), body: body);
    Map map = json.decode(res.body) as Map<String, dynamic>;
    UserSignIn user = UserSignIn.fromJson(map);
    if (res.statusCode == 200) {
      print("login successful");
      var tokenResponse = await http.post(Uri.parse(Strings.QUICKCAR_URL +"api-token-auth/"), body: body);
      var map = jsonDecode(tokenResponse.body);
      user.token = map['token'];
      return user;
    } else {
      // TODO: do the reasons of fail
      throw 'Login failed';
    }

  }
}