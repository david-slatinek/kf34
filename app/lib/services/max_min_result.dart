import 'package:app/services/return_fields.dart';
import 'package:app/services/device_type.dart';

class MaxMinResult extends ReturnFields {
  double data = -99;
  List<String> captured = [];
  static const String getMaxName = 'getMax';
  static const String getMaxTodayName = 'getMaxToday';
  static const String getMinName = 'getMin';
  static const String getMinTodayName = 'getMinToday';

  MaxMinResult({required DeviceType type}) : super(type: type);

  void parseData(Map mapData) {
    success = mapData['success'];
    error = mapData['error'];
    data = mapData['data'];
    if (mapData['captured'] != null) {
      for (String s in mapData['captured']) {
        captured.add(ReturnFields.formatDate(s));
      }
    }
  }

  String _generateQuery(String method) => '''
        $method(device_type: \$device_type) {
        success
        error
        data
        captured
    }''';

  String getMax() => _generateQuery('getMax');

  String getMaxToday() => _generateQuery('getMaxToday');

  String getMin() => _generateQuery('getMin');

  String getMinToday() => _generateQuery('getMinToday');
}
