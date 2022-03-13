import 'package:app/pages/pdf.dart';
import 'package:app/pages/sensor.dart';
import 'package:app/pages/view.dart';
import 'package:app/pages/view_image.dart';
import 'package:app/services/data_wrapper.dart';
import 'package:app/services/device_type.dart';
import 'package:app/services/image_graph.dart';
import 'package:app/services/return_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DataWrapper data = DataWrapper(type: DeviceType.temperature);

  Widget buildCard(
      {required String text,
      required double value,
      required List<String> capture,
      bool addViewButton = true}) {
    return Card(
      elevation: 10,
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    if (addViewButton)
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => View(capture: capture),
                              ));
                        },
                        icon: const Text(
                          'View',
                          style: TextStyle(color: Colors.black),
                        ),
                        label: const Icon(
                          Icons.more_horiz,
                          size: 30,
                          color: Colors.blueGrey,
                        ),
                      )
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Text(
                  value.toString() + data.symbol(),
                  style: const TextStyle(
                      fontSize: 35,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() {
    return const Divider(
      color: Color.fromRGBO(196, 31, 59, 1),
      thickness: 1,
      height: 40,
    );
  }

  Widget infoWidget(String text, IconData iconData) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 40,
              ),
            ],
          )
        ],
      ),
    );
  }

  List<String> getCaptures(List<String> data) {
    return List<String>.from(data.map((e) => e.split(' ').last).toList());
  }

  Widget homeScreenWidgets() {
    if (!data.success) {
      return infoWidget('Error: ${data.error}', Icons.error);
    }

    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        buildCard(
            text: "Latest",
            value:
                data.latest.data.isNotEmpty ? data.latest.data[0].value : -999,
            capture: List<String>.filled(
                1,
                data.latest.data.isNotEmpty
                    ? data.latest.data[0].capture
                    : '')),
        buildDivider(),
        buildCard(
            text: "Average today",
            value: data.avgToday.data,
            capture: [],
            addViewButton: false),
        buildDivider(),
        buildCard(
            text: 'Today\'s median',
            value: data.medianToday.data,
            capture: [],
            addViewButton: false),
        buildDivider(),
        buildCard(
            text: 'Today\'s std deviation',
            value: data.stDeviationToday.data,
            capture: [],
            addViewButton: false),
        buildDivider(),
        buildCard(
            text: 'All today\'s values',
            value: data.today.data.isNotEmpty
                ? data.today.data[data.today.data.length - 1].value
                : -99,
            capture: data.today.data
                .map((e) =>
                    e.value.toString() +
                    '${data.symbol()}  ' +
                    e.capture.split(' ').last)
                .toList()),
        buildDivider(),
        buildCard(
            text: 'Max today',
            value: data.maxToday.data,
            capture: getCaptures(data.maxToday.captured)),
        buildDivider(),
        buildCard(
            text: 'Min today',
            value: data.minToday.data,
            capture: getCaptures(data.minToday.captured)),
        buildDivider(),
        buildCard(
            text: 'Absolute max',
            value: data.max.data,
            capture: data.max.captured),
        buildDivider(),
        buildCard(
            text: 'Absolute min',
            value: data.min.data,
            capture: data.min.captured),
      ],
    );
  }

  Widget loading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SpinKitFadingCircle(
          color: Color.fromRGBO(255, 125, 10, 1),
          size: 80.0,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          "Loading",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }

  Widget mainScreen() {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              tooltip: 'View graph',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewImage(data: data.imageGraph.image),
                    ));
              },
              icon: const Icon(
                Icons.image,
                size: 30,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            IconButton(
                tooltip: 'Choose sensor type',
                onPressed: () async {
                  dynamic result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Sensor(),
                      ));

                  setState(() {
                    if (result != null) {
                      data = DataWrapper(type: result['deviceType']);
                    }
                  });
                },
                icon: const Icon(
                  Icons.menu,
                  size: 30,
                )),
          ],
          leading: IconButton(
            tooltip: 'Export data to pdf',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Pdf(type: data.type)));
            },
            icon: const Icon(
              Icons.file_download,
              size: 30,
            ),
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
        body: FutureBuilder(
            future: data.getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return infoWidget('Not connected', Icons.wifi_lock);
                case ConnectionState.waiting:
                  return loading();
                case ConnectionState.active:
                  return infoWidget('Active connection', Icons.add);
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return infoWidget('Error: ${snapshot.error}', Icons.error);
                  }
                  return homeScreenWidgets();
              }
            }));
  }

  Widget _alertDialog() {
    return AlertDialog(
      elevation: 25,
      title: const Text('No network connection or server error'),
      content: const Text(
          'No network connectivity or server error, the program will now close.'),
      actions: [
        TextButton(
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: const Text('OK'))
      ],
    );
  }

  Future<void> _storagePermission() async {
    if (!await Permission.storage.request().isGranted) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
                elevation: 25,
                title: const Text('Storage permission denied!'),
                content:
                    const Text('The app requires enabled storage permission.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                      },
                      child: const Text('Close')),
                  TextButton(
                      onPressed: () {
                        openAppSettings();
                      },
                      child: const Text('Open settings'))
                ],
              ));
    }
  }

  Future<String> getKey() async {
    return await const FlutterSecureStorage().read(key: 'key') ?? '401';
  }

  Future<bool> _isServerOnline() async {
    ReturnFields.key = await getKey();
    ImageGraph.imageHeaders['X-API-Key'] = await getKey();

    try {
      Response response = await get(ReturnFields.url);
      if (response.statusCode == 503) {
        throw Exception('Server not online');
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  bool network = false;

  Future<void> _checkInternet() async {
    network = await _isServerOnline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: Future.wait([_checkInternet(), _storagePermission()]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return infoWidget('Not connected', Icons.wifi_lock);
          case ConnectionState.waiting:
            return loading();
          case ConnectionState.active:
            return infoWidget('Active connection', Icons.add);
          case ConnectionState.done:
            if (snapshot.hasError) {
              return infoWidget('Error: ${snapshot.error}', Icons.error);
            }
            if (!network) {
              return _alertDialog();
            }
            return mainScreen();
        }
      },
    ));
  }
}
