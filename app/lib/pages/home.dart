import 'package:app/services/data_wrapper.dart';
import 'package:app/services/device_type.dart';
import 'package:app/services/return_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void setup() async {
    ReturnFields.key =
        await const FlutterSecureStorage().read(key: 'key') ?? '401';
    DataWrapper data = DataWrapper(type: DeviceType.TEMPERATURE);
    await data.getData();
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

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
                        onPressed: () {},
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

  @override
  Widget build(BuildContext context) {
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
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            buildCard(context: context, text: "Latest", value: 25.40),
            buildDivider(context),
            buildCard(
                context: context,
                text: "Average today",
                value: 22.10,
                addViewButton: false),
            buildDivider(context),
            buildCard(context: context, text: 'Max today', value: 26.2),
            buildDivider(context),
            buildCard(context: context, text: 'Min today', value: 18.5),
            buildDivider(context),
            buildCard(context: context, text: 'Absolute max', value: 28),
            buildDivider(context),
            buildCard(context: context, text: 'Absolute min', value: 14.4),
          ],
        ));
  }
}
