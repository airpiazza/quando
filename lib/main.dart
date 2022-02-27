import 'package:flutter/material.dart';
import 'package:quando/birthday_information.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quando',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color.fromRGBO(169, 111, 195, 1.0)
      ),
      home: const MyHomePage(title: 'quando'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
            child: ListView(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const ListTile(
                            title: Text(
                              "TODAY'S BIRTHDAYS",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(),
                          const ListTile(
                            title: Text("Michael Scott"),
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text("Kevin Malone"),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const BirthdayInformation(title: "quando",)));
                            },
                          ),
                        ],
                      )
                  ),
                ),
                Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const <Widget>[
                        ListTile(
                          title: Text(
                            "UPCOMING BIRTHDAYS",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Oscar"),
                          trailing: Text("3/1"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Stanley"),
                          trailing: Text("3/2"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Ryan"),
                          trailing: Text("3/3"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Pam"),
                          trailing: Text("3/4"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Angela"),
                          trailing: Text("3/5"),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
          Container(
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
                            "ADD BIRTHDAY",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Name'
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Date'
                              )
                          ),
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
          Container(
            margin: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
            child: ListView(
              children: <Widget>[
                Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const <Widget>[
                        ListTile(
                          title: Text(
                            "BIRTHDAYS",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(Icons.search),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Oscar"),
                          trailing: Text("3/1"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Stanley"),
                          trailing: Text("3/2"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Ryan"),
                          trailing: Text("3/3"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Pam"),
                          trailing: Text("3/4"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Angela"),
                          trailing: Text("3/5"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Kelly"),
                          trailing: Text("3/6"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Creed"),
                          trailing: Text("3/7"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Jim"),
                          trailing: Text("3/8"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Dwight"),
                          trailing: Text("3/9"),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
        ].elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_rounded),
              label: 'Add Birthday'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Birthdays'
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pinkAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
