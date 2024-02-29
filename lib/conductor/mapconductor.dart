import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MapConductorPage extends StatefulWidget {
  final String userId;
  final String nombre;
  final String placa;

  MapConductorPage({
    required this.userId,
    required this.nombre,
    required this.placa,
  });

  @override
  _MapConductorPageState createState() => _MapConductorPageState();
}

class _MapConductorPageState extends State<MapConductorPage> {
  late GoogleMapController mapController;
  List<LatLng> ruta = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa del Conductor'),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 'cerrar_sesion') {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/home_page');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'cerrar_sesion',
                  child: Text('Cerrar Sesión'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(7.0652, -73.8545),
              zoom: 15.0,
            ),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
            ].toSet(),
            markers: _createMarkers(),
            polylines: _createPolylines(),
          ),
          Positioned(
            bottom: 130.0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para activar el GPS
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(247, 0, 51, 122),
                  minimumSize: Size(80, 50),
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  foregroundColor: Colors.white,
                ),
                child: Text('Activar GPS', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
          Positioned(
            top: 20.0,
            left: 10.0,
            right: 10.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Bienvenido: ${widget.nombre} Con placa: ${widget.placa}',
                  style: TextStyle(fontSize: 18, color: const Color.fromARGB(247, 0, 51, 122)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return Set<Marker>.from(
      [
        // ... (tus marcadores)
      ],
    );
  }

  Set<Polyline> _createPolylines() {
    Set<Polyline> polylines = Set();
    polylines.add(Polyline(
      polylineId: PolylineId('ruta'),
      color: Colors.blue,
      points: ruta,
    ));
    return polylines;
  }
}
