import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoacationScreen extends StatefulWidget {
  const LoacationScreen({super.key});

  @override
  State<LoacationScreen> createState() => _LoacationScreenState();
}

class _LoacationScreenState extends State<LoacationScreen> {

late Position currentPosition;

late SharedPreferences prefs;
 String currentPlace = '';


 @override
  void initState() {
    super.initState();

    _initSharedPreferences();
    _getLocation();
    //_requestLocationPermission();
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }


// Future<void> _requestLocationPermission() async {
//     var status = await Permission.location.request();
//     if (status == PermissionStatus.granted) {
//       _getLocation();
//     } else {
//       // Handle the case where the user denied or didn't grant location permission
//       print('Location permission denied');
//     }
//   }





 Future<void> _getLocation() async {
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _updateLocation(position);
    _updatePlaceName(position);

     Timer.periodic(Duration(seconds: 10), (timer) async {
      var newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _updateLocation(newPosition);
      _updatePlaceName(newPosition);

       _storeLocationInPrefs(newPosition);
    });
  }
   void _updateLocation(Position location) {
    setState(() {
      currentPosition = location;
    });
  }


  Future<void> _updatePlaceName(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          currentPlace = '${placemark.name}, ${placemark.locality}, ${placemark.country}';
        });
      } else {
        setState(() {
          currentPlace = 'Place name not available';
        });
      }
    } catch (e) {
      print('Error retrieving place name: $e');
      setState(() {
        currentPlace = 'Error retrieving place name';
      });
    }
  }


 void _storeLocationInPrefs(Position location) {
    prefs.setDouble('latitude', location.latitude);
    prefs.setDouble('longitude', location.longitude);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Latitude: ${currentPosition?.latitude??0}',style: TextStyle(fontSize: 20),),
            Text('Longitude: ${currentPosition?.longitude??0}',style: TextStyle(fontSize: 20)),
            Text('Place Name: $currentPlace',style: TextStyle(fontSize: 15,color: Colors.red)),
          ],
        ),
      ),
    );
  }
  }
