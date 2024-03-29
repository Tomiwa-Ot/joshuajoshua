import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:joshua_joshua/screens/shop/checkout.dart';

const String GOOGLE_MAPS_API_KEY = "AIzaSyBNnzq0CRkSPs10L-I3o1Zxjux8_OAyFhM";
const double CAMERA_ZOOM = 17.0;
const LatLng defaultLatLng = LatLng(6.5244, 3.3792);
const String PAYSTACK_PUBKEY = "";
List<Map<String, dynamic>> cart = [];


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
    backgroundColor: Color.fromARGB(255, 199, 75, 66),
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


void showCartModal(
  BuildContext context, List<Map<String, dynamic>> cart, void Function(int) removeItem, void Function(int, int) modifyQuantity, void Function(BuildContext) navigate) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return cart.length != 0 ? Container(
        margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Column(
          children: [
            ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey,),
                    onPressed: () {
                      removeItem(index);
                    },
                  ),
                );
              },
            ),
            // checkout button total cost and everybady
          ],
        )
      ) : Container(
        margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Cart is empty")
          ],
        ),
      );
    }
  );
}

void gotoCheckOutPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) =>
    Checkout()
  )); 
}

