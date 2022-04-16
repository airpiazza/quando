import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quando/sign_in.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var isLoading = false;
  var userNameController = TextEditingController();
  var newEmailUserEmailController = TextEditingController();
  var newEmailUserPasswordController = TextEditingController();
  var newEmailController = TextEditingController();
  var newEmailCredentialsInvalid = false;
  var newPasswordUserEmailController = TextEditingController();
  var newPasswordUserPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var newPasswordCredentialsInvalid = false;
  var deleteAccountUserEmailController = TextEditingController();
  var deleteAccountUserPasswordController = TextEditingController();
  var deleteAccountCredentialsInvalid = false;
  var currentUserDisplayName = "Name";
  var currentUserEmail = "Email";
  String? currentUserID = "";

  _SettingsState() {
    if(FirebaseAuth.instance.currentUser != null) {
      currentUserDisplayName = FirebaseAuth.instance.currentUser!.displayName.toString();
      currentUserEmail = FirebaseAuth.instance.currentUser!.email.toString();
    }

    FirebaseAuth.instance.userChanges().listen((event) {
      setState(() {
        if(FirebaseAuth.instance.currentUser != null) {
          currentUserDisplayName = FirebaseAuth.instance.currentUser!.displayName.toString();
          currentUserEmail = FirebaseAuth.instance.currentUser!.email.toString();
        }
      });
    });
  }

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
                        title: Text(currentUserDisplayName.toString()),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          showDialog(
                              barrierDismissible: true,
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
                                                  onPressed: () async {
                                                    String? currentUserID;

                                                    User? currentUser = FirebaseAuth.instance.currentUser;

                                                    if(currentUser != null) {
                                                      currentUserID = currentUser.uid.toString();
                                                    }

                                                    if (_formKey.currentState!
                                                        .validate()) {

                                                      await FirebaseAuth.instance.currentUser!.updateDisplayName(userNameController.text).then((value) {
                                                        const snackBar = SnackBar(content: Text('Name successfully changed!'));
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      }).catchError((error) {
                                                        const snackBar = SnackBar(content: Text('Looks like something went wrong with changing your name'));
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      });

                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: const Text("SAVE"),
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
                        // title: Text(userInfo.isEmpty
                        //     ? widget.userInfo[0]["email"]
                        //     : userInfo[0]["email"]),
                        title: Text(currentUserEmail.toString()),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                final _formKey = GlobalKey<FormState>();

                                return StatefulBuilder(builder: (context, setState) {
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
                                              bottom: 4.0),
                                          child: TextFormField(
                                            controller: newEmailUserEmailController,
                                            decoration: InputDecoration(
                                                border: const UnderlineInputBorder(),
                                                labelText: 'Email',
                                                errorText: newEmailCredentialsInvalid ? "Your email/password is incorrect" : null
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                                          child: TextFormField(
                                              obscureText: true,
                                              controller: newEmailUserPasswordController,
                                              decoration: InputDecoration(
                                                  border: const UnderlineInputBorder(),
                                                  labelText: 'Password',
                                                  errorText: newEmailCredentialsInvalid ? "Your email/password is incorrect" : null
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4,
                                              left: 16.0,
                                              right: 16.0,
                                              bottom: 16.0),
                                          child: TextFormField(
                                            controller: newEmailController,
                                            decoration: const InputDecoration(
                                                border: UnderlineInputBorder(),
                                                labelText: 'New email'),
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
                                                    onPressed: () async {
                                                      AuthCredential emailAuthCredential = EmailAuthProvider.credential(email: newEmailUserEmailController.text, password: newEmailUserPasswordController.text);

                                                      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(emailAuthCredential).then((value) async {
                                                        setState(() {
                                                          newEmailCredentialsInvalid = false;
                                                        });
                                                        if (_formKey.currentState!
                                                            .validate()) {
                                                          await FirebaseAuth.instance.currentUser!.updateEmail(newEmailController.text).then((value) {
                                                            const snackBar = SnackBar(content: Text('Email successfully changed!'));
                                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                                            Navigator.pop(context);
                                                          }).catchError((error) async {
                                                            const snackBar = SnackBar(content: Text('Looks like something went wrong with changing your email.'));
                                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                          });
                                                        }
                                                      }).catchError((error) {
                                                        setState(() {
                                                          newEmailCredentialsInvalid = true;
                                                        });

                                                        const snackBar = SnackBar(content: Text('Looks like something went wrong with authenticating you. Your email wasn\'t changed unfortunately.'));
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      });
                                                      // }
                                                    },
                                                    child: const Text("SAVE"),
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

                                // return Form(
                                //   key: _formKey,
                                //   child: SimpleDialog(
                                //     title: const Text("EDIT EMAIL"),
                                //     children: [
                                //       const Divider(),
                                //       Padding(
                                //         padding: const EdgeInsets.only(
                                //             left: 16.0,
                                //             right: 16.0,
                                //             bottom: 4.0),
                                //         child: TextFormField(
                                //           controller: userEmailController,
                                //           decoration: InputDecoration(
                                //               border: const UnderlineInputBorder(),
                                //               labelText: 'Email',
                                //               errorText: credentialsInvalid ? "Your email and password combination is invalid" : null
                                //           ),
                                //           validator: (emailValue) {
                                //             if (!EmailValidator.validate(
                                //                 emailValue.toString())) {
                                //               return 'Please enter a valid email';
                                //             }
                                //             return null;
                                //           },
                                //         ),
                                //       ),
                                //       Padding(
                                //         padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                                //         child: TextFormField(
                                //             obscureText: true,
                                //             controller: userPasswordController,
                                //             decoration: InputDecoration(
                                //                 border: const UnderlineInputBorder(),
                                //                 labelText: 'Password',
                                //                 errorText: credentialsInvalid ? "Your email and password combination is invalid" : null
                                //             )
                                //         ),
                                //       ),
                                //       Padding(
                                //         padding: const EdgeInsets.only(
                                //             top: 4,
                                //             left: 16.0,
                                //             right: 16.0,
                                //             bottom: 16.0),
                                //         child: TextFormField(
                                //           controller: newEmailController,
                                //           decoration: const InputDecoration(
                                //               border: UnderlineInputBorder(),
                                //               labelText: 'New email'),
                                //           validator: (emailValue) {
                                //             if (!EmailValidator.validate(
                                //                 emailValue.toString())) {
                                //               return 'Please enter a valid email';
                                //             }
                                //             return null;
                                //           },
                                //         ),
                                //       ),
                                //       Padding(
                                //           padding: const EdgeInsets.only(
                                //               top: 16.0,
                                //               left: 16.0,
                                //               right: 16.0,
                                //               bottom: 4.0),
                                //           child: Row(
                                //             children: [
                                //               Expanded(
                                //                 flex: 46,
                                //                 child: ElevatedButton(
                                //                   onPressed: () async {
                                //                     // if (_formKey.currentState!
                                //                     //     .validate()) {
                                //                       AuthCredential emailAuthCredential = EmailAuthProvider.credential(email: userEmailController.text, password: userPasswordController.text);
                                //
                                //                       await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(emailAuthCredential).then((value) async {
                                //                         setState(() {
                                //                           credentialsInvalid = false;
                                //                         });
                                //
                                //                         await FirebaseAuth.instance.currentUser!.updateEmail(newEmailController.text).then((value) {
                                //                             const snackBar = SnackBar(content: Text('Email successfully changed!'));
                                //                             ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                //
                                //                             Navigator.pop(context);
                                //                           }).catchError((error) async {
                                //                             const snackBar = SnackBar(content: Text('Looks like something went wrong with changing your email.'));
                                //                             ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                //                           });
                                //                       }).catchError((error) {
                                //                         setState(() {
                                //                           credentialsInvalid = true;
                                //                         });
                                //
                                //                         const snackBar = SnackBar(content: Text('Looks like something went wrong with authenticating you. Your email wasn\'t changed unfortunately.'));
                                //                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                //                       });
                                //                     // }
                                //                   },
                                //                   child: const Text("SAVE"),
                                //                   style:
                                //                       ElevatedButton.styleFrom(
                                //                           primary: Colors.teal),
                                //                 ),
                                //               ),
                                //               const Spacer(flex: 2),
                                //               Expanded(
                                //                 flex: 46,
                                //                 child: ElevatedButton(
                                //                   onPressed: () {
                                //                     Navigator.pop(context);
                                //                   },
                                //                   child: const Text("CANCEL"),
                                //                   style:
                                //                       ElevatedButton.styleFrom(
                                //                           primary: const Color
                                //                                   .fromRGBO(148,
                                //                               97, 171, 1.0)),
                                //                 ),
                                //               )
                                //             ],
                                //           ))
                                //     ],
                                //   ),
                                // );
                              });
                        },
                      ),
                      ListTile(
                        title: const Text("Change password"),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                final _formKey = GlobalKey<FormState>();

                                return StatefulBuilder(builder: (context, setState) {
                                  return Form(
                                    key: _formKey,
                                    child: SimpleDialog(
                                      title: const Text("EDIT PASSWORD"),
                                      children: [
                                        const Divider(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0,
                                              right: 16.0,
                                              bottom: 4.0),
                                          child: TextFormField(
                                            controller: newPasswordUserEmailController,
                                            decoration: InputDecoration(
                                                border: const UnderlineInputBorder(),
                                                labelText: 'Email',
                                                errorText: newPasswordCredentialsInvalid ? "Your email/password is incorrect" : null
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                                          child: TextFormField(
                                              obscureText: true,
                                              controller: newPasswordUserPasswordController,
                                              decoration: InputDecoration(
                                                  border: const UnderlineInputBorder(),
                                                  labelText: 'Password',
                                                  errorText: newPasswordCredentialsInvalid ? "Your email/password is incorrect" : null
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4,
                                              left: 16.0,
                                              right: 16.0,
                                              bottom: 16.0),
                                          child: TextFormField(
                                            controller: newPasswordController,
                                            decoration: const InputDecoration(
                                                border: UnderlineInputBorder(),
                                                labelText: 'New password',
                                            ),
                                            obscureText: true,
                                            validator: (passwordValue) {
                                              if(passwordValue.toString().length < 6) {
                                                return 'Your password must be at least 6 characters long';
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
                                                    onPressed: () async {
                                                      AuthCredential emailAuthCredential = EmailAuthProvider.credential(email: newPasswordUserEmailController.text, password: newPasswordUserPasswordController.text);

                                                      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(emailAuthCredential).then((value) async {
                                                        setState(() {
                                                          newPasswordCredentialsInvalid = false;
                                                        });
                                                        if (_formKey.currentState!
                                                            .validate()) {
                                                          await FirebaseAuth.instance.currentUser!.updatePassword(newPasswordController.text).then((value) {
                                                            const snackBar = SnackBar(content: Text('Password successfully changed!'));
                                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                                            Navigator.pop(context);
                                                          }).catchError((error) async {
                                                            const snackBar = SnackBar(content: Text('Looks like something went wrong with changing your password.'));
                                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                          });
                                                        }
                                                      }).catchError((error) {
                                                        setState(() {
                                                          newPasswordCredentialsInvalid = true;
                                                        });

                                                        const snackBar = SnackBar(content: Text('Looks like something went wrong with authenticating you. Your password wasn\'t changed unfortunately.'));
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      });
                                                      // }
                                                    },
                                                    child: const Text("SAVE"),
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
                              });
                        },
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, bottom: 4, left: 16, right: 16),
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
                                      primary: Colors.redAccent),
                                ),
                              )
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 4, bottom: 16, left: 16, right: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) {
                                          final _formKey = GlobalKey<FormState>();

                                          return StatefulBuilder(builder: (context, setState) {
                                            return Form(
                                              key: _formKey,
                                              child: SimpleDialog(
                                                title: const Text("DELETE ACCOUNT"),
                                                children: [
                                                  const Divider(),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 16.0,
                                                        right: 16.0,
                                                        bottom: 4.0),
                                                    child: TextFormField(
                                                      controller: deleteAccountUserEmailController,
                                                      decoration: InputDecoration(
                                                          border: const UnderlineInputBorder(),
                                                          labelText: 'Email',
                                                          errorText: deleteAccountCredentialsInvalid ? "Your email/password is incorrect" : null
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                                                    child: TextFormField(
                                                        obscureText: true,
                                                        controller: deleteAccountUserPasswordController,
                                                        decoration: InputDecoration(
                                                            border: const UnderlineInputBorder(),
                                                            labelText: 'Password',
                                                            errorText: deleteAccountCredentialsInvalid ? "Your email/password is incorrect" : null
                                                        )
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
                                                              onPressed: () async {
                                                                AuthCredential emailAuthCredential = EmailAuthProvider.credential(email: deleteAccountUserEmailController.text, password: deleteAccountUserPasswordController.text);

                                                                await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(emailAuthCredential).then((value) async {
                                                                  setState(() {
                                                                    deleteAccountCredentialsInvalid = false;
                                                                  });

                                                                  if (FirebaseAuth.instance.currentUser != null) {
                                                                    currentUserID = FirebaseAuth.instance.currentUser?.uid.toString();

                                                                  await FirebaseDatabase.instance
                                                                      .ref()
                                                                      .child("users/$currentUserID").remove().then((value) {
                                                                    const snackBar = SnackBar(content: Text('Your birthdays have been successfully deleted'));
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  }).catchError((error) {
                                                                    const snackBar = SnackBar(content: Text('Looks like something went wrong with deleting your birthdays!'));
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  });

                                                                    await FirebaseAuth.instance.currentUser!.delete().then((value) {
                                                                      const snackBar = SnackBar(content: Text('Account successfully deleted!'));
                                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => const SignIn()));
                                                                    }).catchError((error) async {
                                                                      const snackBar = SnackBar(content: Text('Looks like something went wrong with deleting your account'));
                                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                    });

                                                                }}).catchError((error) {
                                                                  setState(() {
                                                                    deleteAccountCredentialsInvalid = true;
                                                                  });

                                                                  const snackBar = SnackBar(content: Text('Looks like something went wrong with authenticating you. Your account wasn\'t deleted.'));
                                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                });
                                                                // }
                                                              },
                                                              child: const Text("CONFIRM"),
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
                                        });
                                  },
                                  child: const Text("DELETE ACCOUNT"),
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

// print(userName.isEmpty
//     ? widget.userInfo[0]["name"]
//     : userName);
// print(userEmail.isEmpty
//     ? widget.userInfo[0]["email"]
//     : userEmail);
