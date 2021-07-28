import 'package:flow_builder/flow_builder.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/states/new_car_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_car/view/widgets/buttons.dart';

class SetPrice extends StatefulWidget {
  @override
  _SetPriceState createState() => _SetPriceState();
}

class _SetPriceState extends State<SetPrice> {
  var _controller = TextEditingController();

  void _continuePressed() {
    print("_continuePressed"+_controller.value.text);
    var priceInUSD = (int.parse(_controller.value.text) * CarsGlobals.currencyService.currentCurrencyRate).round();
    context
        .flow<NewCarState>()
        .complete((carState) => carState.copywith(pricePerDay: priceInUSD));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Price per day"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text("select the price per day"),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: 130,
                  child:  TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      style: TextStyle(fontSize: 20.0),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Price',
                          suffix: GestureDetector(
                              onTap: () {
                              _controller.clear();
                              },
                              child: Text(CarsGlobals.currencyService.currentCurrency.symbol + ' per day'),
                          )
                        )
                    ),
                ),

                nextButton(onPressed: ()=> _continuePressed())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
