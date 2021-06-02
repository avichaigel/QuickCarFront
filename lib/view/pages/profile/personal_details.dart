import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/pages/signup/photo_menu.dart';
import 'package:quick_car/view/pages/signup/upload_credit_card.dart';

class PersonalDetails extends StatefulWidget {
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isCvvFocused = false;
  bool showSecretDetails = false;
  bool editCreditCard = false;

  bool isEditPersonalEnable;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    isEditPersonalEnable = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Personal details"),
        ),
        body: Consumer<UserState>(
          builder: (context, state, child) {
            _nameController.value = TextEditingValue(text: state.getFirstName() + " " + state.getLastName());
            _emailController.value = TextEditingValue(text: state.getEmail());
            return SingleChildScrollView(
              child: Column(
                children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Personal details".toUpperCase(),style: TextStyle(color: Colors.grey,fontSize: 12,),),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isEditPersonalEnable = !isEditPersonalEnable;
                                _formKey.currentState.validate();
                            });
                            },
                            child: Icon(Icons.edit, size: 20,),
                          )
                      )
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _nameController,
                          style: TextStyle(fontSize: 18),
                          onTap: () => print("on tap"),
                          enabled: isEditPersonalEnable,
                          decoration: InputDecoration(
                            prefix: Text("Name: ", style: TextStyle(fontSize: 18),),
                          ),

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (String value) {
                            if (!RegExp(
                                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(value)) {
                              return 'Please enter a valid email Address';
                            }

                            return null;
                          },
                          controller: _emailController,
                          style: TextStyle(fontSize: 18),
                          onTap: () => print("on tap"),
                          enabled: isEditPersonalEnable,
                          decoration: InputDecoration(
                            prefix: Text("Email: ", style: TextStyle(fontSize: 18),),
                          ),

                        ),
                      ),
                      Visibility(
                          visible: isEditPersonalEnable,
                          child: TextButton(
                            child: Text("Submit"),
                            onPressed: () async {
                              if (!_formKey.currentState.validate()) {
                                print(_emailController.text);
                                return;
                              }
                              print("new values: name: " + _nameController.value.text + " email" + _emailController.value.text);
                            },

                          )
                      ),
                    ],
                  ),

                ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(

                          alignment: Alignment.centerLeft,
                          child: Text("Credit card details".toUpperCase(),style: TextStyle(color: Colors.grey,fontSize: 12,),),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  editCreditCard = !editCreditCard;
                                });
                              },
                              child: Icon(Icons.edit, size: 20,),
                            )
                        )
                      ],
                    ),
                  ),

                  creditCardDetails(state),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Car license details".toUpperCase(),style: TextStyle(color: Colors.grey,fontSize: 12,),),
                    ),
                  ),

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
      CreditCard card = state.getCreditCard();
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isCvvFocused = !isCvvFocused;
              });
            },
            child: CreditCardWidget(
                cardNumber: card.number,
                expiryDate: card.expMonth.toString() + "/" + card.expYear.toString(),
                cardHolderName: card.name,
                cvvCode: card.cvc,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true
            ),
          ),
          Visibility(
            visible: editCreditCard,
              child: TextButton.icon(
                onPressed: () {
                  state.deleteCreditCard();
                },
                icon: Icon(Icons.delete),
                label: Text("Remove credit card"),

              )
          )

        ],
      );


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
    if (state.getCarLicensePhoto() != null) {
      return Text("CarLicenseUploaded");
    } else {
      return ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => PhotoMenu())),
          child: Text("Upload car license photo"));
    }

  }
}
