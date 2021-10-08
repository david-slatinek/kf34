import 'package:app/services/data.dart';
import 'package:app/services/device_type.dart';
import 'package:app/services/return_fields.dart';

class DataResult extends ReturnFields {
  List<Data> data = [];
  static const String getTodayName = 'getToday';
  static const String getLatestName = 'getLatest';

  DataResult({required DeviceType type}) : super(type: type);

  void parseData(Map mapData) {
    success = mapData['success'];
    error = mapData['error'];
    if (mapData['data'] != null) {
      data = List<Data>.from(mapData['data'].map((i) => Data.fromJson(i)));
    }
  }

  String _generateQuery(String method) => '''
        $method(device_type: \$device_type) {
        success
        error
        data {
            id_data
            capture
            value
            fk_device
        }
    }''';

  String getToday() => _generateQuery('getToday');

  String getLatest() => _generateQuery('getLatest');
}
