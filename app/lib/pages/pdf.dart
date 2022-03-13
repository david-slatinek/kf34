import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pdf extends StatefulWidget {
  const Pdf({Key? key}) : super(key: key);

  @override
  State<Pdf> createState() => _PdfState();
}

class _PdfState extends State<Pdf> {
  Widget buildDaDatePicker(String text) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.date_range_outlined),
            label: Text(text),
          ),
          const SizedBox(
            height: 10,
          ),
          Text('date'),
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
              ElevatedButton(onPressed: () {}, child: const Text('Download'))
            ],
          ),
        ));
  }
}
