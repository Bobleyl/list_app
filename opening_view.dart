import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:list_app/custom_alert_dialog.dart';
import 'package:list_app/list_view.dart';

class OpeningView extends StatefulWidget {
  OpeningView({Key key}) : super(key: key);

  @override
  _OpeningViewState createState() => _OpeningViewState();
}

class _OpeningViewState extends State<OpeningView> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    void showReset() {
      TextEditingController _emailField = new TextEditingController();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlertDialog(
              content: Container(
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 5,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailField,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        hintText: "example@gmail.com",
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.white,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width / 1.5,
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await Firebase.initializeApp();
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(email: _emailField.text);
                        },
                        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                        child: Text(
                          'Reset',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }

    final email = TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        hintText: "example@gmail.com",
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        labelText: "Email",
        labelStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );

    final passwordRow = Column(
      children: [
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          style: TextStyle(
            color: Colors.white,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            hintText: "password",
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            labelText: "Password",
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(2.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MaterialButton(
              onPressed: () {
                showReset();
              },
              child: Text(
                "Forgot Password",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    final login = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 1.2,
        onPressed: () async {
          await Firebase.initializeApp();
          UserCredential user =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppListView()),
          );
        },
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final register = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 1.2,
        onPressed: () async {
          await Firebase.initializeApp();
          UserCredential user =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
          CollectionReference users =
              FirebaseFirestore.instance.collection('Users');
          users
              .doc(FirebaseAuth.instance.currentUser.uid)
              .set({'Email': _emailController.text})
              .then((value) => print("User Document Added"))
              .catchError((error) => print("Failed to add user: $error"));
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppListView()),
          );
        },
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(
          'Register',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            email,
            passwordRow,
            login,
            SizedBox(height: MediaQuery.of(context).size.height / 40),
            register,
          ],
        ),
      ),
    );
  }
}
