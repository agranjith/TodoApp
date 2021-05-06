import 'package:flutter/material.dart';
import 'package:todo/login.dart';
import 'package:todo/register.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(
                    text: "Todo",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    children: [
                      TextSpan(
                        text: "App",
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.black,
                        )
                      )
                    ]
                  ),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed:(){
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage()),
                              (_) => false);
                    },
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 10,),
                  RaisedButton(
                    onPressed:(){
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                              (_) => false);
                    },
                    child: Text(
                      "REGISTER",
                      style: TextStyle(
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
