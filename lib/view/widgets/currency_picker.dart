import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/constants/strings.dart';

class CurrencyPicker extends StatefulWidget {
  CurrencyPicker({Key key, this.onChooseCurrency, this.currentCurrency})
      : super(key: key);
  final Function onChooseCurrency;
  final Currency currentCurrency;

  @override
  CurrencyPickerState createState() =>
      CurrencyPickerState(onChooseCurrency, currentCurrency);
}

class CurrencyPickerState extends State<CurrencyPicker> {
  final Function onChooseCurrency;
  Currency currentCurrency;
  Currency dollarCurrency = CurrencyService().findByCode(Strings.USD);
  bool loading = false;

  CurrencyPickerState(this.onChooseCurrency, this.currentCurrency);

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Currency change failed"),
          content: Text("Can't get currency rates - The current currency is USD."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                OutlinedButton(
                    onPressed: () => {
                          showCurrencyPicker(
                            context: context,
                            favorite: ['USD', 'eur', 'ils'],
                            showFlag: true,
                            showCurrencyName: true,
                            showCurrencyCode: true,
                            onSelect: (Currency currency) {
                              print(currency.name);
                              setState(() {
                                loading = true;
                              });
                              CarsGlobals.currencyService
                                  .setCurrentCurrency(currency.code)
                                  .then((workedWell) {
                                setState(() {
                                  loading = false;
                                  if (!workedWell) {
                                    currency = CurrencyService().findByCode(Strings.USD);
                                    showAlertDialog(context);
                                  }
                                  currentCurrency = currency;
                                  onChooseCurrency(currency);

                                });
                              });
                            },
                          )
                        },
                    style: TextButton.styleFrom(
                      primary: Colors.grey.shade600,
                    ),
                    child: loading
                        ? SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator())
                        : Text( // if loading == false
                            "${currentCurrency.symbol} ${currentCurrency.flag}",
                            style: TextStyle(fontSize: 17))),
                Text(
                  " = ${(1 / CarsGlobals.currencyService.currentCurrencyRate).toStringAsFixed(3)} ${dollarCurrency.symbol}",
                  style: TextStyle(fontSize: 17),
                )
              ],
            )));
  }
}
