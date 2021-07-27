import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quick_car/constants/strings.dart';



import 'package:quick_car/data_class/reservation.dart';

class ReservationApi {
  Future<Reservation>postReservation(Reservation r, int carDatesId) async {}
}

class QuickCarReservationApi implements ReservationApi {
  var client = http.Client();

  Future<Reservation>postReservation(Reservation r, int carDatesId) async {
    var uri = Uri.parse(Strings.QUICKCAR_URL + "cars/reservations/");

    Map<String,dynamic> body = {
      'dateFrom': DateFormat("yyyy-MM-dd").format(r.datePeriod.start),
      'dateTo': DateFormat("yyyy-MM-dd").format(r.datePeriod.end),
      'cardates': carDatesId,
      'carOwner': r.ownerId,
      'carRenter': r.renterId,
      'car': r.car.id,
    };
    var response = await http.post(uri, body: jsonEncode(body), headers: {'Content-Type':'application/json',
    'Authorization': 'TOKEN ' + Strings.TOKEN});
    if (response.statusCode == 201) {
      return r;
    } else {
      print("status code: " + response.statusCode.toString());
      print(response.body);
      throw "Could not post the reservation";
    }

  }
  
}