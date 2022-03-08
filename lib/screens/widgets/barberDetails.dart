import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BarberDetails extends StatefulWidget {

  BarberDetails({this.callback, this.barber});

  final void Function(bool, bool, bool, int) callback;
  final DocumentSnapshot barber;

  @override
  _BarberDetailsState createState() => _BarberDetailsState();
}

class _BarberDetailsState extends State<BarberDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}