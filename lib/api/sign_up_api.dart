import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http_parser/http_parser.dart' as http_parser;
import 'dart:async';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:quick_car/constants/strings.dart';
import '../data_class/user_signup.dart';
import 'package:http/http.dart' as http;


class SignUpApi {
  Future<File> uploadCarLicense(File imageFile, int id) {}
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

  Future<File> uploadCarLicense(File imageFile, int id) async {
    Completer fileCompleter = Completer<File>();
    var uri = Uri.parse(Strings.QUICKCAR_URL + "users/usersprofiles/" + id.toString() + "/");
    var request = http.MultipartRequest("PATCH", uri);
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile('image1', stream, length,
        filename: basename(imageFile.path));
    request.files.add(multipartFile);
    final response = await request.send();
    print("status code: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) {
        print("value from listen: " + value);
        fileCompleter.complete(File(jsonDecode(value)['license']));
      });
      return fileCompleter.future;
    } else {
      throw Exception("Failed to upload car license to server");
    }

  }

  Future<UserSignUp> signUpNewUser(UserSignUp user) async {
    String url = Strings.QUICKCAR_URL + "users/";
    var response = await client.post(Uri.parse(url),
        headers: {'Content-Type':'application/json',},
        body: jsonEncode(user.toJson()));
    if (response.statusCode == 201) {
      UserSignUp usu = UserSignUp.fromJson(jsonDecode(response.body));
      Map body = {'username': user.email, 'password': user.password };
      var res = await http.post(Uri.parse(Strings.QUICKCAR_URL +"users/login/"), body: body);
      if (res.statusCode != 200) {
        throw 'New user was created but cannot get it now. You can try login';
      }
      Map newUserDetails = json.decode(res.body) as Map<String, dynamic>;
      usu.id = newUserDetails["id"];
      sendCurrencyToDB(user).then((success){
        if (!success){
          // user.currencyCode = Strings.USD;
          null;
        }
      });
      return usu;
    } else if (response.body.contains("A user with that username already exists.")) {
      throw "Email already exists";
    }
  }

  Future<bool> sendCurrencyToDB(UserSignUp user) async {
    var uri = Uri.parse(Strings.QUICKCAR_URL + "users/usersprofiles/" + user.id.toString() + "/");
    var response = await client.patch(uri,
        headers: {'Content-Type':'application/json',},
        body: jsonEncode({
          "currency": user.currencyCode,
        }));
    if (response.statusCode == 200) {
      print("currency saved successfully");
      return true;
    } else {
      print("error while saving currency");
      return false;
    }
  }
}