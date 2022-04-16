import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var emailError = false;
  var registrationLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.all(35),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const Text(
                            "quando",
                            style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                fontSize: 50
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 4),
                          child: TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Name',
                            ),
                            validator: (nameValue) {
                              if(nameValue == null || nameValue.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 4),
                          child: TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Email',
                            ),
                            validator: (emailValue) {
                              if(!EmailValidator.validate(emailValue.toString())){
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 20.0),
                          child: TextFormField(
                              controller: passwordController,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Password'
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
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    registrationLoading = true;
                                  });

                                  if(_formKey.currentState!.validate()) {
                                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                        email: emailController.text.toLowerCase().trim(),
                                        password: passwordController.text
                                    ).then((value) async {
                                      String? currentUserID;

                                      User? currentUser = FirebaseAuth.instance.currentUser;

                                      if(currentUser != null) {
                                        currentUserID = currentUser.uid.toString();
                                      }

                                      if(currentUser != null) {
                                        await currentUser.updateDisplayName(nameController.text).then((value) {
                                            const snackBar = SnackBar(content: Text('Registration successful!'));
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                            setState(() {
                                              registrationLoading = false;
                                            });
                                            Navigator.pop(context);
                                        }).catchError((error) {
                                            const snackBar = SnackBar(content: Text('Remember to add your name and email in the settings once you sign in!'));
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                            setState(() {
                                              registrationLoading = false;
                                            });
                                            Navigator.pop(context);
                                        });
                                      }

                                      // await FirebaseDatabase.instance.ref().child("users/$currentUserID/info").set({
                                      //   "name": nameController.text,
                                      //   "email": emailController.text
                                      // }).then((value){
                                      //   const snackBar = SnackBar(content: Text('Registration successful!'));
                                      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      // }).catchError((error){
                                      //   const snackBar = SnackBar(content: Text('Remember to add your name and email in the settings once you sign in!'));
                                      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      // });

                                      // if(currentUser != null && !currentUser.emailVerified) {
                                      //   await currentUser.sendEmailVerification().then((value) {
                                      //     setState(() {
                                      //       registrationLoading = false;
                                      //     });
                                      //
                                      //     const snackBar = SnackBar(content: Text('Check your inbox to verify your email!'));
                                      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      //
                                      //     Navigator.pop(context);
                                      //   }).catchError((error) {
                                      //     setState(() {
                                      //       registrationLoading = false;
                                      //     });
                                      //
                                      //     const snackBar = SnackBar(content: Text("Looks like we couldn't send your verification email. You can try to resend it in settings."));
                                      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      //
                                      //     Navigator.pop(context);
                                      //   });
                                      // }

                                    }).catchError((error) {
                                      setState(() {
                                        registrationLoading = false;
                                      });

                                      const snackBar = SnackBar(content: Text('Looks like something went wrong with your registration. Try again!'));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    });
                                  } else {
                                      const snackBar = SnackBar(content: Text('Please enter your name, a valid email, and a password at least 6 characters long.'));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                      setState(() {
                                        registrationLoading = false;
                                      });
                                  }
                                },
                                child: const Text("REGISTER"),
                                style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(148, 97, 171, 1.0)),
                              ),
                            )
                          ],
                        ),
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: const Text("Sign In",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color.fromRGBO(148, 97, 171, 1.0)
                              ),
                            )
                        ),
                        Container(
                            child: registrationLoading ? const CircularProgressIndicator(
                                value: null,
                              color: Color.fromRGBO(148, 97, 171, 1.0),
                            ) : null
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
