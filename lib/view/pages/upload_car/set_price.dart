import 'package:flow_builder/flow_builder.dart';
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
    context
        .flow<NewCarState>()
        .complete((carState) => carState.copywith(pricePerDay: int.parse(_controller.value.text)));
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
                              child: Text('\$ per day'),
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
