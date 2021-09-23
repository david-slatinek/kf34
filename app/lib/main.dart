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
    },
  ));
}
