import 'package:sms_advanced/sms_advanced.dart';

class SmsService {
  Future<void> sendSms(String phone, String message) async {
    SmsSender sender = SmsSender();
    SmsMessage sms = SmsMessage(phone, message);
    sender.sendSms(sms);
    try {
      sms.onStateChanged.listen((state) {
        if (state == SmsMessageState.Sent) {
          print("SMS enviado a $phone");
        } else if (state == SmsMessageState.Delivered) {
          print("SMS entregado a $phone");
        } else if (state == SmsMessageState.Fail) {
          print("Fallo al enviar SMS a $phone");
        }
      });
      sender.sendSms(sms);
    } catch (e) {
      print("Error al enviar SMS: $e");
    }
  }
}