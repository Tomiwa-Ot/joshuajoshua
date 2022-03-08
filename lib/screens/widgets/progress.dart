import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Progress extends StatefulWidget {

  Progress({this.uid, this.updateSourceMarkerPosition, this.callback});

  final String uid;
  final void Function(DocumentSnapshot) updateSourceMarkerPosition;
  final void Function(bool, bool, bool, int) callback;

  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {

  Stream<DocumentSnapshot> stream;
  // StreamSubscription streamSub;

  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance.collection("barbers")
        .doc(widget.uid).snapshots();
    // streamSub = stream.listen((event) {
    //   stream.
    // });
    // streamSub =  Streamsub for field in document and update ui accordingly
  }

  // void dispose() {
  //   super.dispose();
  //   streamSub.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(); // shimmer view
        }

        widget.updateSourceMarkerPosition(snapshot.data);
        // if distance is close send notification
        return Container();
        // trigger updateSourceMarker on document change geoppoint = position; geopoint.data['distance']
      },
    );
  }
}