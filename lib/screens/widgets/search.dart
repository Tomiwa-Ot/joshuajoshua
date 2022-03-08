import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Search extends StatefulWidget {

  Search({this.callback});

  final void Function(bool, bool, bool, int) callback;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 60.0,
          color: Colors.grey.withOpacity(0.3),
          margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: TextField(
            cursorColor: Colors.black,
            onChanged: (val) {
              
            },
            textInputAction: TextInputAction.go,
            decoration: InputDecoration(
              icon: Container(
                margin: EdgeInsets.only(left: 20.0, bottom: 15.0),
                width: 10.0,
                height: 10.0,
                child: Icon(CupertinoIcons.search, color: Colors.black,),
              ),
              hintText: "Search",
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 15.0, top: 14.0)
            ),
          ),
        )
      ],
    );
  }
}