import 'dart:convert';

import 'package:app/services/device_type.dart';
import 'package:app/services/return_fields.dart';
import 'package:http/http.dart';

class AvgResult extends ReturnFields {
  double data = -99;

  AvgResult({required DeviceType type}) : super(type: type);

  Future<void> _getData(String method) async {
    String query = '''
      query ${method.toUpperCase()}(\$device_type: DeviceType!) {
        $method(device_type: \$device_type) {
            success
            error
            data
        }
      }
    ''';

    try {
      Response response = await post(ReturnFields.url,
          headers: ReturnFields.headers,
          body: jsonEncode({
            'query': query,
            'variables': {'device_type': type.asString()}
          }));

      if (response.statusCode == 200) {
        Map mapData = jsonDecode(response.body);
        success = mapData['data'][method]['success'];
        error = mapData['data'][method]['error'];
        data = mapData['data'][method]['data'];
      } else {
        throw Exception('Error code: ' + response.statusCode.toString());
      }
      success = true;
    } catch (e) {
      error = e.toString();
    }
  }

  Future<void> getAverage() async => _getData('getAverage');

  Future<void> getAverageToday() async => _getData('getAverageToday');

  Future<void> getMedianToday() async => _getData('getMedianToday');

  Future<void> getStandardDeviationToday() async => _getData('getStandardDeviationToday');

  @override
  String toString() {
    return super.toString() + '\nAvgResult{data: $data}';
  }
}
