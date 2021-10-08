import 'dart:convert';

import 'package:app/services/avg_result.dart';
import 'package:app/services/data_result.dart';
import 'package:app/services/device_type.dart';
import 'package:app/services/image_graph.dart';
import 'package:app/services/max_min_result.dart';
import 'package:app/services/return_fields.dart';
import 'package:http/http.dart';

class DataWrapper extends ReturnFields {
  late MaxMinResult max, min, maxToday, minToday;
  late AvgResult avgToday, medianToday, stDeviationToday;
  late DataResult today, latest;
  late ImageGraph imageGraph;

  DataWrapper({required type}) : super(type: type) {
    max = MaxMinResult(type: type);
    min = MaxMinResult(type: type);
    maxToday = MaxMinResult(type: type);
    minToday = MaxMinResult(type: type);

    avgToday = AvgResult(type: type);
    medianToday = AvgResult(type: type);
    stDeviationToday = AvgResult(type: type);

    today = DataResult(type: type);
    latest = DataResult(type: type);
    imageGraph = ImageGraph(type: type);
  }

  String symbol() {
    switch (type) {
      case DeviceType.TEMPERATURE:
        return '°C';
      case DeviceType.HUMIDITY:
        return '%';
      case DeviceType.PRESSURE:
        return 'hPa';
    }
  }

  Future<void> _getAll() async {
    String query = '''
        query GetAll (\$device_type: DeviceType!) {
            ${max.getMax()}
            ${min.getMin()}
            ${maxToday.getMaxToday()}
            ${minToday.getMinToday()}
            ${avgToday.getAverageToday()}
            ${medianToday.getMedianToday()}
            ${stDeviationToday.getStandardDeviationToday()}
            ${today.getToday()}
            ${latest.getLatest()}
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
        Map mapData = jsonDecode(response.body)['data'];
        max.parseData(mapData[MaxMinResult.getMaxName]);
        min.parseData(mapData[MaxMinResult.getMinName]);
        maxToday.parseData(mapData[MaxMinResult.getMaxTodayName]);
        minToday.parseData(mapData[MaxMinResult.getMinTodayName]);
        avgToday.parseData(mapData[AvgResult.getAverageTodayName]);
        medianToday.parseData(mapData[AvgResult.getMedianTodayName]);
        stDeviationToday
            .parseData(mapData[AvgResult.getStandardDeviationTodayName]);
        today.parseData(mapData[DataResult.getTodayName]);
        latest.parseData(mapData[DataResult.getLatestName]);
      } else {
        throw Exception('Error code: ' + response.statusCode.toString());
      }
      success = true;
    } catch (e) {
      error = e.toString();
    }
  }

  Future<void> getData() async {
    try {
      await Future.wait([
        _getAll(),
        imageGraph.getData(),
      ]);
      success = true;
    } catch (e) {
      error = e.toString();
    }
  }
}
