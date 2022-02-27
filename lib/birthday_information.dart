import 'package:flutter/material.dart';

class BirthdayInformation extends StatefulWidget {
  const BirthdayInformation({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _BirthdayInformationState createState() => _BirthdayInformationState();
}

class _BirthdayInformationState extends State<BirthdayInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
          style: const TextStyle(color: Color.fromRGBO(0, 175, 209, 1.0)),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.grey
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
          child: Column(
            children: [
              Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const ListTile(
                        title: Text(
                          "KEVIN",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(),
                      const ListTile(
                        title: Text("Kevin"),
                        trailing: Icon(Icons.edit),
                      ),
                      const ListTile(
                        title: Text("5/1"),
                        trailing: Icon(Icons.edit),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: (){},
                          child: const Text("SAVE"),
                          style: ElevatedButton.styleFrom(primary: Colors.teal),
                        ),
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
