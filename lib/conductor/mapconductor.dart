import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:unipaz/conductor/profileconductor.dart';

class MapConductor extends StatefulWidget {
  const MapConductor({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapConductorState createState() => _MapConductorState();
}

class _MapConductorState extends State<MapConductor> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  LatLng _currentPosition = const LatLng(0, 0); // Inicialización predeterminada
  final Location _location = Location();
  late String _driverPlate;
  bool _isTracking = false;

  late StreamSubscription<LocationData> _locationSubscription;
  late BitmapDescriptor _customIcon; // Ícono personalizado

  @override
  void initState() {
    super.initState();
    _fetchDriverPlate();
    _getCurrentLocation();
    _listenToDriverLocation();
    _loadCustomIcon(); // Cargar el ícono personalizado
  }

  Future<void> _loadCustomIcon() async {
    _customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(20, 20)), // Tamaño ajustado
      'Assets/icon/cotsem.png',
    );
  }

  Future<void> _fetchDriverPlate() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _driverPlate = userDoc['plate'] ?? 'Placa no disponible';
        });
      }
    }
  }

  void _getCurrentLocation() async {
    final LocationData locationData = await _location.getLocation();
    setState(() {
<<<<<<< HEAD
      _currentPosition = LatLng(_locationData.latitude!, _locationData.longitude!);
      _addOrUpdateMarker(_currentPosition, _driverPlate, _locationData.heading ?? 0); // Pasar la dirección de movimiento
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 14)); // Zoom inicial ajustado
=======
      _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
      _addOrUpdateMarker(_currentPosition, _driverPlate);
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 12)); // Menos zoom inicial
>>>>>>> d47a6b2d3dfe1ac3ef374d001a7a6e592b8abca9
    });
  }

  void _listenToDriverLocation() {
    FirebaseFirestore.instance.collection('driver_locations').snapshots().listen((snapshot) {
      try {
        if (snapshot.docs.isNotEmpty) {
          final newMarkers = <Marker>{};
          for (var doc in snapshot.docs) {
<<<<<<< HEAD
            final data = doc.data() as Map<String, dynamic>; // Conversión explícita
            if (data != null) {
              final LatLng position = LatLng(data['latitude'], data['longitude']);
              final String plate = data['plate'] ?? 'Placa no disponible';
              final String message = data['message'] ?? ''; // Leer el mensaje de la notificación
              final double heading = data['heading'] ?? 0; // Obtener la dirección de movimiento

              newMarkers.add(
                Marker(
                  markerId: MarkerId(doc.id),
                  position: position,
                  infoWindow: InfoWindow(
                    title: 'Placa $plate',
                    snippet: message, // Mostrar el mensaje de la notificación aquí
                  ),
                  icon: _customIcon, // Usar el ícono personalizado
                  rotation: heading, // Rotar el ícono
=======
            final data = doc.data(); // Conversión explícita
            final LatLng position = LatLng(data['latitude'], data['longitude']);
            final String plate = data['plate'] ?? 'Placa no disponible';
            final String message = data['message'] ?? ''; // Leer el mensaje de la notificación
            newMarkers.add(
              Marker(
                markerId: MarkerId(doc.id),
                position: position,
                infoWindow: InfoWindow(
                  title: 'Conductor $plate',
                  snippet: message, // Mostrar el mensaje de la notificación aquí
>>>>>>> d47a6b2d3dfe1ac3ef374d001a7a6e592b8abca9
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
              ),
            );
                    }
          setState(() {
            _markers.clear();
            _markers.addAll(newMarkers);
            // Mover el mapa al nuevo marcador con menos zoom
            if (_markers.isNotEmpty) {
              LatLngBounds bounds = LatLngBounds(
                southwest: LatLng(
                  _markers.map((m) => m.position.latitude).reduce((a, b) => a < b ? a : b),
                  _markers.map((m) => m.position.longitude).reduce((a, b) => a < b ? a : b),
                ),
                northeast: LatLng(
                  _markers.map((m) => m.position.latitude).reduce((a, b) => a > b ? a : b),
                  _markers.map((m) => m.position.longitude).reduce((a, b) => a > b ? a : b),
                ),
              );
              _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50)); // Ajuste de zoom para ver todos los marcadores
            }
          });
        }
      } catch (e) {
        print('Error al actualizar la ubicación: $e');
      }
    });
  }

  void _addOrUpdateMarker(LatLng position, String plate, double heading) {
    final marker = Marker(
      markerId: const MarkerId('current_location'),
      position: position,
      infoWindow: InfoWindow(
        title: 'Placa $plate',
        snippet: 'Ubicación actual',
      ),
      icon: _customIcon, // Usar el ícono personalizado
      rotation: heading, // Rotar el ícono según la dirección de movimiento
    );
    setState(() {
      _markers.add(marker);
      // Mover el mapa al nuevo marcador con menos zoom
      _mapController.animateCamera(CameraUpdate.newLatLng(position));
        });
  }

  void _toggleTracking() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (_isTracking) {
        // Desactivar el seguimiento
        FirebaseFirestore.instance.collection('driver_locations').doc(user.uid).delete();
        _locationSubscription.cancel();
      } else {
        // Activar el seguimiento
        _locationSubscription = _location.onLocationChanged.listen((LocationData newLocation) async {
          LatLng newPosition = LatLng(newLocation.latitude!, newLocation.longitude!);
          await FirebaseFirestore.instance.collection('driver_locations').doc(user.uid).set({
            'latitude': newLocation.latitude,
            'longitude': newLocation.longitude,
            'plate': _driverPlate,
            'heading': newLocation.heading, // Guardar la dirección de movimiento
            // No se actualiza el mensaje aquí
          }, SetOptions(merge: true)); // Merged update to avoid overwriting the message
          _addOrUpdateMarker(newPosition, _driverPlate, newLocation.heading ?? 0);
        });
      }
      setState(() {
        _isTracking = !_isTracking;
      });
    }
  }

  Future<void> _sendNotification(String message) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Validar si el mensaje es uno de los predefinidos
        const allowedMessages = [
          'Disponible',
          'No disponible',
          'Asientos no disponibles',
          'Sin cupos',
          'Tengo problemas'
        ];

        if (allowedMessages.contains(message)) {
          // Primero, actualizar la notificación
          await FirebaseFirestore.instance.collection('notifications').add({
            'user_id': user.uid,
            'plate': _driverPlate,
            'message': message,
            'timestamp': FieldValue.serverTimestamp(),
          });

          // Luego, actualizar el mensaje en la colección driver_locations
          await FirebaseFirestore.instance.collection('driver_locations').doc(user.uid).update({
            'message': message,
          });
        } else {
          print('Mensaje no permitido: $message');
        }
      } catch (e) {
        print('Error al enviar notificación: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mapa del Conductor',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 51, 122),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileConductor()),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 14, // Menos zoom inicial
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              // Mover el mapa al inicio de la ubicación actual con menos zoom
              _mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 14));
            },
          ),
          Positioned(
            bottom: 140,
            left: 20,
            child: ElevatedButton.icon(
              onPressed: _toggleTracking,
              icon: Icon(
                _isTracking ? Icons.location_off : Icons.location_on,
                color: Colors.white,
              ),
              label: Text(
                _isTracking ? 'Apagar Ubicación' : 'Activar Ubicación',
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 51, 122),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 20,
            child: ElevatedButton(
              onPressed: _showNotificationDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 51, 122),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              ),
              child: const Text(
                'Activar Notificación',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enviar Notificación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _sendNotification('Disponible');
                },
                child: const Text('Disponible'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _sendNotification('No disponible');
                },
                child: const Text('No disponible'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _sendNotification('Asientos no disponibles');
                },
                child: const Text('Asientos no disponibles'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _sendNotification('Sin cupos');
                },
                child: const Text('Sin cupos'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _sendNotification('Tengo problemas');
                },
                child: const Text('Tengo problemas'),
              ),
            ],
          ),
        );
      },
    );
  }
}
