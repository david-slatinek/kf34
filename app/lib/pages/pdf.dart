import 'package:app/services/device_type.dart';
import 'package:app/services/pdf_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Pdf extends StatefulWidget {
  const Pdf({Key? key, required this.type}) : super(key: key);

  final DeviceType type;

  @override
  State<Pdf> createState() => _PdfState();
}

class _PdfState extends State<Pdf> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  void startPressed() async {
    DateTime? date = await selectDate();
    if (date != null) {
      setState(() {
        startDate = date;
      });
    }
  }

  void endPressed() async {
    DateTime? date = await selectDate();
    if (date != null) {
      setState(() {
        endDate = date;
      });
    }
  }

  Future<DateTime?> selectDate() async {
    return await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      currentDate: startDate,
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    );
  }

  void download() async {
    if (endDate.isBefore(startDate)) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
                elevation: 24,
                title: const Text('Invalid end date!'),
                content: const Text("End date can't be before the start date!"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'OK');
                      },
                      child: const Text('OK'))
                ],
              ));
      return;
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
              elevation: 24,
              title: const Text('Noted!'),
              content: const Text(
                  "We will inform you when the file download is done!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'))
              ],
            ));

    // PdfFile file = PdfFile(type: widget.type, start: startDate, end: endDate);
    // Navigator.pop(context);
    // if (await file.getFile()) {
    // } else {}
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
              const Text(
                'Export data for current sensor to pdf.',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              buildDaDatePicker(
                  text: 'Pick start date',
                  dateText: DateFormat('yyyy-MM-dd').format(startDate),
                  action: startPressed),
              buildDaDatePicker(
                  text: 'Pick end date',
                  dateText: DateFormat('yyyy-MM-dd').format(endDate),
                  action: endPressed),
              const SizedBox(
                height: 20,
              ),
              buildButton(
                  text: 'Download',
                  icon: Icons.download_rounded,
                  action: download),
            ],
          ),
        ));
  }
}
