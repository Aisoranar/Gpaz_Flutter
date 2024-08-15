import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SecondTab extends StatefulWidget {
  final String? markerId; // Nuevo parámetro para el ID del marcador
  final bool showBackButton; // Parámetro para mostrar el botón de regreso

  const SecondTab({super.key, this.markerId, this.showBackButton = false});

  @override
  _SecondTabState createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  late BitmapDescriptor _customIcon;
  late BitmapDescriptor _user1Icon;
  late BitmapDescriptor _user2Icon;

  bool _iconsLoaded = false;
  final Location _location = Location();
  LatLng? _userLocation;
  Set<Marker> _userMarkers = {};
  String _distance = '';
  String _duration = '';
  String _nextStop = '';
  Set<Polyline> _polylines = {};

  static const LatLng _initialPosition = LatLng(7.0653, -73.8543);

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
    _listenToDriversLocations();
    _loadLastMapPosition();
    _getUserLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Centrar el mapa en el marcador si markerId está presente
    if (widget.markerId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final marker = _markers.firstWhere(
          (m) => m.markerId.value == widget.markerId,
          orElse: () =>
              const Marker(markerId: MarkerId('dummy'), position: LatLng(0, 0)),
        );
        if (marker.markerId.value != 'dummy') {
          _mapController.animateCamera(
            CameraUpdate.newLatLngZoom(marker.position, 16), // Centrar y hacer zoom en el marcador
          );
          // Seleccionar el marcador para mostrar el InfoWindow
          _mapController.showMarkerInfoWindow(marker.markerId);
        }
      });
    }
  }

  Future<void> _loadCustomIcons() async {
    _user1Icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)),
      'Assets/icon/gpsiconuser.png',
    );

    _user2Icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)),
      'Assets/icon/cotsem.png',
    );

    _customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)),
      'Assets/icon/gpsiconparada.png',
    );
    setState(() {
      _iconsLoaded = true;
    });
  }

  Future<void> _loadLastMapPosition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('last_latitude_second_tab');
    double? longitude = prefs.getDouble('last_longitude_second_tab');
    if (latitude != null && longitude != null) {
      _mapController
          .animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
    } else {
      // Centrar en la posición inicial si no hay posición guardada
      _mapController.animateCamera(CameraUpdate.newLatLng(_initialPosition));
    }
  }

  void _saveLastMapPosition(LatLng position) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('last_latitude_second_tab', position.latitude);
    await prefs.setDouble('last_longitude_second_tab', position.longitude);
  }

  Future<void> _getUserLocation() async {
    var userLocation = await _location.getLocation();
    setState(() {
      _userLocation = LatLng(userLocation.latitude!, userLocation.longitude!);
      _userMarkers = {
        Marker(
          markerId: const MarkerId('user_location'),
          position: _userLocation!,
          icon: _user1Icon,
          infoWindow: const InfoWindow(
            title: 'Tu Ubicación',
          ),
        ),
      };
    });
    _mapController.animateCamera(CameraUpdate.newLatLng(_userLocation!));
    _calculateDistancesAndTimes();
  }

  Future<void> _calculateDistancesAndTimes() async {
    if (_userLocation == null) return;

    const String apiKey = 'AIzaSyAyGNYpr03GhF3hWw7QSLVJtmZE4h21DZg';
    Set<Polyline> newPolylines = {};
    String nextStopDistance = '';
    String nextStopDuration = '';
    String nextStopName = '';

    for (var marker in _markers) {
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${_userLocation!.latitude},${_userLocation!.longitude}&destination=${marker.position.latitude},${marker.position.longitude}&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final legs = data['routes'][0]['legs'][0];
        final List<LatLng> polylineCoordinates =
            _decodePolyline(data['routes'][0]['overview_polyline']['points']);

        if (nextStopDistance == '') {
          nextStopDistance = legs['distance']['text'];
          nextStopDuration = legs['duration']['text'];
          nextStopName = marker.infoWindow.title!;
        }

        newPolylines.add(
          Polyline(
            polylineId: PolylineId('route_to_${marker.markerId.value}'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 4,
          ),
        );
      }
    }

    setState(() {
      _polylines = newPolylines;
      _distance = nextStopDistance;
      _duration = nextStopDuration;
      _nextStop = nextStopName;
    });
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;
      LatLng point = LatLng(
        (lat / 1E5).toDouble(),
        (lng / 1E5).toDouble(),
      );
      polyline.add(point);
    }

    return polyline;
  }

  void _listenToDriversLocations() {
    _firestore
        .collection('driver_locations')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      _updateMarkers(snapshot.docs);
    });
  }

  void _updateMarkers(List<QueryDocumentSnapshot> documents) {
    Set<Marker> newMarkers = documents.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final String plate = data['plate'] ?? 'Placa no disponible';
      final LatLng position = LatLng(data['latitude'], data['longitude']);
      final String message = data['message'] ?? 'Sin mensaje';

      return Marker(
        markerId: MarkerId(doc.id),
        position: position,
        infoWindow: InfoWindow(
          title: 'Cotsem [$plate]',
          snippet: message,
        ),
        icon: _user2Icon,
      );
    }).toSet();

    newMarkers.addAll(_createMarkers()); // Agregar los puntos de parada

    setState(() {
      _markers = newMarkers;
    });
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId("parada1"),
        position: const LatLng(7.0619238, -73.8648762),
        icon: _customIcon,
        infoWindow: const InfoWindow(
          title: "Parada 1",
          snippet: "Frente a la Bomba San Silvestre Av. 52",
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
    return markers;
  }

@override
Widget build(BuildContext context) {
  // ignore: deprecated_member_use
  return WillPopScope(
    onWillPop: () async {
      // Show a dialog or any other action to prevent changing the tab
      return false; // Prevent the pop action
    },
    child: Scaffold(
      body: Stack(
        children: [
          _iconsLoaded
              ? GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: const CameraPosition(
                    target: _initialPosition,
                    zoom: 14,
                  ),
                  markers: _markers.union(_userMarkers),
                  polylines: _polylines,
                  onCameraMove: (position) {
                    _saveLastMapPosition(position.target);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
                    ..add(
                      Factory<PanGestureRecognizer>(
                        () => PanGestureRecognizer(),
                      ),
                    ),
                )
              : const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 520,
            left: 10,
            right: 70,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distancia a la siguiente parada: $_distance',
                    style: const TextStyle(
                      backgroundColor: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tiempo estimado: $_duration',
                    style: const TextStyle(
                      backgroundColor: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Conductor Cercano: $_nextStop',
                    style: const TextStyle(
                      backgroundColor: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
      )],
        ),
      ),
    );
  }
}
