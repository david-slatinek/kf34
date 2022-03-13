import 'package:app/services/device_type.dart';
import 'package:intl/intl.dart';

abstract class ReturnFields {
  bool success = false;
  String? error;
  final DeviceType type;
  static late String key = '';

  ReturnFields({required this.type});

  static const String baseUrl = "https://kf34.herokuapp.com";
  static final Uri url = Uri.parse(baseUrl + '/graphql');
  static final Uri urlImage = Uri.parse(baseUrl + '/image');
  static final Uri pdfUrl = Uri.parse(baseUrl + '/pdf');

  static Map<String, String> headers = {
    "X-API-Key": key,
    "Content-Type": "application/json"
  };

  static String formatDate(String datetime) => DateFormat('dd-MM-yyyy HH:mm')
      .format(DateTime.parse(datetime).add(DateTime.now().timeZoneOffset));
}
