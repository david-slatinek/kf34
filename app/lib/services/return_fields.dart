import 'package:app/services/device_type.dart';

abstract class ReturnFields {
  bool success = false;
  String? error;
  final DeviceType type;

  ReturnFields({required this.type});

  static final url = Uri.parse('https://kf34.herokuapp.com/graphql');
  static const Map<String, String> headers = {
    "X-API-Key": '',
    "Content-Type": "application/json",
  };

  @override
  String toString() {
    return 'ReturnFields{success: $success, error: $error}';
  }
}
