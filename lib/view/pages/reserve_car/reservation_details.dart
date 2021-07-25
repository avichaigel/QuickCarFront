import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quick_car/constants/cars_globals.dart';
import 'package:quick_car/data_class/car_dates.dart';
import 'package:quick_car/services/email_sender.dart';
import 'package:quick_car/view/pages/user_items/update_car_license.dart';
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
  DatePeriod datesSelected;
  int idCarDatesSelected;
  int totalPrice;
  int numberOfDays;
  EmailSender emailSender = EmailSender();
  String userName;


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
  Widget contactSellerWidget() {
    return GestureDetector(
        onTap: () {
          emailSender.send(userName, car);
        },
        child: Row(
          children: [
            Icon(
              Icons.mail_outline,
              size: 30.0,
              color: Colors.grey.shade700,
            ),
            SizedBox(
              width: 10,
            ),
            Text("Contact Seller",
                style: TextStyle(fontSize: 20, color: Colors.grey.shade700)),
          ],
        ));
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
    if (datesSelected == null) {
      return SizedBox(
        height: 20,
      );
    }
    numberOfDays = datesSelected.end.difference(datesSelected.start).inDays + 1;
    totalPrice = numberOfDays * car.pricePerDayUsd;
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text("Rental period: ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        Text("From: " + DateFormat("yyyy-MM-dd").format(datesSelected.start), style: TextStyle(fontSize: 20),),
        Text("Until: " + DateFormat("yyyy-MM-dd").format(datesSelected.end),style: TextStyle(fontSize: 20)),
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
    return Consumer<UserState>(builder: (context, state, child) {
      return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(children: [
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
                      Text(
                        car.brand + " " + car.model,
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Flexible(
                          child: Text(
                            car.pricePerDayUsd.toString() + "\$ per day",
                            style: TextStyle(fontSize: 22, color: Colors.black45),
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Year: " + car.year.toString(),
                        style: TextStyle(fontSize: 20),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Type: " + car.type,
                        style: TextStyle(fontSize: 20),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Kilometers on road: " + car.kilometers.toString() + "km",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child:
                  Align(alignment: Alignment.centerLeft, child: locationText()),
                ),
                state.isLoggedIn()
                    ? Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: contactSellerWidget()),
                )
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width / 1.2,
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(car.latitude, car.longitude),
                              zoom: 16,
                            ),
                            markers: {
                              (Marker(
                                  markerId: MarkerId(car.id.toString()),
                                  position: LatLng(car.latitude, car.longitude)))
                            },
                            myLocationEnabled: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                paymentDatesDetails()
              ]),
            ),
            bottomNavigationBar:
            Consumer<UserState>(builder: (context, state, child) {
              userName = state.getFirstName();
              if (!state.isLoggedIn()) {
                return TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.lightBlue),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("In order to book you have to be logged in"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text("Please log-in or sign up"),
                );
              } else if (state.getCarLicensePhoto() == null) {
                return TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.lightBlue),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateCarLicense()));
                  },
                  child: Text("Upload car license"),
                );

                // return ;
              } else if (datesSelected == null) {
                return TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.lightBlue
                    ),
                    onPressed: () async {
                      try {
                        datesSelected = await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChooseDates(selectedDatePeriod: datesSelected,
                                carDatePeriods: car.carDates.map((e) => e.datePeriod).toList())
                        )
                        );
                        _setIdCarDatesSelected(datesSelected, car.carDates);
                        setState(() {
                        });
                      } catch(e) {
                        print(e.toString());
                      }
                    },
                    child: Text("Check availability"),
                  );

              } else {
                return TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, backgroundColor: Colors.lightBlue),
                  onPressed: () async {
                    PaymentMethod paymentMethod = PaymentMethod();
                    if (state.getCreditCard() == null) {
                      print("user does not have a credit card");
                      paymentMethod =
                      await StripePayment.paymentRequestWithCardForm(
                        CardFormPaymentRequest(),
                      ).then((PaymentMethod paymentMethod) {
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
                        return;
                      }

                      startDirectCharge(paymentMethod).then((value) {
                        print("payment successful");
                        // on success:
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text("Payment Successful"),
                            duration: Duration(seconds: 2),
                          ),
                        )
                            .closed
                            .then((_) => onPaymentSuccess(state));
                      });
                    } else {
                      print("user has credit card");
                      var response = await StripeService.payViaExistingCard(
                          card: state.getCreditCard(),
                          currency: "usd",
                          amount: totalPrice.toString());
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text("Payment confirmed"),
                          duration: Duration(seconds: 2),
                        ),
                      )
                          .closed
                          .then((_) => onPaymentSuccess(state));
                    }
                  },
                  child: Text("Pay"),
                );
              }
            }),
          ));
    });
  }

  Future<void> startDirectCharge(PaymentMethod paymentMethod) async {
    print("Payment charge");
  }

  onPaymentSuccess(UserState state) async {
    Reservation reservation = Reservation(car, datesSelected, totalPrice, numberOfDays);
    reservation.renterId = Provider.of<UserState>(context, listen: false).getId();
    reservation.ownerId = await CarsGlobals.userApi.getUserIdByEmail(car.owner);

    state.addUserReservation(reservation);
    Navigator.of(context).pop();
    return;

  }

  void _setIdCarDatesSelected(DatePeriod datesSelected, List<CarDates> carDates) {
    for (int i = 0; i < carDates.length; i++ ){
      DateTime start = carDates[i].datePeriod.start.subtract(Duration(days: 1));
      DateTime end = carDates[i].datePeriod.end.add(Duration(days: 1));
      if (datesSelected.start.isAfter(start) && datesSelected.end.isBefore(end)) {
        idCarDatesSelected = carDates[i].id;
        print("id of carDates:");
        print(idCarDatesSelected);
        return;
      }

    }
  }



}

