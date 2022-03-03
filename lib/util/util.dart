import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const String GOOGLE_MAPS_API_KEY = "AIzaSyAskh4n6UiJ8WEOGq8G68fAqo_OJ4KiO1c";
const double CAMERA_ZOOM = 14.0;
const LatLng defaultLatLng = LatLng(6.5244, 3.3792);


String nameValidator(String value){
  Pattern pattern =
      r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return '*Enter a valid name';
  else
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
