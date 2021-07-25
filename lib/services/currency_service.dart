import 'dart:convert';

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quick_car/constants/strings.dart';

class MyCurrencyService extends ChangeNotifier {
  double currentCurrencyRate = 1;
  Currency currentCurrency = CurrencyService().findByCode(Strings.USD);

  bool goBackToDollars(bool isChangedToDollarsSuccessfully) {
    currentCurrencyRate = 1;
    currentCurrency = CurrencyService().findByCode(Strings.USD);
    notifyListeners();
    return isChangedToDollarsSuccessfully;
  }

  Future<bool> setCurrentCurrency(String currencyCode) async {
    if (currencyCode == Strings.USD) {
      return goBackToDollars(true);
    }
    var client = http.Client();
    try {
      var url = "https://fixer-fixer-currency-v1.p.rapidapi.com/convert?amount=1&to=$currencyCode&from=USD";
      var response = await client.get(Uri.parse(url), headers: {
        'x-rapidapi-key': 'cec120a60dmsha3ae2f4ff86c4dfp10736djsn0a7c7d7c5056',
        'x-rapidapi-host': 'fixer-fixer-currency-v1.p.rapidapi.com'
      }).timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        var map = jsonDecode(response.body);
        var value = map['result'];
        currentCurrencyRate = double.parse(value);
        if (currentCurrencyRate == 0) {
          return goBackToDollars(false);
        }
        currentCurrency = CurrencyService().findByCode(currencyCode);
        notifyListeners();
        return true;
      }
      return goBackToDollars(false);
    } catch (Exception) {
      print("Can't get currency rate - use dollars");
      return goBackToDollars(false);
    }
  }

  String getPriceInCurrency(int amountInDollars) {
    return "${(amountInDollars * currentCurrencyRate).toStringAsFixed(2)} ${currentCurrency.symbol}";
  }
}
