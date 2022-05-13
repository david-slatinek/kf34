import 'package:app/services/device_type.dart';
import 'package:app/services/pdf_file.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Pdf extends StatefulWidget {
  const Pdf({Key? key, required this.type}) : super(key: key);

  final DeviceType type;

  @override
  State<Pdf> createState() => _PdfState();
}

class _PdfState extends State<Pdf> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool enabled = true;

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

  Future getDialog({required String title, required String text}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
              elevation: 24,
              title: Text(title),
              content: Text(text),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  void download() async {
    if (!enabled) {
      Fluttertoast.showToast(
        msg: "You have already downloaded the file!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (endDate.isBefore(startDate)) {
      getDialog(
          title: 'Invalid end date!',
          text: "End date can't be before the start date!");
      return;
    }

    enabled = false;

    Fluttertoast.showToast(
      msg: "Downloading, please wait...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.black,
    );

    PdfFile file = PdfFile(type: widget.type, start: startDate, end: endDate);

    if (await file.getFile()) {
      getDialog(
          title: 'Download succeeded!',
          text: 'File was downloaded successfully!');
    } else {
      getDialog(title: 'Download failed!', text: 'Error: ${file.error}');
      enabled = true;
    }
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

  Widget _mainScreen() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          const Text(
            'Export data for current sensor to pdf.',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
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
              text: 'Download', icon: Icons.download_rounded, action: download),
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
        body: _mainScreen());
  }
}
