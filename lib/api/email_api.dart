import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> validateEmail(String email) async {
  var client = http.Client();

  try { 
    var url = "https://zerobounce1.p.rapidapi.com/v2/validate?email=" +email + "&ip_address=%20";
    var response = await client.get(Uri.parse(url), headers: {
      "x-rapidapi-key": "cec120a60dmsha3ae2f4ff86c4dfp10736djsn0a7c7d7c5056",
      "x-rapidapi-host": "zerobounce1.p.rapidapi.com",
    });
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      return jsonMap['status'] == 'valid';
    }
  } catch (Exception) {
    print("zero bounce connection error");
    return false;
  }
}
