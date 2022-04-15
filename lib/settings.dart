import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quando/sign_in.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key, required this.title, required this.userInfo})
      : super(key: key);

  final String title;
  final List userInfo;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var isLoading = false;
  var userNameController = TextEditingController();
  var userEmailController = TextEditingController();
  var userName = "";
  var userEmail = "";

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
                      top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: isLoading
                              ? const LinearProgressIndicator(
                                  value: null,
                                  color: Colors.teal,
                                )
                              : null),
                      const ListTile(
                        title: Text(
                          "SETTINGS",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        title: Text(userName.isEmpty
                            ? widget.userInfo[0]["name"]
                            : userName),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
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
                                          controller: userNameController,
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
                                                        userName =
                                                            userNameController
                                                                .text;
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
                        title: Text(userEmail.isEmpty
                            ? widget.userInfo[0]["email"]
                            : userEmail),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                final _formKey = GlobalKey<FormState>();

                                return Form(
                                  key: _formKey,
                                  child: SimpleDialog(
                                    title: const Text("EDIT EMAIL"),
                                    children: [
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0,
                                            right: 16.0,
                                            bottom: 16.0),
                                        child: TextFormField(
                                          controller: userEmailController,
                                          decoration: const InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: 'Email'),
                                          validator: (emailValue) {
                                            if (!EmailValidator.validate(
                                                emailValue.toString())) {
                                              return 'Please enter a valid email';
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
                                                        userEmail =
                                                            userEmailController
                                                                .text;
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
                      const ListTile(
                        title: Text("Change password"),
                        trailing: Icon(Icons.edit),
                      ),
                      // Padding(
                      //     padding: const EdgeInsets.only(
                      //         top: 16.0, bottom: 4, left: 16, right: 16),
                      //     child: Row(
                      //       children: [
                      //         Expanded(
                      //           child: ElevatedButton(
                      //             onPressed: () {
                      //               print(userName.isEmpty
                      //                   ? widget.userInfo[0]["name"]
                      //                   : userName);
                      //               print(userEmail.isEmpty
                      //                   ? widget.userInfo[0]["email"]
                      //                   : userEmail);
                      //             },
                      //             child: const Text("SAVE"),
                      //             style: ElevatedButton.styleFrom(
                      //                 primary: Colors.teal),
                      //           ),
                      //         )
                      //       ],
                      //     )),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, bottom: 16, left: 16, right: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    await FirebaseAuth.instance
                                        .signOut()
                                        .then((value) {
                                      setState(() {
                                        isLoading = false;
                                      });

                                      const snackBar = SnackBar(
                                          content:
                                              Text('Sign out successful.'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignIn()));
                                    }).catchError((error) {
                                      setState(() {
                                        isLoading = false;
                                      });

                                      const snackBar = SnackBar(
                                          content: Text(
                                              'Looks like something went wrong with signing out.'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    });
                                  },
                                  child: const Text("SIGN OUT"),
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
