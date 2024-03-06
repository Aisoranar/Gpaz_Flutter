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
    _user1Marker = Marker(
      markerId: MarkerId('user1Marker'),
      position: _user1Location,
      infoWindow: InfoWindow(title: 'Usuario 1'),
    );
  }

  Future<void> _getUser1Location() async {
    _user1Location = LatLng(7.0689, -73.8517);
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

          // Actualizar posición del marcador del usuario 1
          _user1Marker = _user1Marker.copyWith(positionParam: _user1Location);
        });
      }
    });
  }

  void _requestLocationPermission() async {
    var status = await _location.hasPermission();
    if (status == PermissionStatus.denied) {
      await _location.requestPermission();
    }
  }

  void _centerMap() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(_user1Location));
  }

  void _toggleLocationUpdates() {
    if (_locationUpdatesActive) {
      // Código para desactivar el GPS y borrar la ubicación del usuario
      _locationSubscription.cancel();
      _clearUserLocation();  // Nuevo método para borrar la ubicación del usuario
      notificationsManager.showNotification(
        'GPS Desactivado',
        'Se ha desactivado el GPS correctamente.',
      );
      notificationsManager.showGlobalNotification(
        'Bus Desconectado',
        'El bus ha finalizado el trayecto.',
      );
      notificationsManager.showGlobalNotification(
        'Conductor Finalizó Ruta',
        'El conductor ha finalizado la ruta.',
      );
    } else {
      _startLocationUpdates();
      notificationsManager.showNotification(
        'GPS Activado',
        'Se ha activado el GPS correctamente.',
      );
      notificationsManager.showGlobalNotification(
        'Bus Conectado',
        'El bus está en camino. ¡Prepárate!',
      );
      notificationsManager.showGlobalNotification(
        'Conductor en Camino',
        'El conductor va en camino.',
      );
    }
    setState(() {
      _locationUpdatesActive = !_locationUpdatesActive;
    });
  }

  void _startLocationUpdates() {
    _locationSubscription =
        Location().onLocationChanged.listen((LocationData locationData) {
      FirebaseFirestore.instance
          .collection('ubicaciones')
          .doc('user1')  // Cambia 'user1' al identificador correcto
          .set({
        'latitud': locationData.latitude,
        'longitud': locationData.longitude,
      });
    });
  }

  // Nuevo método para borrar la ubicación del usuario
  void _clearUserLocation() {
    FirebaseFirestore.instance
        .collection('ubicaciones')
        .doc('user1')  // Cambia 'user1' al identificador correcto
        .delete();
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
          ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
          ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
          ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
          ..add(Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer())),
      ),
    );
  }
}
