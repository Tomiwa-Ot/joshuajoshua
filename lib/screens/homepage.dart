import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joshua_joshua/screens/shop/shop.dart';
import 'package:joshua_joshua/screens/wallet.dart';
import 'package:joshua_joshua/screens/widgets/ongoing.dart';
import 'package:joshua_joshua/screens/widgets/progress.dart';
import 'package:joshua_joshua/util/util.dart';
import 'package:joshua_joshua/screens/auth.dart';
import 'package:joshua_joshua/screens/widgets/search.dart';
import 'package:joshua_joshua/screens/widgets/address.dart';
import 'package:joshua_joshua/screens/widgets/loading.dart';
import 'package:joshua_joshua/screens/widgets/barberDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class Homepage extends StatefulWidget {

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  int _index = 0;
  bool _showCurrentLocationButton = true;
  String location, email;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  User user = FirebaseAuth.instance.currentUser;
  Stream<DocumentSnapshot> stream;
  DocumentSnapshot barber;
  GoogleMapController _controller;
  LatLng latLng ;
  Marker _destination, _source;
  Map<String, Marker> _sources;
  List<Widget> draggableSheetWidgets;
  CameraPosition _cameraPosition;
  CameraPosition _initialCameraPosition = CameraPosition(
    zoom: CAMERA_ZOOM,
    target: defaultLatLng,
  );

  void initState() {
    super.initState();
    draggableSheetWidgets = [
      Search(callback: updateDraggableSheetWidget), Address(callback: updateDraggableSheetWidget),
      Loading(latLng: latLng, callback: updateDraggableSheetWidget, setSourceMarkers: setSourceMarkers,), 
      BarberDetails(callback: updateDraggableSheetWidget, barber: barber,),
      Progress(snapshot: barber, callback: updateDraggableSheetWidget,)
    ];
    stream = user != null ? FirebaseFirestore.instance.collection("users")
        .doc(user.uid).snapshots() : null;
    // possibly streansubscription to constantly show ongoing session when true
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateDraggableSheetWidget(bool isDestinationNull, bool isSourceNull, bool showCurrentLocationBtn, int index) {
    setState(() {
      if(isDestinationNull) _destination = null;
      if(isSourceNull) _source = null; _sources = null;
      _showCurrentLocationButton = showCurrentLocationBtn;
      _index = index;
    });
  }

  void updateSourceMarkerPosition(DocumentSnapshot snapshot) {
    // GeoFirePoint point = snapshot.get("position");
    setState(() {
      _source = Marker(
        markerId: MarkerId(snapshot.id),
        infoWindow: InfoWindow(title: 'Barber\'s Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        // position: LatLng(point.latitude, point.longitude)
      );
    });
  }

  void setSourceMarkers(Map<String, DocumentSnapshot> availableBarbers) {
    availableBarbers.forEach((key, value) {
      barber = value;
      // GeoFirePoint point = snapshot.get("position");
      _sources[key] = Marker(
        markerId: MarkerId(key),
        infoWindow: InfoWindow(title: 'Barber\'s Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        // position: LatLng(point.latitude, point.longitude)
        onTap: () {
          setState(() {
            _index = 3;
          });
        }
      );
    });
  }

  Future gotoCurrentLocation() async {
    if (!await Permission.location.isGranted) {
      await Permission.location.request();
      return;
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      showSnackBar("Location services are not enabled", context);
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    latLng = LatLng(position.latitude, position.longitude);
    _cameraPosition = CameraPosition(target: latLng, zoom: CAMERA_ZOOM);
    List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    setState(() {
      location = "${placemarks.first.street.toString()} ${placemarks.first.subAdministrativeArea.toString()} ${placemarks.first.postalCode.toString()} ${placemarks.first.administrativeArea.toString()}";
      _destination = Marker(
        markerId: MarkerId('destination'),
        infoWindow: InfoWindow(title: 'My Location'),
        position: latLng
      );
      _index = 1;
    });
    _controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
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

                  setState(() {
                    email = snapshot.data['fullname'];
                  });
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
                        color: Colors.white,
                        fontSize: 12.0
                      ),
                    ),
                  );
                },
              )
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    leading: Icon(CupertinoIcons.cart, color: Colors.black),
                    title: Text("Shop",
                      style: TextStyle(
                        fontSize: 17.0
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        Shop()
                      )); 
                    },
                  ),
                  ListTile(
                    leading: Icon(CupertinoIcons.money_dollar, color: Colors.black),
                    title: Text("Wallet",
                      style: TextStyle(
                        fontSize: 17.0
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        Wallet(email: email,)
                      )); 
                    },
                  ),
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
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        Auth()), (route) => false);
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
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            onTap: (LatLng _latLng) async {
              latLng = _latLng;
              _cameraPosition = CameraPosition(target: _latLng, zoom: CAMERA_ZOOM);
              List<Placemark> placemarks = await placemarkFromCoordinates(_latLng.latitude, _latLng.longitude);
              setState(() {
                location = "${placemarks.first.street.toString()} ${placemarks.first.subAdministrativeArea.toString()} ${placemarks.first.postalCode.toString()} ${placemarks.first.administrativeArea.toString()}";
                _destination = Marker(
                  markerId: MarkerId('destination'),
                  infoWindow: InfoWindow(title: 'My Location'),
                  position: _latLng
                );
                _index = 1;
              });
              _controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
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
                  borderRadius: BorderRadius.circular(27.0),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(CupertinoIcons.line_horizontal_3, color: Colors.black, size: 25.0,),
                  radius: 25.0,
                ),
              ),
              onTap: () => _scaffoldKey.currentState.openDrawer()
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.28,
            minChildSize: 0.28,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(235, 235, 235, 1),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      offset: Offset(3, 2),
                      blurRadius: 7
                    )
                  ]
                ),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: stream,
                  builder: (context, snapshot) {
                    if(snapshot.data.get("isBusy")) {
                      return Ongoing();
                    }

                    return draggableSheetWidgets[_index];
                  },
                )
              );
            },
          )
        ],
      ),
      floatingActionButton: _showCurrentLocationButton ? FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          gotoCurrentLocation();
        },
        child: Icon(CupertinoIcons.location_fill, color: Colors.white,),
      ) : Container(),
    );
  }
}