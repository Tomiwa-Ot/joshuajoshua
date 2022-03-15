import 'package:flutter/material.dart';
import 'package:joshua_joshua/screens/receipt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions extends StatefulWidget {

  Transactions({this.snapshot});

  final DocumentSnapshot snapshot;

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
              Receipt(snapshot: widget.snapshot)
            )); 
          },
        ),
        Divider(
          height: 1.0,
        )
      ],
    );
  }
}