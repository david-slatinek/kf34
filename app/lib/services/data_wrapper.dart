import 'package:app/services/avg_result.dart';
import 'package:app/services/data_result.dart';
import 'package:app/services/device_type.dart';
import 'package:app/services/max_min_result.dart';
import 'package:app/services/return_fields.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DataWrapper extends ReturnFields {
  late MaxMinResult max, min, maxToday, minToday;
  late AvgResult avg, avgToday;
  late DataResult today, latest;

  DataWrapper({required type}) : super(type: type) {
    max = MaxMinResult(type: type);
    min = MaxMinResult(type: type);
    maxToday = MaxMinResult(type: type);
    minToday = MaxMinResult(type: type);

    avg = AvgResult(type: type);
    avgToday = AvgResult(type: type);

    today = DataResult(type: type);
    latest = DataResult(type: type);
  }

  Future<void> getData() async {
   ReturnFields.key =
        await const FlutterSecureStorage().read(key: 'key') ?? '401';
    try {
      await Future.wait([
        max.getMax(),
        min.getMin(),
        maxToday.getMaxToday(),
        minToday.getMinToday(),
        avg.getAverage(),
        avgToday.getAverageToday(),
        today.getToday(),
        latest.getLatest(),
      ]);
      success = true;
    } catch (e) {
      error = e.toString();
      print(e);
    }
  }
}
