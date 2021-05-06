import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:todo/register.dart';
import 'package:todo/todo_list.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null
        ? TodoList(uid: FirebaseAuth.instance.currentUser.uid)
        : Scaffold(
          appBar: AppBar(
            title: Text("Login"),
          ),
          body: Center(
            child: Container(
                padding: const EdgeInsets.all(40.0),
                child: SingleChildScrollView(
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Email*', hintText: "john.doe@gmail.com",prefixIcon: Icon(Icons.email)),

                            controller: emailInputController,
                            keyboardType: TextInputType.emailAddress,
                            validator: emailValidator,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Password*', hintText: "********",prefixIcon: Icon(Icons.lock),),
                            controller: pwdInputController,
                            obscureText: true,
                            validator: pwdValidator,
                          ),
                          RaisedButton(
                            child: Text("Login"),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              if (_loginFormKey.currentState.validate()) {
                                FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                    email: emailInputController.text,
                                    password: pwdInputController.text)
                                    .then((currentUser) => FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(currentUser.user.uid)
                                    .get()
                                    .then((DocumentSnapshot result) =>
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TodoList(
                                              uid: currentUser.user.uid,
                                            )),
                                            (_) => false))
                                    .catchError((err) => print(err)))
                                    .catchError((err) => print(err));
                              }else{

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text("Wrong Password"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("Close"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              }
                            },
                          ),
                          Text("Don't have an account yet?"),
                          FlatButton(
                            child: Text("Register here!"),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()),
                                      (_) => false);
                            },
                          )
                        ],
                      ),
                    ))),
          ));
  }
}