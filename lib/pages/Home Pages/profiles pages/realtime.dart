import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:animate_do/animate_do.dart';

class Realtime extends StatefulWidget {
  @override
  _RealtimeTrackingState createState() => _RealtimeTrackingState();
}

class _RealtimeTrackingState extends State<Realtime> with SingleTickerProviderStateMixin {
  late GoogleMapController _controller;
  final Location _location = Location();
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('delivery');
  final DatabaseReference _deliveryBoyDatabase = FirebaseDatabase.instance.ref().child('deliveryBoy');

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng _currentPosition = LatLng(19.0760, 72.8777);
  LatLng _deliveryBoyPosition = LatLng(19.0213, 72.8424);
  late StreamSubscription<LocationData> _locationSubscription;
  late StreamSubscription<DatabaseEvent> _deliveryBoySubscription;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initializeLocationAndMap();
    _listenToDeliveryBoyLocation();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
  }

  void _initializeLocationAndMap() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _locationSubscription = _location.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        LatLng newPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _updateDatabaseLocation(newPosition);
        _updateMapAndMarker(newPosition);
      }
    });
  }

  void _listenToDeliveryBoyLocation() {
    _deliveryBoySubscription = _deliveryBoyDatabase.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && data['latitude'] != null && data['longitude'] != null) {
        LatLng newPosition = LatLng(data['latitude'], data['longitude']);
        setState(() {
          _deliveryBoyPosition = newPosition;
          _updateMapAndMarker(_currentPosition);
          _updateRoute();
          _animationController.forward(from: 0.0);
        });
      }
    });
  }

  void _updateDatabaseLocation(LatLng position) {
    try {
      _database.set({
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    } catch (e) {
      print('Error updating location in Firebase: $e');
    }
  }

  void _updateMapAndMarker(LatLng position) {
    if (mounted) {
      setState(() {
        _currentPosition = position;
        _markers.clear();
        _markers.add(Marker(
          markerId: MarkerId('customer_location'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ));
        _markers.add(Marker(
          markerId: MarkerId('delivery_boy_location'),
          position: _deliveryBoyPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ));
      });
    }
  }

  void _updateRoute() {
    setState(() {
      _polylines.clear();
      _polylines.add(Polyline(
        polylineId: PolylineId('delivery_route'),
        color: Colors.orange,
        width: 6,
        points: [_deliveryBoyPosition, _currentPosition],
      ));
    });
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    _deliveryBoySubscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: FadeInDown(
          child: Text('Delivery Tracking', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ZoomIn(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red, size: 30),
                          SizedBox(width: 10),
                          Text('Current Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      Text('Lat: ${_currentPosition.latitude}, Lng: ${_currentPosition.longitude}', style: TextStyle(fontSize: 14)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.delivery_dining, color: Colors.green, size: 30),
                          SizedBox(width: 10),
                          Text('Delivery Boy Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      Text('Lat: ${_deliveryBoyPosition.latitude}, Lng: ${_deliveryBoyPosition.longitude}', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SlideInUp(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 12),
                mapType: MapType.terrain,
                onMapCreated: (controller) => _controller = controller,
                markers: _markers,
                polylines: _polylines,
                myLocationEnabled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
