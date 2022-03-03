import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:joshua_joshua/screens/homepage.dart';
import 'package:joshua_joshua/screens/auth.dart';

void main() {
  runApp(Init());
}

class Init extends StatefulWidget {

  @override
  _InitState createState() => _InitState();
}

class _InitState extends State<Init> {

  bool _isLoggedIn = false;

  Future<FirebaseApp> initializeFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  Future checkAuthStatus() async {
    SharedPreferences authStatus = await SharedPreferences.getInstance();
    if (authStatus.getBool("isLoggedIn") != null) {
      setState(() {
        _isLoggedIn = authStatus.getBool("isLoggedIn");
      });
    }
  }

  void initState() {
    super.initState();
    initializeFirebase();
    checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.grey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: _isLoggedIn ? Homepage() : Auth(),
        color: Colors.black
      ),
    );
  }
}


