import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Pdf extends StatefulWidget {
  const Pdf({Key? key}) : super(key: key);

  @override
  State<Pdf> createState() => _PdfState();
}

class _PdfState extends State<Pdf> {
  String startDate = '';
  String endDate = '';
  var rng = Random();

  void startPressed() {
    // print("startPressed");
    setState(() {
      startDate = rng.nextInt(10).toString();
    });
  }

  void endPressed() {
    // print("endPressed");
    setState(() {
      endDate = "david";
    });
  }

  void download() {
    print("DOWNLOAD");
  }

  Widget buildButton(
      {required String text,
      required IconData icon,
      required Function action}) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith(
            (states) => const Color.fromRGBO(0, 112, 222, 1.0)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        )),
      ),
      onPressed: () {
        action();
      },
      icon: Icon(icon),
      label: Text(text),
    );
  }

  Widget buildDaDatePicker(
      {required String text,
      required String dateText,
      required Function action}) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          buildButton(text: text, icon: Icons.date_range, action: action),
          const SizedBox(
            height: 10,
          ),
          Text(dateText),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color.fromRGBO(0, 112, 222, 1.0),
          title: const Text(
            'kf34',
            style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 2),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              buildDaDatePicker(
                  text: 'Pick start date',
                  dateText: startDate,
                  action: startPressed),
              buildDaDatePicker(
                  text: 'Pick end date', dateText: endDate, action: endPressed),
              const SizedBox(
                height: 20,
              ),
              buildButton(
                  text: 'Download',
                  icon: Icons.download_rounded,
                  action: download)
            ],
          ),
        ));
  }
}
