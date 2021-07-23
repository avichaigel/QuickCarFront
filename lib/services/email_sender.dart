import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:quick_car/data_class/car_data.dart';

class EmailSender {
  send(String senderName, CarData wantedCar) async {
    final Email email = Email(
      subject: 'Question from $senderName via QuickCar App',
      body: 'Hey my name is $senderName,\nI saw your ${wantedCar.brand} ${wantedCar.model} on QuickCar App!\n'
          'I would like to get a few more details before I book:',
      recipients: [wantedCar.owner],
    );
    await FlutterEmailSender.send(email);
  }
}
