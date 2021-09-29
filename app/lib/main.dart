import 'dart:typed_data';

import 'package:app/pages/sensor.dart';
import 'package:app/pages/view.dart';
import 'package:app/pages/view_image.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/home.dart';

Future<void> main() async {
  runApp(MaterialApp(
    title: 'kf34',
    theme: ThemeData(
      primaryColor: Colors.indigo,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => const Home(),
      '/view': (context) => const View(
            capture: [],
          ),
      '/sensor': (context) => const Sensor(),
      '/view_image': (context) => ViewImage(data: Uint8List(0)),
    },
  ));
}
