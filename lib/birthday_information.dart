import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quando/main.dart';

class BirthdayInformation extends StatefulWidget {
  const BirthdayInformation(
      {Key? key,
      required this.title,
      required this.name,
      required this.birthDate,
      required this.timeStamp,
      required this.originalName})
      : super(key: key);

  final String title;
  final String timeStamp;
  final String name;
  final String birthDate;
  final String originalName;

  @override
  _BirthdayInformationState createState() => _BirthdayInformationState();
}

class _BirthdayInformationState extends State<BirthdayInformation> {
  var name = "";
  var date = "";
  String? currentUserID;
  var updating = false;

  @override
  Widget build(BuildContext context) {
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
        iconTheme: const IconThemeData(color: Colors.grey),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Card(
                  margin: const EdgeInsets.only(
                      top: 20.0, left: 12.0, right: 12.0, bottom: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: updating
                            ? const LinearProgressIndicator(
                                value: null,
                                color: Colors.teal,
                              )
                            : null,
                      ),
                      ListTile(
                        title: Text(
                          widget.name.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: Text(
                            name.isEmpty || name == null ? widget.name : name),
                        trailing: Icon(Icons.edit),
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                var nameController = TextEditingController();
                                final _formKey = GlobalKey<FormState>();

                                return Form(
                                  key: _formKey,
                                  child: SimpleDialog(
                                    title: const Text("EDIT NAME"),
                                    children: [
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0,
                                            right: 16.0,
                                            bottom: 16.0),
                                        child: TextFormField(
                                          controller: nameController,
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
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 16.0,
                                              left: 16.0,
                                              right: 16.0,
                                              bottom: 4.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 46,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      setState(() {
                                                        name =
                                                            nameController.text;
                                                      });

                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: const Text("OKAY"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: Colors.teal),
                                                ),
                                              ),
                                              const Spacer(flex: 2),
                                              Expanded(
                                                flex: 46,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("CANCEL"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: const Color
                                                                  .fromRGBO(148,
                                                              97, 171, 1.0)),
                                                ),
                                              )
                                            ],
                                          ))
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                      ListTile(
                        title: Text(DateFormat.yMMMMd('en_US').format(
                            DateTime.parse(
                                date.isEmpty ? widget.birthDate : date))),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.parse(widget.birthDate),
                                  firstDate: DateTime(0000, 1, 1),
                                  lastDate: DateTime.now())
                              .then((selectedBirthdate) {
                            print(selectedBirthdate);
                            if (selectedBirthdate != null) {
                              setState(() {
                                date = DateFormat('yyyy-MM-dd')
                                    .format(selectedBirthdate);
                                print(date);
                              });
                            }
                          });
                        },
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              bottom: 4.0, top: 12, right: 16, left: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      updating = true;
                                    });

                                    print(name.isEmpty || name == null
                                        ? widget.name
                                        : name);
                                    print(date.isEmpty || date == null
                                        ? widget.birthDate
                                        : date);

                                    if (FirebaseAuth.instance.currentUser !=
                                        null) {
                                      currentUserID = FirebaseAuth
                                          .instance.currentUser?.uid
                                          .toString();
                                    }

                                    var birthdayID =
                                        '${widget.originalName} ${widget.timeStamp}';

                                    await FirebaseDatabase.instance
                                        .ref()
                                        .child(
                                            "users/$currentUserID/birthdays/$birthdayID")
                                        .update({
                                      "name": name.isEmpty ? widget.name : name,
                                      "birthdate": date.isEmpty
                                          ? widget.birthDate
                                          : date,
                                    }).then((value) {
                                      setState(() {
                                        updating = false;
                                      });

                                      const snackBar = SnackBar(
                                          content: Text(
                                              'Birthday information updated!'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }).catchError((error) {
                                      setState(() {
                                        updating = false;
                                      });

                                      const snackBar = SnackBar(
                                          content: Text(
                                              'Looks like something went wrong with updating that person\'s birthday information.'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    });
                                  },
                                  child: const Text("SAVE"),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.teal),
                                ),
                              )
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              bottom: 16.0, top: 4, right: 16, left: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (buildContext) {
                                          return AlertDialog(
                                            title:
                                                const Text("DELETE BIRTHDAY?"),
                                            content: const Text(
                                                "Would you like to delete this birthday?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      updating = true;
                                                    });

                                                    if (FirebaseAuth.instance
                                                            .currentUser !=
                                                        null) {
                                                      currentUserID =
                                                          FirebaseAuth.instance
                                                              .currentUser?.uid
                                                              .toString();
                                                    }

                                                    var birthdayID =
                                                        '${widget.originalName} ${widget.timeStamp}';

                                                    await FirebaseDatabase
                                                        .instance
                                                        .ref()
                                                        .child(
                                                            "users/$currentUserID/birthdays/$birthdayID")
                                                        .remove()
                                                        .then((value) {
                                                      setState(() {
                                                        updating = false;
                                                      });

                                                      const snackBar = SnackBar(
                                                          content: Text(
                                                              'Birthday deleted.'));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: "quando")));
                                                    }).catchError((error) {
                                                      setState(() {
                                                        updating = false;
                                                      });

                                                      const snackBar = SnackBar(
                                                          content: Text(
                                                              'Looks like something went wrong with deleting that person\'s birthday information.'));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);

                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Text("Yes")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("No"))
                                            ],
                                          );
                                        });
                                  },
                                  child: const Text("DELETE BIRTHDAY"),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red),
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
    );
  }
}
