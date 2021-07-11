import 'package:http/http.dart' as http;
import 'package:quick_car/constants/strings.dart';



import 'package:quick_car/data_class/reservation.dart';

class ReservationApi {
  Future<Reservation>postReservation(Reservation r) async {}
}

class QuickCarReservationApi implements ReservationApi {
  var client = http.Client();

  Future<Reservation>postReservation(Reservation r) async {
    var uri = Uri.parse(Strings.QUICKCAR_URL + "cars/reservations/");
    Map body = {
      'carOwner': r.ownerId,
      'carRenter': r.renterId,
      'car': r.car.id,
    };
    var response = await http.post(uri, body: body);
    if (response.statusCode == 201) {
      print("Good");
    } else {
      throw "Error occured whild post a reservation";
    }

  }
  
}