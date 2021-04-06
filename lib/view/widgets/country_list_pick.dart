import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_list_pick/support/code_country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CountryList extends StatelessWidget {
  CountryList({this.onSelectParam});
  Function(String) onSelectParam;

  @override
  Widget build(BuildContext context) {
  return CountryListPick(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Select your country'),
      ),

      // if you need custome picker use this
      pickerBuilder: (context, CountryCode countryCode){
        return Row(
          children: [
            Container(
              height: 30.0,
              decoration: BoxDecoration(
                  color: Colors.black12
              ),
              child: Image.asset(
                countryCode.flagUri,
                package: 'country_list_pick',
                height: 20.0,
                width: 40.0,
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(countryCode.name,
              style: TextStyle(
                color: Colors.black45,
                fontSize: 15
              ),
            ),
          ],
        );
      },

      // To disable option set to false
      theme: CountryTheme(
        isShowFlag: false,
        isShowTitle: false,
        isShowCode: false,
        isDownIcon: false,
        showEnglishName: false,
      ),
      // Set default value
      initialSelection: '+62',
      // or
      // initialSelection: 'US'
      onChanged: (CountryCode code) {
        onSelectParam(code.name);
      },
      // Whether to allow the widget to set a custom UI overlay
      useUiOverlay: true,
      // Whether the country list should be wrapped in a SafeArea
      useSafeArea: false
  );
  }
}
