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
    );
  }
}
