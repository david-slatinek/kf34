import 'dart:convert';
import 'dart:developer';

import 'package:app/services/device_type.dart';
import 'package:app/services/return_fields.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class PdfFile extends ReturnFields {
  DateTime start, end;

  PdfFile({required DeviceType type, required this.start, required this.end})
      : super(type: type);

  Future<void> getFile() async {
    try {
      Response response = await post(ReturnFields.pdfUrl,
          headers: ReturnFields.headers,
          body: jsonEncode({
            'device_type': type.asString(),
            'begin_date': DateFormat('yyyy-MM-dd').format(start),
            'end_date': DateFormat('yyyy-MM-dd').format(end)
          }));

      if (response.statusCode == 200) {
        File('/storage/emulated/0/Download/${const Uuid().v1()}.pdf')
            .writeAsBytes(response.bodyBytes);
        success = true;
      } else {
        throw Exception('Error: ' + response.body);
      }
    } catch (e) {
      error = e.toString();
      log(error.toString());
    }
  }
}
