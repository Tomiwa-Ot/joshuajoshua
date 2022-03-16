import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Loading extends StatefulWidget {

  Loading({this.latLng, this.callback, this.setSourceMarkers});

  final LatLng latLng;
  final void Function(bool, bool, bool, int) callback;
  final void Function(Map<String, DocumentSnapshot>) setSourceMarkers;

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  Future searchForNearbyBarbers() async {
    // GeoFirePoint point = geo.point(latitude: widget.latLng.latitude, longitude: widget.latLng.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Loading"),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: LinearProgressIndicator(),
          ),
          GestureDetector(
            onTap: () {
              widget.callback(true, true, true, 0);
            },
            child: Container(
              alignment: Alignment.center,
              child: Text("Cancel",
                style: TextStyle(
                  color: Colors.red
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}