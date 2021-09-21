import 'dart:convert';
import 'package:http/http.dart';
import 'return_fields.dart';
import 'device_type.dart';

class MaxMinResult extends ReturnFields {
  double data = -1;
  List<String> captured = [];

  static final url = Uri.parse('https://kf34.herokuapp.com/graphql');
  static const Map<String, String> headers = {
    "X-API-Key": '',
    "Content-Type": "application/json",
  };

  MaxMinResult() : super();

  Future<void> getMax(DeviceType type) async {
    const String query = '''
      query GetMax (\$device_type: DeviceType!) {
        getMax(device_type: \$device_type) {
            success
            error
            data
            captured
        }
      }
    ''';

    try {
      Response response = await post(url,
          headers: headers,
          body: jsonEncode({
            'query': query,
            'variables': {'device_type': type.asString()}
          }));

      if (response.statusCode == 200) {
        Map mapData = jsonDecode(response.body);
        success = mapData['data']['getMax']['success'];
        error = mapData['data']['getMax']['error'];
        data = mapData['data']['getMax']['data'];
        captured = (mapData['data']['getMax']['captured'] as List<dynamic>).cast<String>();
      } else {
        throw Exception('Error code: ' + response.statusCode.toString());
      }
    } catch (e) {
      error = e.toString();
      print(e);
    }
  }
}
