import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pdf extends StatefulWidget {
  const Pdf({Key? key}) : super(key: key);

  @override
  State<Pdf> createState() => _PdfState();
}

class _PdfState extends State<Pdf> {
  Widget buildButton(String text, IconData icon) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith(
            (states) => const Color.fromRGBO(0, 112, 222, 1.0)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        )),
      ),
      onPressed: () {},
      icon: Icon(icon),
      label: Text(text),
    );
  }

  Widget buildDaDatePicker(String text) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          buildButton(text, Icons.date_range),
          const SizedBox(
            height: 10,
          ),
          const Text('date'),
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
              buildDaDatePicker('Pick start date'),
              buildDaDatePicker('Pick end date'),
              const SizedBox(
                height: 20,
              ),
              buildButton('Download', Icons.download_rounded)
            ],
          ),
        ));
  }
}
