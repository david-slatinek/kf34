import 'package:flutter/material.dart';

class View extends StatelessWidget {
  const View({Key? key, required this.capture}) : super(key: key);

  final List<String> capture;

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
        itemCount: capture.length,
        itemBuilder: (context, index) {
          return Card(
            shadowColor: Colors.black,
            elevation: 5,
            margin: const EdgeInsets.all(5),
            child: ListTile(
              tileColor: Colors.grey[200],
              leading: const Icon(
                Icons.today,
                size: 40,
              ),
              title: Center(
                  child: Text(
                capture[index],
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
