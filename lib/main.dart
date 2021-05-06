 import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/auth.dart';
import 'package:todo/login.dart';
import 'package:todo/start.dart';
import 'package:todo/todo_list.dart';
import 'package:todo/loading.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Scaffold(
              body:Center(
                child:Text(snapshot.error.toString()),
              )
            );
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Loading();
          }
          return MaterialApp(
              debugShowCheckedModeBanner: false,
            // home:  Auth().getCurrentUser() == null
            //     ? TodoList(uid: Auth().uid)
            //     : Start(),
              home:FirebaseAuth.instance.currentUser != null ? TodoList(uid: FirebaseAuth.instance.currentUser.uid):Start(),
            theme: ThemeData(
              primarySwatch: Colors.amber,)
          );
        }

      ),
    );
    return CircularProgressIndicator();
  }
}
