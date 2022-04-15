import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quando/birthday_information.dart';
import 'package:quando/firebase_options.dart';
import 'package:quando/settings.dart';
import 'package:quando/sign_in.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        scaffoldBackgroundColor: const Color.fromRGBO(148, 97, 171, 1.0),
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? const MyHomePage(title: "quando")
          : const SignIn(),
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
  DateTime _dateTime = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  var newNameController = TextEditingController();
  var newBirthdateEntry = DateTime.now();
  var saving = false;
  String? currentUserID;
  var birthdayList = [];
  var todaysBirthdays = [];
  var upComingBirthdays = [];
  var userInfo = [];

  _MyHomePageState() {
    loadData();

    FirebaseDatabase.instance
        .ref("users")
        .child(currentUserID!)
        .onChildChanged
        .listen((event) {
      print('data refreshed');
      loadData();
    });
  }

  void loadData() {
    if (FirebaseAuth.instance.currentUser != null) {
      currentUserID = FirebaseAuth.instance.currentUser?.uid.toString();

      FirebaseDatabase.instance
          .ref()
          .child("users/$currentUserID/birthdays")
          .once()
          .then((data) {
        print("data loaded");
        print(data);
        print("key:");
        print(data.snapshot.key);
        print("value");
        print(data.snapshot.value);
        print('children');
        var birthdaysTempList = [];
        for (var element in data.snapshot.children) {
          print(element.key);
          print(element.value);
          birthdaysTempList.add(element.value);
        }
        print("final birthday list");

        birthdaysTempList.sort((a, b) => a["name"].compareTo(b["name"]));
        birthdayList = birthdaysTempList;
        for (var element in birthdayList) {
          print(element.toString());
        }

        var tempTodaysBirthdays = [];
        for (var element in birthdayList) {
          DateTime elementDate = DateTime.parse(element["birthdate"]);
          DateTime todayDate = _dateTime;

          DateTime elementDateSameYear =
              DateTime(2020, elementDate.month, elementDate.day);
          DateTime todaySameYear =
              DateTime(2020, todayDate.month, todayDate.day);

          if (elementDateSameYear == todaySameYear) {
            tempTodaysBirthdays.add(element);
          }
        }
        todaysBirthdays = tempTodaysBirthdays;

        print('todays birthdays');
        print(todaysBirthdays);

        var tempSortedBirthdays = List.from(birthdayList);

        tempSortedBirthdays.sort((a, b) {
          DateTime aDate = DateTime.parse(a["birthdate"]);
          DateTime bDate = DateTime.parse(b["birthdate"]);

          DateTime aDateSameYear = DateTime(2020, aDate.month, aDate.day);
          DateTime bDateSameYear = DateTime(2020, bDate.month, bDate.day);
          return aDateSameYear.isBefore(bDateSameYear)
              ? -1
              : aDateSameYear.isAtSameMomentAs(bDateSameYear)
                  ? 0
                  : 1;
        });

        print('sorted birthdays');
        print(tempSortedBirthdays);

        var birthdaysAfterToday = tempSortedBirthdays.where((element) {
          DateTime elementDate = DateTime.parse(element["birthdate"]);
          DateTime todayDate = _dateTime;

          DateTime elementDateSameYear =
              DateTime(2020, elementDate.month, elementDate.day);
          DateTime todaySameYear =
              DateTime(2020, todayDate.month, todayDate.day);

          return elementDateSameYear.isAfter(todaySameYear);
        }).toList();

        print('birthdays after today');
        print(birthdaysAfterToday);

        var birthdaysBeforeToday = tempSortedBirthdays.where((element) {
          DateTime elementDate = DateTime.parse(element["birthdate"]);
          DateTime todayDate = _dateTime;

          DateTime elementDateSameYear =
              DateTime(2020, elementDate.month, elementDate.day);
          DateTime todaySameYear =
              DateTime(2020, todayDate.month, todayDate.day);

          return elementDateSameYear.isBefore(todaySameYear);
        }).toList();

        print('birthdays before today');
        print(birthdaysBeforeToday);

        upComingBirthdays = [
          ...birthdaysAfterToday.toList(),
          ...birthdaysBeforeToday.toList()
        ];
        print('upcoming birthdays');
        print(upComingBirthdays);
      }).catchError((error) {
        print(error);
      });

      FirebaseDatabase.instance
          .ref()
          .child("users/$currentUserID/info")
          .once()
          .then((data) {
        print(data.snapshot.value);
        userInfo.add(data.snapshot.value);
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
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
          style:
              const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_dateTime.month.toString() + '/' + _dateTime.day.toString(),
                style: TextStyle(color: Colors.grey[700], fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Settings(
                            title: "quando",
                            userInfo: userInfo,
                          )));
            },
            icon: const Icon(Icons.settings),
            color: Colors.grey,
          )
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: ListView(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: todaysBirthdays.isNotEmpty
                      ? Card(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const ListTile(
                              title: Text(
                                "TODAY'S BIRTHDAYS",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                                child: todaysBirthdays.isNotEmpty
                                    ? Column(
                                        children: [
                                          for (var element in todaysBirthdays)
                                            Column(
                                              children: [
                                                const Divider(),
                                                ListTile(
                                                  title: Text(element["name"]),
                                                  trailing: Text(DateFormat
                                                          .yMMMMd('en_US')
                                                      .format(DateTime.parse(
                                                          element[
                                                              "birthdate"]))),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => BirthdayInformation(
                                                                title: "quando",
                                                                name: element[
                                                                    "name"],
                                                                birthDate: element[
                                                                        "birthdate"]
                                                                    .toString(),
                                                                originalName:
                                                                    element[
                                                                        "originalName"],
                                                                timeStamp: element[
                                                                        "timestamp"]
                                                                    .toString())));
                                                  },
                                                ),
                                              ],
                                            )
                                        ],
                                      )
                                    : null),
                          ],
                        ))
                      : null,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const ListTile(
                        title: Text(
                          "UPCOMING BIRTHDAYS",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: upComingBirthdays.isNotEmpty
                            ? Column(
                                children: [
                                  for (var element in upComingBirthdays)
                                    Column(
                                      children: [
                                        const Divider(),
                                        ListTile(
                                          title: Text(element["name"]),
                                          trailing: Text(
                                              DateFormat.yMMMMd('en_US').format(
                                                  DateTime.parse(
                                                      element["birthdate"]))),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BirthdayInformation(
                                                            title: "quando",
                                                            name:
                                                                element["name"],
                                                            birthDate: element[
                                                                    "birthdate"]
                                                                .toString(),
                                                            originalName: element[
                                                                "originalName"],
                                                            timeStamp: element[
                                                                    "timestamp"]
                                                                .toString())));
                                          },
                                        ),
                                      ],
                                    )
                                ],
                              )
                            : Column(
                                children: const [
                                  Divider(),
                                  ListTile(
                                    title: Text(
                                        "Looks like there are no birthdays coming up :("),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
          Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: ListView(
                children: [
                  Card(
                      margin: const EdgeInsets.only(top: 20.0, bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: saving
                                ? const LinearProgressIndicator(
                                    value: null,
                                    color: Colors.teal,
                                  )
                                : null,
                          ),
                          const ListTile(
                            title: Text(
                              "ADD BIRTHDAY",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 16.0),
                            child: TextFormField(
                              controller: newNameController,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Name'),
                              validator: (nameValue) {
                                if (nameValue.toString().isEmpty ||
                                    nameValue == null) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(
                                DateFormat.yMMMMd('en_US')
                                    .format(newBirthdateEntry),
                                style: TextStyle(color: Colors.grey[700])),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () async {
                              showDatePicker(
                                context: context,
                                initialDate: _dateTime,
                                firstDate: DateTime(0000, 1, 1),
                                lastDate: _dateTime,
                              ).then((birthdate) {
                                if (birthdate != null) {
                                  setState(() {
                                    newBirthdateEntry = birthdate;
                                  });
                                }
                              }).catchError((error) {
                                const snackBar = SnackBar(
                                    content: Text(
                                        'Looks like something went wrong with choosing the birthdate.'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            },
                          ),
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          saving = true;
                                        });

                                        if (_formKey.currentState!.validate()) {
                                          if (FirebaseAuth
                                                  .instance.currentUser !=
                                              null) {
                                            currentUserID = FirebaseAuth
                                                .instance.currentUser?.uid
                                                .toString();

                                            var timeStamp = DateTime.now()
                                                .millisecondsSinceEpoch;

                                            var birthdayID =
                                                '${newNameController.text} $timeStamp';

                                            await FirebaseDatabase.instance
                                                .ref()
                                                .child(
                                                    "users/$currentUserID/birthdays/$birthdayID")
                                                .set({
                                              "name": newNameController.text,
                                              "birthdate": DateFormat(
                                                      'yyyy-MM-dd')
                                                  .format(newBirthdateEntry),
                                              "timestamp": timeStamp,
                                              "originalName":
                                                  newNameController.text
                                            }).then((value) {
                                              setState(() {
                                                saving = false;
                                              });

                                              const snackBar = SnackBar(
                                                  content:
                                                      Text('Birthday saved!'));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }).catchError((error) {
                                              setState(() {
                                                saving = false;
                                              });

                                              const snackBar = SnackBar(
                                                  content: Text(
                                                      'Looks like something went wrong with saving that person\'s birthday.'));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            });
                                          }
                                        } else {
                                          saving = false;

                                          const snackBar = SnackBar(
                                              content:
                                                  Text('Please enter a name.'));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                      child: const Text("SAVE"),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.teal),
                                    ),
                                  )
                                ],
                              ))
                        ],
                      )),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: ListView(
              children: <Widget>[
                Card(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const ListTile(
                          title: Text(
                            "BIRTHDAYS",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: birthdayList.isNotEmpty
                              ? Column(
                                  children: [
                                    for (var element in birthdayList)
                                      Column(
                                        children: [
                                          const Divider(),
                                          ListTile(
                                            title: Text(element["name"]),
                                            trailing: Text(
                                                DateFormat.yMMMMd('en_US')
                                                    .format(DateTime.parse(
                                                        element["birthdate"]))),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BirthdayInformation(
                                                              title: "quando",
                                                              name: element[
                                                                  "name"],
                                                              birthDate: element[
                                                                      "birthdate"]
                                                                  .toString(),
                                                              originalName: element[
                                                                  "originalName"],
                                                              timeStamp: element[
                                                                      "timestamp"]
                                                                  .toString())));
                                            },
                                          ),
                                        ],
                                      )
                                  ],
                                )
                              : Column(
                                  children: const [
                                    Divider(),
                                    ListTile(
                                      title: Text(
                                          "Looks like there are no birthdays to show :("),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ].elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_rounded), label: 'Add Birthday'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Birthdays'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pinkAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
