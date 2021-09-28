import 'package:app/services/return_fields.dart';

class Data {
  int idData = -999;
  String capture = '';
  double value = -999;
  int? fkDevice = -999;

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
