import 'dart:convert';
import 'dart:developer';

import 'package:app/services/device_type.dart';
import 'package:app/services/return_fields.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PdfFile extends ReturnFields {
  DateTime start, end;

  PdfFile({required DeviceType type, required this.start, required this.end})
      : super(type: type);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/bla.pdf');
  }

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
        final file = await _localFile;
        file.writeAsBytes(response.bodyBytes);
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
