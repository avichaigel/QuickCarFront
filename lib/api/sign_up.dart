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
      print("user successfully created");
      return UserSignUp.fromJson(jsonDecode(response.body));
    }
  }
}