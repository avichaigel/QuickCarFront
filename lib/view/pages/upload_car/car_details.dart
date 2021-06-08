import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/states/new_car_state.dart';
import 'package:quick_car/view/widgets/buttons.dart';
import 'package:quick_car/view/widgets/decorations.dart';

class CarDetails extends StatefulWidget {
  @override
  _CarDetailsState createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {

  String _company;
  String _model;
  String _manufYear;
  int _kilometers;
  String _type;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _kilometersController = TextEditingController();

  int _startYear = 2000;
  int _currentYear = DateTime.now().year;


  Widget row(String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          value,
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget _buildCompany() {
    return TypeAheadFormField(
      validator: (value) {
        print("value of company is ${value}");
        if (value == null || value.isEmpty) {
          return 'Car company is Required';
        }
        return null;
      },
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: false,
          keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        controller: _companyController,
        decoration: InputDecoration(
          labelText: 'Company',
            labelStyle: TextStyle(
                color: Colors.black
            )

        )
      ),
      suggestionsCallback: (pattern) async {
        Completer<List<String>> completer = Completer();
        completer.complete(CarsGlobals.companies.where((element) => element.contains(pattern)).toList());
        return completer.future;
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      }, onSuggestionSelected: (String suggestion) {
        _companyController.text = suggestion;
        _company = suggestion;
        },
    );
  }

  Widget _buildModel() {
    return TextFormField(
        decoration: InputDecoration(
            labelText: 'Car model',
            labelStyle: TextStyle(
                color: Colors.black
            )
        ),
        controller: _modelController,
        keyboardType: TextInputType.text,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Car model is Required';
          }
          return null;
        },
        onSaved: (String value) {
          _modelController.text = value;
          _model = value;
        }
    );
  }
  Widget _buildManufYear() {
    return DropdownSearch<String>(
        validator: (v) {
          if (v == null) {
            return 'Year of manufacture is Required';
          }
        },
        showSelectedItem: true,
      items: List<String>
      .generate(_currentYear - _startYear, (i) => (i + _startYear + 1).toString())
      .toList(),
      label: "Year of manufacture",
      onChanged: (String value) {
          _manufYear = value;
      },
      dropdownSearchDecoration: InputDecoration(
          labelStyle: TextStyle(
              color: Colors.black
          )

      ),
    );
  }
  Widget _buildKilometers() {
    return TextFormField(
        decoration: InputDecoration(
            labelText: 'Car kilometers',
            labelStyle: TextStyle(
                color: Colors.black
            ),
          suffixText: 'km',

        ),
        controller: _kilometersController,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Car kilometers is Required';
          } else if (int.tryParse(value) == null) {
            return 'Number is Required';
          }
          return null;
        },
        onSaved: (String value) {
          _kilometersController.text = value;
          _kilometers = int.parse(value);
        }
    );
  }
  Widget _buildType() {
    List<String> carTypes = [];
    for (int i = 1; i < CarsGlobals.carTypes.length; i++)
      carTypes.add(CarsGlobals.carTypes[i]);

    return DropdownSearch<String>(
      validator: (v) {
        if (v == null) {
          return 'Car type is Required';
        }
      },
      showSelectedItem: true,
      items: carTypes,
      label: "Car type",
      onChanged: (String value) {
        _type = value;
      },
      dropdownSearchDecoration: InputDecoration(
          labelStyle: TextStyle(
              color: Colors.black
          )

      ),
    );
  }

  void _continuePressed() {
    context.flow<NewCarState>().update((newCarState) => newCarState.copywith(companyName: _company, model: _model,
      kilometers: _kilometers, manufYear: _manufYear, type: _type
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Car Details"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(8.0),
              decoration: customDecoration(),
              child: Column(
                children: [
                  _buildCompany(),
                  _buildModel(),
                  _buildManufYear(),
                  _buildKilometers(),
                  _buildType(),
                  SizedBox(height: 40),
                  nextButton(onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    _formKey.currentState.save();
                    _continuePressed();
                  },
                  ),

                ],
              )
            )
          ),
        )
      ),
    );
  }
}
