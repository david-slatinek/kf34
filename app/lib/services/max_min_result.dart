import 'dart:convert';
import 'package:http/http.dart';

import 'package:app/services/return_fields.dart';
import 'package:app/services/device_type.dart';

class MaxMinResult extends ReturnFields {
  double data = -1;
  List<String> captured = [];

  MaxMinResult({required DeviceType type}) : super(type: type);

  Future<void> _getData(String method) async {
    String query = '''
      query ${method.toUpperCase()}(\$device_type: DeviceType!) {
        $method(device_type: \$device_type) {
            success
            error
            data
            captured
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
        captured = (mapData['data'][method]['captured'] as List<dynamic>)
            .cast<String>();
      } else {
        throw Exception('Error code: ' + response.statusCode.toString());
      }
    } catch (e) {
      error = e.toString();
      print(e);
    }
  }

  Future<void> getMax() async => _getData('getMax');

  Future<void> getMaxToday() async => _getData('getMaxToday');

  Future<void> getMin() async => _getData('getMin');

  Future<void> getMinToday() async => _getData('getMinToday');

  @override
  String toString() {
    return super.toString() +
        '\nMaxMinResult{data: $data, captured: $captured}';
  }
}
