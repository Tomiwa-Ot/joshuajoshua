import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:JoshuaJoshua/screens/homepage.dart';

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String lastname, firstname, phone, email, password;

  Future register(String lastname, String firstname, String email, String phone, String password) async {
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      UserCredential createdUser = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (createdUser != null) {
        FirebaseFirestore.instance.collection("users").doc(createdUser.user.uid).set({
          "id" : createdUser.user.uid,
          "fullname" : "$lastname $firstname",
          "email" : email,
          "phone" : phone,
          "photo" : "",
        });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          Homepage()), (route) => false);
      }
    } catch(e) {
      switch(e.message){
        case "The email address is already in use by another account.":
          // showSnackBar("Email is registered to another account");
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