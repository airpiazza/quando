import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quando/forgot_password.dart';
import 'package:quando/main.dart';
import 'package:quando/register.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var credentialsInvalid = false;
  var signInLoading = false;

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
                  Column(
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
                          controller: emailController,
                          decoration: InputDecoration(
                              border: const UnderlineInputBorder(),
                              labelText: 'Email',
                              errorText: credentialsInvalid ? "Your email and password combination is invalid" : null
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 20.0),
                        child: TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Password',
                                errorText: credentialsInvalid ? "Your email and password combination is invalid" : null
                            )
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  signInLoading = true;
                                });

                                await FirebaseAuth.instance.signInWithEmailAndPassword(
                                    email: emailController.text.toLowerCase().trim(),
                                    password: passwordController.text
                                ).then((value) {
                                  setState(() {
                                    credentialsInvalid = false;
                                    signInLoading = false;
                                  });

                                  const snackBar = SnackBar(content: Text('Sign in successful!'));

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const MyHomePage(title: "quando"))
                                  );
                                }).catchError((error) {
                                  setState(() {
                                    credentialsInvalid = true;
                                    signInLoading = false;
                                  });

                                  const snackBar = SnackBar(content: Text('Looks like your email and password combination is invalid'));

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                });
                              },
                              child: const Text("SIGN IN"),
                              style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(148, 97, 171, 1.0)),
                            ),
                          )
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ForgotPassword())
                            );
                          },
                          child: const Text("Forgot your password?",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color.fromRGBO(148, 97, 171, 1.0)
                            ),
                          )
                      ),
                      TextButton(
                          onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Register())
                              );
                          },
                          child: const Text("Register",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color.fromRGBO(148, 97, 171, 1.0)
                            ),
                          )
                      ),
                      Container(
                        child: signInLoading ? const CircularProgressIndicator(
                          value: null,
                          color: Color.fromRGBO(148, 97, 171, 1.0),
                        ) : null
                      )
                    ],
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
