import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Address extends StatefulWidget {

  Address({this.callback, this.location});

  final void Function(bool, bool, bool, int) callback;
  final String location;

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Container(
            margin: EdgeInsets.only(left: 30.0),
            child: Text(widget.location,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 18.0
              ),
            ),
          ),
          trailing: IconButton(
            icon: Icon(CupertinoIcons.clear),
            color: Colors.black,
            onPressed: () => widget.callback(true, true, true, 0),
          ),
        ),
        ListTile(
          title: Container(
            height: 50.0,
            margin: EdgeInsets.only(left: 30.0, right: 30.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black
            ),
            child: Text("Proceed",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 22.0
              ),
            ),
          ),
          onTap: () {

          },
        )
      ],
    );
  }
}