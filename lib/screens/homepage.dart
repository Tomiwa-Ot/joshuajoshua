import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:JoshuaJoshua/util/util.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class Homepage extends StatefulWidget {

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _cameraPosition;
  CameraPosition _initialCameraPosition = CameraPosition(
    zoom: CAMERA_ZOOM,
    target: 
  );

  void initState() {
    super.initState();
  }

  Future gotoCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Location permissions are denied
    }

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      // return Future.error(
      //   'Location permissions are denied, we cannot request permissions.');
    }
    
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    LatLng latLng = LatLng(position.latitude, position.longitude);
    _cameraPosition = CameraPosition(target: latLng, zoom: CAMERA_ZOOM);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: ListView(

              ),
            ),
            Expanded(
              child: ListView(

              ),
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
                    onTap: () {

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
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
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