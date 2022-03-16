import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:joshua_joshua/screens/homepage.dart';
import 'package:joshua_joshua/util/util.dart';

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();
  String lastname, firstname, phone, email, password;
  bool _obscureText = true, _checkBoxValue = false, _loading = false;

  void checkBoxState(){
    _checkBoxValue = !_checkBoxValue;
  }
  
  Future register(String lastname, String firstname, String email, String phone, String password) async {
    setState(() {
      _loading = true;
    });
    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      UserCredential createdUser = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (createdUser != null) {
        FirebaseFirestore.instance.collection("users").doc(createdUser.user.uid).set({
          "id" : createdUser.user.uid,
          "fullname" : "$lastname $firstname",
          "email" : email,
          "phone" : phone,
          "address" : "",
          "photo" : "",
          "balance" : 0.00,
          "isBusy" : false
        });
        SharedPreferences authStatus = await SharedPreferences.getInstance();
        authStatus.setBool("isLoggedIn", true);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          Homepage()), (route) => false);
      }
    } catch(e) {
      setState(() {
        _loading = false;
      });
      switch(e.message){
        case "The email address is already in use by another account.":
          showSnackBar("Email is registered to another account", context);
          break;
        default:
          showSnackBar("Something went wrong", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black
              ),
              height: MediaQuery.of(context).size.height / 10,
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      enableSuggestions: true,
                      validator: nameValidator,
                      onChanged: (value) => firstname = value,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                        labelText: "Firstname",
                        prefixIcon: Icon(
                          Icons.person_outline_outlined,
                          color: Colors.black,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: new BorderRadius.circular(35.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        )
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      enableSuggestions: true,
                      validator: nameValidator,
                      onChanged: (value) => lastname = value,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                        labelText: "Lastname",
                        prefixIcon: Icon(
                          Icons.person_outline_outlined,
                          color: Colors.black,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: new BorderRadius.circular(35.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        )
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      enableSuggestions: true,
                      validator: phoneValidator,
                      onChanged: (value) => phone = value,
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                        labelText: "Phone",
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: Colors.black,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        )
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      enableSuggestions: true,
                      validator: emailValidator,
                      onChanged: (value) => email = value,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.alternate_email_rounded,
                          color: Colors.black,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: new BorderRadius.circular(35.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        )
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      enableSuggestions: false,
                      validator: pwdValidator,
                      onChanged: (value) => password = value,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _obscureText,
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon : Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: (){
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.black,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        )
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                          value: _checkBoxValue,
                          activeColor: Colors.black,
                          onChanged: (_checkBoxValue){
                            setState(() {
                              checkBoxState();
                            });
                          },
                        ),
                        Text("Agree to our "),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Terms & Condiitions"),
                                actions: [
                                  GestureDetector(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 30.0,
                                      width: 40.0,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(2.0)
                                      ),
                                      child: Text('Ok',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              )
                            );
                          },
                          child: Text("Terms & Conditions",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap:  _checkBoxValue ? () {
                        if (_formKey.currentState.validate()) {
                          register(lastname, firstname, email, phone, password);
                        }
                      } : () {
                        showSnackBar("Agree to Terms & Conditions", context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        alignment: Alignment.center,
                        height: 60.0,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                          color: Colors.black
                        ),
                        child: _loading ? Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          ) : Text("Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 25.0
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}