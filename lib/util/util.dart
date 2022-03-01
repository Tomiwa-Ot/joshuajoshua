const String GOOGLE_MAPS_API_KEY = "";
const double CAMERA_ZOOM = 14.0;

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
