import 'dart:convert';
import 'dart:typed_data';

import 'package:app/services/device_type.dart';
import 'package:app/services/return_fields.dart';
import 'package:http/http.dart';

class ImageGraph extends ReturnFields {
  Uint8List image = Uint8List(0);

  static final Map<String, String> imageHeaders = {
    "Content-Type": "application/json",
  };

  ImageGraph({required type}) : super(type: type) {
    imageHeaders['device_type'] = (type as DeviceType).asString();
  }

  Future<void> getData() async {
    try {
      Response response = await post(ReturnFields.urlImage,
          headers: imageHeaders,
          body: jsonEncode({'device_type': type.asString()}));

      if (response.statusCode == 200) {
        image = response.bodyBytes;
        success = true;
      } else {
        throw Exception('Error code: ' + response.statusCode.toString());
      }
    } catch (e) {
      error = e.toString();
    }
  }
}
