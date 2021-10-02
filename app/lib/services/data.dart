import 'package:app/services/return_fields.dart';

class Data {
  int idData = -99;
  String capture = '';
  double value = -99;
  int? fkDevice = -99;

  Data(
      {required this.idData,
      required this.capture,
      required this.value,
      required this.fkDevice});

  static Data fromJson(Map<String, dynamic> json) {
    return Data(
        idData: int.parse(json['id_data']),
        capture: ReturnFields.formatDate(json['capture']),
        value: json['value'],
        fkDevice: json['fk_device']);
  }
}
