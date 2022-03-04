import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const String GOOGLE_MAPS_API_KEY = "AIzaSyBNnzq0CRkSPs10L-I3o1Zxjux8_OAyFhM";
const double CAMERA_ZOOM = 17.0;
const LatLng defaultLatLng = LatLng(6.5244, 3.3792);
const String PAYSTACK_PUBKEY = "";


String nameValidator(String value){
  Pattern pattern =
      r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return '*Enter a valid name';
  else
    return null;
}

String phoneValidator(String value){
  Pattern pattern = r'(^(?:[+0]9)?[0-9]{11,13}$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return '*Enter mobile number';
  }
  else if (!regExp.hasMatch(value)) {
    return '*Enter valid mobile number';
  }
  return null;
}


String emailValidator(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty) return '*Required';
  if (!regex.hasMatch(value))
    return '*Enter a valid email';
  else
    return null;
}


String pwdValidator(String value) {
  if (value.isEmpty) {
    return '*Password cannot be empty';
  } else if(value.length < 8){
    return '*Password must 8 characters or more';
  }else {
    return null;
  }
}


void showSnackBar(String value, BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    backgroundColor: Colors.red,
    duration: Duration(seconds: 4),
    elevation: 5.0,
    content: Text(value,
    textAlign: TextAlign.left,
      style: TextStyle(
        color: Colors.white
      ),
    ),
  ));
}
