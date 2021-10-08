import 'package:app/services/device_type.dart';
import 'package:app/services/return_fields.dart';

class AvgResult extends ReturnFields {
  double data = -99;
  static const String getAverageTodayName = 'getAverageToday';
  static const String getMedianTodayName = 'getMedianToday';
  static const String getStandardDeviationTodayName =
      'getStandardDeviationToday';

  AvgResult({required DeviceType type}) : super(type: type);

  void parseData(Map mapData) {
    success = mapData['success'];
    error = mapData['error'];
    data = mapData['data'];
  }

  String _generateQuery(String method) => '''
        $method(device_type: \$device_type) {
        success
        error
        data
    }''';

  String getAverageToday() => _generateQuery('getAverageToday');

  String getMedianToday() => _generateQuery('getMedianToday');

  String getStandardDeviationToday() =>
      _generateQuery('getStandardDeviationToday');

  @override
  String toString() {
    return super.toString() + '\nAvgResult{data: $data}';
  }
}
