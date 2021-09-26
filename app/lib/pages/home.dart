import 'package:app/services/data_wrapper.dart';
import 'package:app/services/device_type.dart';
import 'package:app/services/return_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DataWrapper data = DataWrapper(type: DeviceType.TEMPERATURE);

  Widget buildCard(
      {required BuildContext context,
      required String text,
      required double value,
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
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    if (addViewButton)
                      OutlinedButton.icon(
                        onPressed: () {
                          print('Navigator.push(/view)');
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
                  value.toString(),
                  style: const TextStyle(
                      fontSize: 40,
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

  Widget buildDivider(BuildContext context) {
    return const Divider(
      color: Color.fromRGBO(196, 31, 59, 1),
      thickness: 1,
      height: 40,
    );
  }

  Widget homeScreenWidgets() {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        buildCard(
            context: context, text: "Latest", value: data.latest.data[0].value),
        buildDivider(context),
        buildCard(
            context: context,
            text: "Average today",
            value: data.avgToday.data,
            addViewButton: false),
        buildDivider(context),
        buildCard(
            context: context, text: 'Max today', value: data.maxToday.data),
        buildDivider(context),
        buildCard(
            context: context, text: 'Min today', value: data.minToday.data),
        buildDivider(context),
        buildCard(context: context, text: 'Absolute max', value: data.max.data),
        buildDivider(context),
        buildCard(context: context, text: 'Absolute min', value: data.min.data),
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

  Widget infoWidget(String text, IconData iconData) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 30),
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
    );
  }

  Future<bool> _isServerOnline() async {
    try {
      Response response = await get(ReturnFields.url);
      if (response.statusCode == 503) {
        throw Exception('Server not online');
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  bool network = false;

  Future<void> _checkInternet() async {
    network = await _isServerOnline();
  }

  Widget _alertDialog() {
    return AlertDialog(
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

  Widget mainScreen() {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                tooltip: 'Choose sensor',
                onPressed: () {
                  print('Navigator.push(/sensor)');
                },
                icon: const Icon(
                  Icons.menu,
                  size: 30,
                ))
          ],
          leading: const Icon(
            Icons.house_outlined,
            size: 30,
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
                  } else {
                    return homeScreenWidgets();
                  }
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _checkInternet(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
