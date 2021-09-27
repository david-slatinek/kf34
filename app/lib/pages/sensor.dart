import 'package:app/services/device_type.dart';
import 'package:flutter/material.dart';

class Sensor extends StatelessWidget {
  const Sensor({Key? key}) : super(key: key);

  static const List<DeviceType> sensors = [
    DeviceType.TEMPERATURE,
    DeviceType.HUMIDITY
  ];

  static const List<IconData> icons = [Icons.device_thermostat, Icons.air];

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
      body: ListView.separated(
        padding: const EdgeInsets.all(10),
        itemCount: sensors.length,
        itemBuilder: (context, index) {
          return Card(
            shadowColor: Colors.black,
            elevation: 5,
            margin: const EdgeInsets.all(5),
            child: ListTile(
              onTap: () {
                Navigator.pop(context, {
                  'deviceType': sensors[index],
                });
              },
              tileColor: Colors.grey[200],
              leading: Icon(
                icons[index],
                size: 40,
              ),
              title: Center(
                  child: Text(
                sensors[index].asString(),
                style: const TextStyle(fontSize: 20),
              )),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          thickness: 2,
        ),
      ),
    );
  }
}
