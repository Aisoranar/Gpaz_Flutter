import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:unipaz/notifications/notificationsManager%20.dart';

class MapConductor extends StatefulWidget {
  @override
  _MapConductorState createState() => _MapConductorState();
}

class _MapConductorState extends State<MapConductor> {
  Completer<GoogleMapController> _controller = Completer();
  late LatLng _user2Location;
  late bool _locationUpdatesActive;
  late StreamSubscription<LocationData> _locationSubscription;
  late Marker _user2Marker;

  @override
  void initState() {
    super.initState();
    _locationUpdatesActive = false;
    _user2Marker = Marker(
      markerId: MarkerId('user2Marker'),
      position: LatLng(0, 0), // Posición inicial, será actualizada en tiempo real
      infoWindow: InfoWindow(title: 'Usuario 2'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), // Especificar el color verde
    );
    _getUser2Location();
  }

  Future<void> _getUser2Location() async {
    LocationData locationData = await Location().getLocation();
    setState(() {
      _user2Location = LatLng(locationData.latitude!, locationData.longitude!);
      _user2Marker = _user2Marker.copyWith(positionParam: _user2Location);
      _animateCameraToUser2(); // Animar la cámara para seguir al usuario2
    });
  }

  void _toggleLocationUpdates() {
    if (_locationUpdatesActive) {
      _locationSubscription.cancel();
      _clearUserLocation();
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
      setState(() {
        _user2Location = LatLng(locationData.latitude!, locationData.longitude!);
        _user2Marker = _user2Marker.copyWith(positionParam: _user2Location);
        _animateCameraToUser2(); // Animar la cámara para seguir al usuario2
      });

      FirebaseFirestore.instance
          .collection('ubicaciones')
          .doc('user2')
          .set({
        'latitud': locationData.latitude,
        'longitud': locationData.longitude,
      });
    });
  }

  void _clearUserLocation() {
    FirebaseFirestore.instance.collection('ubicaciones').doc('user2').delete();
    // Cuando se borra la ubicación, también debemos actualizar la ubicación del usuario2 en el mapa del usuario1
    // Por lo tanto, establecemos la ubicación del usuario2 en null
    setState(() {
      _user2Location = LatLng(0, 0);
    });
  }

  void _showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona una opción'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  _sendNotification('Estoy lleno', 'El bus está lleno.');
                  Navigator.pop(context);
                },
                child: Text('Estoy lleno'),
              ),
              ElevatedButton(
                onPressed: () {
                  _sendNotification('Tengo problemas', 'Se ha presentado un problema.');
                  Navigator.pop(context);
                },
                child: Text('Tengo problemas'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendNotification(String title, String message) {
    notificationsManager.showNotification(title, message);
  }

  void _animateCameraToUser2() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: _user2Location,
        zoom: 14.0,
      ),
    ));
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
        title: Text('Mapa del Usuario 2'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _user2Location,
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: {_user2Marker},
            myLocationEnabled: true,
            onCameraMove: (CameraPosition position) {
              // Puedes agregar lógica adicional al mover el mapa si es necesario
            },
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: _toggleLocationUpdates,
              child: Text(
                _locationUpdatesActive ? 'DESACTIVAR GPS' : 'ACTIVAR GPS',
                style: TextStyle(
                  color: Color.fromARGB(247, 0, 51, 122),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: _showOptionsDialog,
          child: Text('Opciones'),
        ),
      ],
    );
  }
}
