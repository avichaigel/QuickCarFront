import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../data_class/car_data.dart';
import '../../../data_class/reservation.dart';
import 'package:quick_car/services/payment_service.dart';
import 'package:quick_car/states/user_state.dart';
import 'package:quick_car/view/pages/reserve_car/choose_dates.dart';
import 'package:stripe_payment/stripe_payment.dart';

class ReservationDetails extends StatefulWidget {
  CarData car;
  ReservationDetails(this.car);
  @override
  _ReservationDetailsState createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  CarData car;
  DatePeriod dates;
  int totalPrice;
  int numberOfDays;


  // From stripe demo:
  Token _paymentToken;
  PaymentMethod _paymentMethod;
  String _error;
  ScrollController _controller = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  void setError(dynamic error) {
    print("in error");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }


  // until here

  @override
  void initState() {
    super.initState();
    car = widget.car;
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_aSaULNS8cJU6Tvo20VAXy6rp",
        merchantId: "Test",
        androidPayMode: 'test')
    );
  }
  Text locationText() {
    if (car.placeMarks != null) {
      return Text("Current location: " + car.placeMarks[0].administrativeArea +
          ", ${car.distanceFromLocation.toInt().toString()} km away",
          style: TextStyle(fontSize: 16)
      );
    } else {
      return Text("Distance: " + car.distanceFromLocation.toInt().toString() + " km away",style: TextStyle(fontSize: 16));
    }
  }
  Widget paymentDatesDetails() {
    if (dates == null) {
      return SizedBox(
        height: 20,
      );
    }
    numberOfDays = dates.end.difference(dates.start).inDays + 1;
    totalPrice = numberOfDays * car.pricePerDayUsd;
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text("Rental period: ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        Text("From: " + DateFormat("yyyy-MM-dd").format(dates.start), style: TextStyle(fontSize: 20),),
        Text("Until: " + DateFormat("yyyy-MM-dd").format(dates.end),style: TextStyle(fontSize: 20)),
        Text("${numberOfDays} days", style: TextStyle(fontSize: 18, color: Colors.black45),),
        SizedBox(
          height: 10,
        ),
        Text("Total price: " + totalPrice.toString() + "\$",

          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 350,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: car.images.length,
                        itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AspectRatio(
                              aspectRatio: 1,
                          child: Image.network(car.images[index].path),
                          ),
                        );
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Text(car.brand + " " + car.model,
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Flexible(child: Text(car.pricePerDayUsd.toString() + "\$ per day",

                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black45
                        ),
                      ))

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child:   Text("Year: " + car.year.toString(), style: TextStyle(fontSize: 20),)),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child:   Text("Type: " + car.type, style: TextStyle(fontSize: 20),)),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Kilometers on road: " + car.kilometers.toString() + "km",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child:
                      locationText()),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Owner email: " + car.owner,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                paymentDatesDetails()
              ]
          ),
        ),
        bottomNavigationBar: Consumer<UserState>(
            builder: (context, state, child) {
              if (!state.isLoggedIn()) {
                return TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.lightBlue
                  ),

                  onPressed: () => print("clicked on please log-in"),
                  child: Text("Please log-in or sign up")
                  ,
                ) ;
              } else if (state.getCarLicensePhoto() == null) {
                return TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.lightBlue
                  ),

                  onPressed: () => print("clicked on upload car license"),
                  child: Text("Upload car license")
                  ,
                ) ;

                // return ;
              } else if (dates == null) {
                return
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.lightBlue
                    ),
                    onPressed: () async {
                      dates = await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChooseDates(selectedDatePeriod: dates, carDatePeriods: car.cardates)));
                      setState(() {
                      });
                    },
                    child: Text("Check availability"),
                  );

              } else {
                return
                  Consumer<UserState>(
                builder: (context, userState, child) {
                  return
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.lightBlue
                      ),
                      onPressed: () async {
                        PaymentMethod paymentMethod = PaymentMethod();
                        if (state.getCreditCard() == null) {
                          print("user does not have a credit card");
                          paymentMethod = await StripePayment.paymentRequestWithCardForm(
                            CardFormPaymentRequest(),
                          ).then((PaymentMethod paymentMethod) {
                            // TODO: payment process
                            print("credit card details uploaded");
                            return paymentMethod;
                          }).catchError((e) {
                            return null;
                          });
                          if (paymentMethod == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error occurred"),
                                duration: Duration(seconds: 2),
                              ),
                            );

                          }

                          startDirectCharge(paymentMethod).then((value) {
                            print("payment successful");
                            // on success:
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Successful"),
                                duration: Duration(seconds: 2),
                              ),

                            ).closed.then((_) => onPaymentSuccess(state));
                          });
                        } else {
                          print("user has credit card");
                          var response = await StripeService.payViaExistingCard(
                              card: state.getCreditCard(), currency: "usd", amount: totalPrice.toString());

                          // TODO: if response is true:
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Successful"),
                              duration: Duration(seconds: 2),
                            ),

                          ).closed.then((_) => onPaymentSuccess(state));

                        }
                      },
                      child: Text("Pay"),
                    );
                }
                );

              }
            }

        ),
      ),


    );
  }

  Future<void> startDirectCharge(PaymentMethod paymentMethod) async {
    print("Payment charge started");
    // TODO: should be implemented in the server
    // https://www.youtube.com/watch?v=RLs34ZcaqhA
    // final http.Response response = await http.post(Uri.parse());
    //
    // if (response.body != null) {
    //   final paymentIntent = jsonDecode(response.body);
    //   final status = paymentIntent['paymentIntent']['status'];
    //   final acct = paymentIntent['stripeAccount'];
    //
    //   if (status == 'succeeded') {
    //     print('payment done');
    //   } else {
    //     StripePayment.setStripeAccount(acct);
    //     await StripePayment.confirmPaymentIntent(PaymentIntent(
    //       paymentMethodId: paymentIntent['paymentIntent']['payment_method'],
    //         clientSecret: paymentIntent['paymentIntent']['client_secret']))
    //     .then((PaymentIntentResult paymentIntentResult) async {
    //       final paymentStatus = paymentIntentResult.status;
    //       if (paymentStatus == 'succeeded') {
    //         print('payment done');
    //       }
    //     });
    //   }
    // }
    print("Payment charge ended");
  }

  onPaymentSuccess(UserState state) {
    Reservation reservation = Reservation(car, dates, totalPrice, numberOfDays);
    state.addUserReservation(reservation);
    Navigator.pop(context);
  }
}

