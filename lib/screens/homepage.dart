import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joshua_joshua/util/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Homepage extends StatefulWidget {

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  User user = FirebaseAuth.instance.currentUser;
  Stream<DocumentSnapshot> stream;
  GoogleMapController _controller;
  Marker _destination, _source;
  CameraPosition _cameraPosition;
  CameraPosition _initialCameraPosition = CameraPosition(
    zoom: CAMERA_ZOOM,
    target: defaultLatLng
  );

  void initState() {
    super.initState();
    stream = user != null ? FirebaseFirestore.instance.collection("users")
        .doc(user.uid).snapshots() : null;
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future gotoCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      showSnackBar("Location permissions are denied", context);
      return;
    }

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      showSnackBar("Location permissions are denied, we cannot request permissions", context);
      return;
    }
    
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    LatLng latLng = LatLng(position.latitude, position.longitude);
    _cameraPosition = CameraPosition(target: latLng, zoom: CAMERA_ZOOM);
    _controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
    _destination = Marker(
      markerId: MarkerId('destination'),
      infoWindow: InfoWindow(title: 'My Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: latLng
    );
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
           return Column(
             children: [
               Padding(
                 padding: EdgeInsets.all(8.0),
                 child: Row(
                   children: [
                     Expanded(
                       child: Container(),
                     ),
                     IconButton(
                       icon: Icon(CupertinoIcons.clear, color: Colors.black,),
                       onPressed: () {
                         Navigator.of(context).pop();
                       },
                     )
                   ],
                 ),
               ),
               SizedBox(
                 width: 20.0,
               ),
               Container(
                 decoration: BoxDecoration(
                   color: Colors.black,
                   borderRadius: BorderRadius.circular(30.0)
                 ),
                 alignment: Alignment.center,
                 width: 400.0,
                 height: 55.0,
                 child: ElevatedButton(
                   child: Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Icon(CupertinoIcons.search, color: Colors.white,),
                       SizedBox(
                         width: 5.0,
                       ),
                       Text("Proceed",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800
                        ),
                       )
                     ],
                   )
                 ),
               )
             ],
           );
          },
        );
      }
    );
  }

  Future searchForNearbyBarbers() async {

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black
              ),
              child: StreamBuilder<DocumentSnapshot>(
                stream: stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListTile(
                      leading: Shimmer.fromColors(
                        child: CircleAvatar(
                          radius: 25.0,
                        ),
                        baseColor: Colors.grey[100], 
                        highlightColor: Colors.grey[300]
                      ),
                      title: Shimmer.fromColors(
                        child: Container(
                          height: 15.0,
                          color: Colors.white,
                        ),
                        baseColor: Colors.grey[100],
                        highlightColor: Colors.grey[300],
                      ),
                      subtitle: Shimmer.fromColors(
                        child: Container(
                          height: 15.0,
                          color: Colors.white,
                        ),
                        baseColor: Colors.grey[100],
                        highlightColor: Colors.grey[300],
                      ),
                    );
                  }

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.white,
                      child: Text(snapshot.data['fullname'].toString().split(" ")[1][0],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40.0
                        )
                      )
                    ),
                    title: Text(snapshot.data['fullname'],
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    subtitle: Text(snapshot.data['email'],
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  );
                },
              )
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(Icons.settings_outlined, color: Colors.black),
                    title: Text("Settings",
                      style: TextStyle(
                        fontSize: 17.0
                      ),
                    ),
                    onTap: (){
                    },
                  )
                ],
              )
            ),
            Container(
              child: Column(
                children: [
                  Divider(),
                  ListTile(
                    leading: Icon(CupertinoIcons.square_arrow_right, color: Colors.black,),
                    title: Text("Logout",
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    onTap: () async {
                      SharedPreferences authStatus = await SharedPreferences.getInstance();
                      authStatus.setBool("isLoggedIn", false);
                      await FirebaseAuth.instance.signOut();
                      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      //   Auth()), (route) => false);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            markers: {
              if (_destination != null) _destination,
              if (_source != null) _source
            },
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          ),
          Positioned(
            top: 45.0,
            left: 22.0,
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(CupertinoIcons.line_horizontal_3, color: Colors.black,),
                  radius: 20.0,
                ),
              ),
              onTap: () => _scaffoldKey.currentState.openDrawer(),
            ),
          ),
          // cancel search & current location button
          Positioned(
            top: 45.0,
            left: 37.0,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: Colors.white,
              ),
              child: TextField(
                cursorColor: Colors.black,
                // onChanged: ,
                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: 20.0, top: 5.0),
                    width: 10.0,
                    height: 10.0,
                    child: Icon(CupertinoIcons.search, color: Colors.black,),
                  ),
                  hintText: "Search",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 16.0)
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () => gotoCurrentLocation,
        child: Icon(CupertinoIcons.location_fill, color: Colors.white,),
      ),
    );
  }
}