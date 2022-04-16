import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black54),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.only(left:35, right:35),
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
                            "Password Reset",
                            style: TextStyle(
                                color: Color.fromRGBO(148, 97, 171, 1.0),
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                            ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 20),
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
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                    if(_formKey.currentState!.validate()) {
                                      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text).then((value){
                                        const snackBar = SnackBar(content: Text('Check your inbox for your password reset email!'));
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        Navigator.pop(context);
                                      }).catchError((error) {
                                        const snackBar = SnackBar(content: Text('Looks like something went wrong with sending your password reset email.'));
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      });
                                    }
                                },
                                child: const Text("SEND EMAIL"),
                                style: ElevatedButton.styleFrom(primary: Colors.teal),
                              ),
                            )
                          ],
                        ),
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
