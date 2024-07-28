import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class SecondTab extends StatefulWidget {
  final String? markerId; // Accept markerId as a parameter
  final bool showBackButton; // Accept showBackButton as a parameter

  SecondTab({this.markerId, this.showBackButton = false});

  @override
  _SecondTabState createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng _user1Location = LatLng(0, 0); // Initialize with a default value
  bool _showPolyline = false;
  LocationData? _myLocationData;
  Location _location = Location();
  late StreamSubscription<LocationData> _locationSubscription;
  bool _locationUpdatesActive = false;
  late Marker _user1Marker;
  late BitmapDescriptor _user1Icon;
  late BitmapDescriptor _user2Icon;
  late BitmapDescriptor _customIcon;
  String _distance = '';
  String _duration = '';
  List<LatLng> _polylineCoordinates = [];
  Map<String, Marker> _userMarkers = {};
  bool _iconsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadCustomIcons().then((_) {
      setState(() {
        _iconsLoaded = true;
      });
      _getUser1Location();
      _subscribeToLocationUpdates();
      _requestLocationPermission();
      _subscribeToDriversLocations();
    });
  }

  Future<void> _loadCustomIcons() async {
    _user1Icon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(20, 20)),
      'Assets/icon/gpsiconuser.png',
    );

    _user2Icon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(20, 20)),
      'Assets/icon/cotsem.png',
    );

    _customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(20, 20)),
      'Assets/icon/gpsiconparada.png',
    );
  }

  Future<void> _getUser1Location() async {
    LocationData locationData = await _location.getLocation();
    setState(() {
      _user1Location = LatLng(locationData.latitude!, locationData.longitude!);
      _user1Marker = Marker(
        markerId: MarkerId('user1Marker'),
        position: _user1Location,
        icon: _user1Icon,
        infoWindow: InfoWindow(title: 'Usuario 1'),
      );
      _userMarkers['user1'] = _user1Marker;
    });
  }

  void _subscribeToLocationUpdates() {
    _locationSubscription = _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _myLocationData = currentLocation;
        if (_myLocationData != null) {
          _user1Location = LatLng(_myLocationData!.latitude!, _myLocationData!.longitude!);
          _user1Marker = Marker(
            markerId: MarkerId('user1Marker'),
            position: _user1Location,
            icon: _user1Icon,
            infoWindow: InfoWindow(title: 'Usuario 1'),
          );
          _userMarkers['user1'] = _user1Marker;
          _calculateDistancesAndTimes();
        }
      });
    });
    _locationUpdatesActive = true;
  }

  void _subscribeToDriversLocations() {
    FirebaseFirestore.instance.collection('ubicaciones').snapshots().listen((QuerySnapshot snapshot) {
      setState(() {
        for (var doc in snapshot.docs) {
          double latitud = doc['latitud'];
          double longitud = doc['longitud'];
          LatLng position = LatLng(latitud, longitud);
          String markerId = doc.id;

          _userMarkers[markerId] = Marker(
            markerId: MarkerId(markerId),
            position: position,
            icon: _user2Icon,
            infoWindow: InfoWindow(title: 'Conductor $markerId'),
          );
        }
        _calculateDistancesAndTimes();
      });
    });
  }

  void _requestLocationPermission() async {
    var status = await _location.hasPermission();
    if (status == PermissionStatus.denied) {
      await _location.requestPermission();
    }
  }

  Future<void> _calculateDistancesAndTimes() async {
    if (_userMarkers.isEmpty) return;

    final String apiKey = 'AIzaSyAyGNYpr03GhF3hWw7QSLVJtmZE4h21DZg';

    for (var marker in _userMarkers.values) {
      final String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${_user1Location.latitude},${_user1Location.longitude}&destination=${marker.position.latitude},${marker.position.longitude}&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final legs = data['routes'][0]['legs'][0];
        setState(() {
          _distance = legs['distance']['text'];
          _duration = legs['duration']['text'];
          _polylineCoordinates = _decodePolyline(data['routes'][0]['overview_polyline']['points']);
        });
      }
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    return PolylinePoints().decodePolyline(encoded)
      .map((point) => LatLng(point.latitude, point.longitude))
      .toList();
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId("parada4"),
        position: const LatLng(7.0614351, -73.8533701),
        icon: _customIcon,
        infoWindow: const InfoWindow(
          title: "Parada 4",          
          snippet: "Frente al Parque Camilo Torres",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada2"),
        position: const LatLng(7.061706, -73.8595833),
        icon: _customIcon,
        infoWindow: const InfoWindow(
          title: "Parada 2",
          snippet: "Iglesia Oración Espíritu Santo",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada3"),
        position: const LatLng(7.0612446, -73.8565249),
        icon: _customIcon,
        infoWindow: const InfoWindow(
          title: "Parada 3",
          snippet: "Yamaha Av 52",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada4"),
        position: const LatLng(7.0614351, -73.8533701),
        icon: _customIcon,
        infoWindow: const InfoWindow(
          title: "Parada 4",          
          snippet: "Frente al Parque Camilo Torres",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada5"),
        position: const LatLng(7.0599965, -73.8513638),
        icon: _customIcon,
        infoWindow: const InfoWindow(
          title: "Parada 5",
          snippet: "Cajero Servibanca de la 28",        
        ),
      ),
      Marker(
        markerId: const MarkerId("parada6"),
        position: const LatLng(7.0573063, -73.8506163),
        icon: _customIcon,
        infoWindow: const InfoWindow(
          title: "Parada 6",
          snippet: "Restaurante Pollo Arabe",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada7"),
        position: const LatLng(7.0505295, -73.8472625),
        icon: _customIcon,
        infoWindow: const InfoWindow(
          title: "Parada 7",
          snippet: "Intercambiador",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada8"),
        position: const LatLng(7.050025, -73.8405155),
        icon: _customIcon,
        infoWindow: const InfoWindow(
          title: "Parada 8",
          snippet: "Entrada Barrio Yarima",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada9"),
        position: const LatLng(7.0436381, -73.8363577),
        icon: _customIcon,
        infoWindow: const InfoWindow(
          title: "Parada 9",
          snippet: "El Palmar",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada10"),
        position: const LatLng(7.0422154, -73.83111),
        icon: _customIcon,
        infoWindow: const InfoWindow(
          title: "Parada 10",
          snippet: "Bosques de la Cira",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada11"),
        position: const LatLng(7.0421841, -73.8290742),
        icon: _customIcon,
        infoWindow: const InfoWindow(
          title: "Parada 11",
          snippet: "Frente a Bonanza - Bavaria",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada12"),
        position: const LatLng(7.0424402, -73.8268916),
        icon: _customIcon,
        infoWindow: const InfoWindow(
          title: "Parada 12",
          snippet: "El Retén",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada13"),
        position: const LatLng(7.0659946, -73.7448674),
        icon: _customIcon,
        infoWindow: const InfoWindow(
          title: "UNIPAZ Centro Investigaciones Santa Lucia",
          snippet: "Campus Universitario",
        ),
      ),
    };

    markers.addAll(_userMarkers.values);
    if (_user1Location != null) {
      markers.add(_user1Marker);
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    if (!_iconsLoaded) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Set<Marker> markers = _createMarkers();

    return Scaffold(
      appBar: widget.showBackButton
          ? AppBar(
              title: Text('Volver', style: TextStyle(color: Colors.white)),
              backgroundColor: Color.fromARGB(247, 0, 51, 122),
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          : null,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _user1Location, // Use default initialized value here
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
              if (widget.markerId != null) {
                // Center map on the specified marker if markerId is provided
                Marker? marker = _userMarkers[widget.markerId];
                if (marker != null) {
                  await controller.animateCamera(
                    CameraUpdate.newLatLng(marker.position),
                  );
                  await controller.showMarkerInfoWindow(marker.markerId);
                } else {
                  // Check default markers
                  Marker? defaultMarker = markers.firstWhere(
                    (m) => m.markerId.value == widget.markerId,
                    orElse: () => markers.first,
                  );
                  await controller.animateCamera(
                    CameraUpdate.newLatLng(defaultMarker.position),
                  );
                  await controller.showMarkerInfoWindow(defaultMarker.markerId);
                }
              }
            },
            markers: markers,
            polylines: _showPolyline && _userMarkers.isNotEmpty
                ? {
                    Polyline(
                      polylineId: PolylineId('route'),
                      points: [_user1Location, ..._userMarkers.values.map((marker) => marker.position)],
                      color: Colors.red,
                      width: 4,
                    ),
                  }
                : {},
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            ].toSet(),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (_userMarkers.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Distancia: $_distance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Duración: $_duration',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }
}
