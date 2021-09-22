import 'dart:convert';

import 'package:app/services/data.dart';
import 'package:app/services/device_type.dart';
import 'package:app/services/return_fields.dart';
import 'package:http/http.dart';

class DataResult extends ReturnFields {
  List<Data> data = [];

  DataResult({required DeviceType type}) : super(type: type);

  Future<void> _getData(String method) async {
    String query = '''
      query ${method.toUpperCase()}(\$device_type: DeviceType!) {
        $method(device_type: \$device_type) {
            success
            error
            data {
                  id_data
                  capture
                  value
                  fk_device
            }
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

        data = List<Data>.from(
            mapData['data'][method]['data'].map((i) => Data.fromJson(i)));
      } else {
        throw Exception('Error code: ' + response.statusCode.toString());
      }
    } catch (e) {
      error = e.toString();
      print(e);
    }
  }

  Future<void> getToday() async => _getData('getToday');

  Future<void> getLatest() async => _getData('getLatest');

  @override
  String toString() {
    return super.toString() + '\nDataResult{data: $data}';
  }
}
