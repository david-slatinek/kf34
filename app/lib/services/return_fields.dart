import 'package:app/services/device_type.dart';
import 'package:intl/intl.dart';

abstract class ReturnFields {
  bool success = false;
  String? error;
  final DeviceType type;
  static late String key = '';

  ReturnFields({required this.type});

  static final url = Uri.parse('https://kf34.herokuapp.com/graphql');
  static final urlImage = Uri.parse('https://kf34.herokuapp.com/image');
  static Map<String, String> headers = {
    "X-API-Key": key,
    "Content-Type": "application/json",
  };

  static String formatDate(String datetime) =>
      DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(datetime));
}
