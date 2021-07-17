import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class MyCurrency extends ChangeNotifier {
  String _symbol;
  double _valueRelativeToUSD;

  MyCurrency(String sym){
    symbol = sym;
    getValue(sym).then((value) => _valueRelativeToUSD = value);
  }

  double get valueRelativeToUSD => _valueRelativeToUSD;
  String get symbol => _symbol;

  set symbol(String sym) {
    _symbol = sym;
    getValue(sym).then((value) => _valueRelativeToUSD = value);
    notifyListeners();
    print("in set currency symbol");
  }

  Future getValue(String symbol) async {
    print("in currency get value");
    if (symbol == "USD"){
      return 1;
    }

    var client = http.Client();
    try {
      var url = "https://currency-exchange.p.rapidapi.com/exchange?to=${symbol}&from=USD&q=1.0";
      var response = await client.get(Uri.parse(url), headers: {
        'x-rapidapi-key': 'cec120a60dmsha3ae2f4ff86c4dfp10736djsn0a7c7d7c5056',
        'x-rapidapi-host': 'currency-exchange.p.rapidapi.com'
      });
      if (response.statusCode == 200) {
        var value = response.body;
        return double.parse(value);
        // print(jsonString);
        // var jsonMap = json.decode(jsonString);
      }
    } catch (Exception) {
      print("currency exchange connection error");
      return 0;
    }
  }
}