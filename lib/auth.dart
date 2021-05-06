import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  String uid;
Future getCurrentUser() async {
  User _user = await FirebaseAuth.instance.currentUser;

  this.uid=_user.uid;
  return _user;
  }

  }