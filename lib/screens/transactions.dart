import 'package:flutter/material.dart';
import 'package:joshua_joshua/screens/receipt.dart';

class Transactions extends StatefulWidget {

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
              Receipt()
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