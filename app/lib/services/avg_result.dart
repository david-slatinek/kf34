import 'dart:convert';

import 'package:app/services/device_type.dart';
import 'package:app/services/return_fields.dart';
import 'package:http/http.dart';

class AvgResult extends ReturnFields {
  double data = -1;

  AvgResult({required DeviceType type}) : super(type: type);

  Future<void> getData() async {
    String query = '''
      query GetAverage(\$device_type: DeviceType!) {
        getAverage(device_type: \$device_type) {
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
        success = mapData['data']['getAverage']['success'];
        error = mapData['data']['getAverage']['error'];
        data = mapData['data']['getAverage']['data'];
      } else {
        throw Exception('Error code: ' + response.statusCode.toString());
      }
    } catch (e) {
      error = e.toString();
      print(e);
    }
  }

  @override
  String toString() {
    return super.toString() + '\nAvgResult{data: $data}';
  }
}
