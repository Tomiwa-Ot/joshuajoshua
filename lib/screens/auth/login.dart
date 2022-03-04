import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joshua_joshua/screens/homepage.dart';
import 'package:joshua_joshua/util/util.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  String email, password;
  bool _obscureText = true, _loading = false;

  Future login(String email, String password) async {
    setState(() {
      _loading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      SharedPreferences authStatus = await SharedPreferences.getInstance();
      authStatus.setBool("isLoggedIn", true);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        Homepage()), (route) => false);
    } catch(e) {
      setState(() {
        _loading = false;
      });
      switch(e.message){
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
          showSnackBar("Incorrect Username/Password", context);
          break;
        case "The password is invalid or the user does not have a password.":
          showSnackBar("Incorrect Username/Password", context);
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
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                color: Colors.black
              ),
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
                            color:  Colors.black,
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
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          login(email, password);
                        }
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
                        ) : Text("Login",
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