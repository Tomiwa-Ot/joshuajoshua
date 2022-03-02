import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joshua_joshua/screens/homepage.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String email, password;

  Future login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      SharedPreferences authStatus = await SharedPreferences.getInstance();
      authStatus.setBool("isLoggedIn", true);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        Homepage()), (route) => false);
    } catch(e) {
      switch(e.message){
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
          // showSnackBar("Incorrect Username/Password");
          break;
        case "The password is invalid or the user does not have a password.":
          // showSnackBar("Incorrect Username/Password");
          break;
        default:
          // showSnackBar("Something went wrong");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}