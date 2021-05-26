import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/states/search_state.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/pages/signup/upload_credit_card.dart';

class PersonalDetails extends StatefulWidget {
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Personal details"),
        ),
        body: Consumer<UserState>(
          builder: (context, state, child) {
            return Center(
              child: Column(
                children: [
                  Text("Personal details"),
                  creditCardDetails(state),
                  carLicenseDetails(state)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget creditCardDetails(UserState state) {
    if (state.getCreditCard() != null) {
      return Text("CreditCardUploaded");
    } else {
      if (state != null) {
        print("state from creditcaed");

      }
      return ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => UploadCreditCard(asb: false,st: state))),
          child: Text("Upload credit card details"));
    }

  }

  Widget carLicenseDetails(UserState state) {
    if (state.isCarLicenseUploaded()) {
      return Text("CarLicenseUploaded");
    } else {
      return Text("CarLicenseUploaded NOT");
    }

  }
}
