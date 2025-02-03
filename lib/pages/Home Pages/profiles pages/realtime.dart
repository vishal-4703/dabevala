import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class Realtime extends StatefulWidget {
  @override
  _RealtimeTrackingState createState() => _RealtimeTrackingState();
}

class _RealtimeTrackingState extends State<Realtime> {
  late GoogleMapController _controller;
  final Location _location = Location();
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('delivery');
  final DatabaseReference _deliveryBoyDatabase = FirebaseDatabase.instance.ref().child('deliveryBoy');

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng _currentPosition = LatLng(19.0760, 72.8777); // Default: Mumbai
  LatLng _deliveryBoyPosition = LatLng(19.0213, 72.8424); // Delivery Boy Location: Dadar
  late StreamSubscription<LocationData> _locationSubscription;
  late StreamSubscription<DatabaseEvent> _deliveryBoySubscription;

  @override
  void initState() {
    super.initState();
    _initializeLocationAndMap();
    _listenToDeliveryBoyLocation();
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
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));
        _markers.add(Marker(
          markerId: MarkerId('delivery_boy_location'),
          position: _deliveryBoyPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ));
      });

      _controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
              position.latitude < _deliveryBoyPosition.latitude ? position.latitude : _deliveryBoyPosition.latitude,
              position.longitude < _deliveryBoyPosition.longitude ? position.longitude : _deliveryBoyPosition.longitude),
          northeast: LatLng(
              position.latitude > _deliveryBoyPosition.latitude ? position.latitude : _deliveryBoyPosition.latitude,
              position.longitude > _deliveryBoyPosition.longitude ? position.longitude : _deliveryBoyPosition.longitude),
        ),
        50,
      ));
    }
  }

  void _updateRoute() {
    setState(() {
      _polylines.clear();
      _polylines.add(Polyline(
        polylineId: PolylineId('delivery_route'),
        color: Colors.blue,
        width: 5,
        points: [_deliveryBoyPosition, _currentPosition],
      ));
    });
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    _deliveryBoySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Delivery Tracking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.location_on, color: Colors.red, size: 30),
                  title: Text('Current Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text('Lat: ${_currentPosition.latitude}, Lng: ${_currentPosition.longitude}', style: TextStyle(fontSize: 14)),
                ),
                ListTile(
                  leading: Icon(Icons.directions_bike, color: Colors.green, size: 30),
                  title: Text('Delivery Boy Location (Dadar)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text('Lat: ${_deliveryBoyPosition.latitude}, Lng: ${_deliveryBoyPosition.longitude}', style: TextStyle(fontSize: 14)),
                ),
                SizedBox(height: 10),
                LinearProgressIndicator(value: 0.7, color: Colors.orange, backgroundColor: Colors.grey[300]),
                SizedBox(height: 10),
                Text('Estimated Arrival: 10-15 min', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 12),
                mapType: MapType.normal,
                onMapCreated: (controller) => _controller = controller,
                markers: _markers,
                polylines: _polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                compassEnabled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
