import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:unipaz/notifications/notificationsManager%20.dart';

class SecondTab extends StatefulWidget {
  @override
  _SecondTabState createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> {
  Completer<GoogleMapController> _controller = Completer();
  late LatLng _user1Location;
  LatLng? _user2Location;
  bool _showPolyline = false;
  LocationData? _myLocationData;
  Location _location = Location();
  late StreamSubscription<LocationData> _locationSubscription;
  bool _locationUpdatesActive = false;
  late Marker _user1Marker; // Agrega una variable para el marcador del usuario 1

  @override
  void initState() {
    super.initState();
    _getUser1Location();
    _subscribeToLocationUpdates();
    _requestLocationPermission();
  }

  Future<void> _getUser1Location() async {
    LocationData locationData = await _location.getLocation();
    setState(() {
      _user1Location = LatLng(locationData.latitude!, locationData.longitude!);
      _user1Marker = Marker(
        markerId: MarkerId('user1Marker'),
        position: _user1Location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Icono azul para el usuario 1
        infoWindow: InfoWindow(title: 'Usuario 1'),
      );
    });
  }

  void _subscribeToLocationUpdates() {
    FirebaseFirestore.instance
        .collection('ubicaciones')
        .doc('user2')
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        double? latitud = documentSnapshot['latitud'];
        double? longitud = documentSnapshot['longitud'];

        setState(() {
          if (latitud != null && longitud != null) {
            _user2Location = LatLng(latitud, longitud);
            _showPolyline = true;

            // Mostrar notificación cuando se actualiza la ubicación en SecondTab
            notificationsManager.showNotification(
              'Conductor en Camino',
              'El conductor va en camino.',
            );

            // Mostrar notificación global cuando se selecciona una opción
            notificationsManager.showGlobalNotification(
              'Notificación Global',
              'Opción seleccionada por el conductor.',
            );
          } else {
            _user2Location = null;
            _showPolyline = false;

            // Mostrar notificación cuando el bus finaliza la ruta en SecondTab
            notificationsManager.showNotification(
              'Conductor Finalizó Ruta',
              'El conductor ha finalizado la ruta.',
            );

            // Mostrar notificación global cuando se selecciona otra opción
            notificationsManager.showGlobalNotification(
              'Notificación Global',
              'Otra opción seleccionada por el conductor.',
            );
          }
        });
      }
    });

    // Suscribirse a las actualizaciones de ubicación del usuario 1
    _locationSubscription = _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _myLocationData = currentLocation;
        if (_myLocationData != null) {
          _user1Location = LatLng(_myLocationData!.latitude!, _myLocationData!.longitude!);
          _user1Marker = Marker(
            markerId: MarkerId('user1Marker'),
            position: _user1Location,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Icono azul para el usuario 1
            infoWindow: InfoWindow(title: 'Usuario 1'),
          );
        }
      });
    });
    _locationUpdatesActive = true;
  }

  void _requestLocationPermission() async {
    var status = await _location.hasPermission();
    if (status == PermissionStatus.denied) {
      await _location.requestPermission();
    }
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa del Usuario 1'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _user1Location,
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          _user1Marker, // Usar el marcador actualizado del usuario 1
          if (_user2Location != null)
            Marker(
              markerId: MarkerId('user2Marker'),
              position: _user2Location!,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), // Icono verde para el usuario 2
              infoWindow: InfoWindow(title: 'Usuario 2'),
            ),
          if (_myLocationData != null)
            Marker(
              markerId: MarkerId('myLocationMarker'),
              position: LatLng(
                _myLocationData!.latitude!,
                _myLocationData!.longitude!,
              ),
              infoWindow: InfoWindow(title: 'Mi Ubicación'),
            ),
        },
        myLocationEnabled: true,
        onCameraMove: (CameraPosition position) {
          // Puedes agregar lógica adicional al mover el mapa si es necesario
        },
        gestureRecognizers: Set()
          ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
          ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
          ..add(Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer())),
      ),
    );
  }
}
