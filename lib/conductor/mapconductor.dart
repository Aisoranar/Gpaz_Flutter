import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:unipaz/conductor/profileconductor.dart';
import 'package:unipaz/selectoption.dart';
import 'package:unipaz/notifications/notifications_manager.dart';

class MapConductor extends StatefulWidget {
  const MapConductor({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MapConductorState createState() => _MapConductorState();
}

class _MapConductorState extends State<MapConductor> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  LatLng _currentPosition = const LatLng(0, 0);
  final Location _location = Location();
  late String _driverPlate;
  bool _isTracking = false;

  late StreamSubscription<LocationData> _locationSubscription;
  late BitmapDescriptor _customIcon;
  late BitmapDescriptor _customParada;

  NotificationsManager? notificationsManager;

  @override
  void initState() {
    super.initState();
    _fetchDriverPlate();
    _getCurrentLocation();
    _loadCustomIcon();
    notificationsManager = NotificationsManager(context);
  }

  Future<void> _loadCustomIcon() async {
    _customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)),
      'Assets/icon/cotsem.png',
    );
    _customParada = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(20, 20)),
      'Assets/icon/gpsiconparada.png',
    );
  }

  Future<void> _fetchDriverPlate() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
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
      _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
      _addOrUpdateMarker(_currentPosition, _driverPlate, locationData.heading ?? 0);
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 14));
    });
  }

  void _listenToDriverLocation() {
    _locationSubscription = _location.onLocationChanged.listen((LocationData newLocation) async {
      LatLng newPosition = LatLng(newLocation.latitude!, newLocation.longitude!);
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('driver_locations').doc(user.uid).set({
            'latitude': newLocation.latitude,
            'longitude': newLocation.longitude,
            'plate': _driverPlate,
            'heading': newLocation.heading,
          }, SetOptions(merge: true));
        }
        _addOrUpdateMarker(newPosition, _driverPlate, newLocation.heading ?? 0);

        // Ajustar el zoom del mapa al compartir ubicación
        _mapController.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 14)); // Zoom más cercano
      } catch (e) {
        print('Error al guardar la ubicación: $e');
      }
    });

    FirebaseFirestore.instance.collection('driver_locations').snapshots().listen((snapshot) {
      try {
        if (snapshot.docs.isNotEmpty) {
          final newMarkers = <Marker>{};
          for (var doc in snapshot.docs) {
            final data = doc.data(); // Conversión explícita
            final LatLng position = LatLng(data['latitude'], data['longitude']);
            final String plate = data['plate'] ?? 'Placa no disponible';
            final String message = data['message'] ?? ''; // Leer el mensaje de la notificación
            final double heading = data['heading'] ?? 0.0;

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
              ),
            );
                    }
          setState(() {
            _markers.clear();
            _markers.addAll(newMarkers);
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
              _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
            }
          });
        }
      } catch (e) {
        print('Error al actualizar la ubicación: $e');
      }
    });
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId("parada1"),
        position: const LatLng(7.0619238, -73.8648762),
        icon: _customParada,
        infoWindow: const InfoWindow(
          title: "Parada 1",
          snippet: "Frente a la Bomba San Silvestre Av. 52",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada2"),
        position: const LatLng(7.061706, -73.8595833),
        icon: _customParada,
        infoWindow: const InfoWindow(
          title: "Parada 2",
          snippet: "Iglesia Oración Espíritu Santo",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada3"),
        position: const LatLng(7.0612446, -73.8565249),
        icon: _customParada,
        infoWindow: const InfoWindow(
          title: "Yamaha Av 52",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada5"),
        position: const LatLng(7.0599965, -73.8513638),
        icon: _customParada,
        infoWindow: const InfoWindow(
          title: "Cajero Servibanca de la 28",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada6"),
        position: const LatLng(7.0573063, -73.8506163),
        icon: _customParada,
        infoWindow: const InfoWindow(
          title: "Restaurante Pollo Arabe",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada7"),
        position: const LatLng(7.0505295, -73.8472625),
        icon: _customParada,
        infoWindow: const InfoWindow(
          title: "Intercambiador",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada8"),
        position: const LatLng(7.050025, -73.8405155),
        icon: _customParada,
        infoWindow: const InfoWindow(
          title: "Entrada Barrio Yarima",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada9"),
        position: const LatLng(7.0436381, -73.8363577),
        icon: _customParada,
        infoWindow: const InfoWindow(
          title: "El Palmar",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada10"),
        position: const LatLng(7.0422154, -73.83111),
        icon: _customParada,
        infoWindow: const InfoWindow(
          title: "Bosques de la Cira",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada11"),
        position: const LatLng(7.0421841, -73.8290742),
        icon: _customParada,
        infoWindow: const InfoWindow(
          title: "Frente a Bonanza - Bavaria",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada12"),
        position: const LatLng(7.0424402, -73.8268916),
        icon: _customParada,
        infoWindow: const InfoWindow(
          title: "El Retén",
        ),
      ),
      Marker(
        markerId: const MarkerId("parada13"),
        position: const LatLng(7.0659946, -73.7448674),
        icon: _customParada,
        infoWindow: const InfoWindow(
          title: "UNIPAZ Centro Investigaciones Santa Lucia",
          snippet: "Campus Universitario",
        ),
      ),
    };
    return markers;
  }

  void _addOrUpdateMarker(LatLng position, String plate, double heading) {
    final marker = Marker(
      markerId: const MarkerId('current_location'),
      position: position,
      infoWindow: InfoWindow(
        title: 'Placa $plate',
        snippet: 'Ubicación actual',
      ),
      icon: _customIcon,
      rotation: heading,
    );
    setState(() {
      _markers.add(marker);
      _mapController.animateCamera(CameraUpdate.newLatLng(position));
    });
  }

  void _toggleTracking() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (_isTracking) {
        // Desactivar el seguimiento
        await FlutterBackground.disableBackgroundExecution();
        try {
          await FirebaseFirestore.instance.collection('driver_locations').doc(user.uid).delete();
        } catch (e) {
          print('Error al eliminar la ubicación: $e');
        }
        _locationSubscription.cancel();
        if (notificationsManager != null) {
          await notificationsManager!.showNotification(
            'GPS Desactivado',
            'Se ha desactivado el GPS correctamente.',
          );
        }
        setState(() {
          _isTracking = false;
          _markers.clear(); // Eliminar marcador al apagar la ubicación
        });
      } else {
        // Activar el seguimiento
        bool success = await FlutterBackground.enableBackgroundExecution();
        if (success) {
          _listenToDriverLocation();
          if (notificationsManager != null) {
            await notificationsManager!.showNotification(
              'GPS Activado',
              'Se ha activado el GPS correctamente.',
            );
          }
          setState(() {
            _isTracking = true;
          });
        } else {
          print('No se pudo activar la ejecución en segundo plano.');
        }
      }
    }
  }

  Future<void> _sendNotification(String message) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        const allowedMessages = [
          'Disponible',
          'No disponible',
          'Asientos no disponibles',
          'Sin cupos',
          'Tengo problemas'
        ];

        if (allowedMessages.contains(message)) {
          await FirebaseFirestore.instance.collection('notifications').add({
            'user_id': user.uid,
            'plate': _driverPlate,
            'message': message,
            'timestamp': FieldValue.serverTimestamp(),
          });

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

  void _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Está seguro de que desea cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sí'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Desactivar el seguimiento y eliminar la ubicación
        await FlutterBackground.disableBackgroundExecution();
        try {
          // Eliminar la ubicación del conductor en Firestore
          await FirebaseFirestore.instance.collection('driver_locations').doc(user.uid).delete();
        } catch (e) {
          print('Error al eliminar la ubicación: $e');
        }

        // Cancelar la suscripción a la ubicación
        await _locationSubscription.cancel();
      
        // Cerrar sesión en Firebase
        await FirebaseAuth.instance.signOut();

        // Redirigir al usuario a SelectOption
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SelectOption()),
        );
      }
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _logout(); // Cerrar sesión cuando se presiona el botón de retroceso
        return false; // Prevenir la acción de retroceso predeterminada
      },
      child: Scaffold(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 51, 122),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: 20,
              child: ElevatedButton.icon(
                onPressed: () async {
                  String? selectedMessage = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Seleccionar Notificación'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: const Text('Disponible'),
                              onTap: () => Navigator.pop(context, 'Disponible'),
                            ),
                            ListTile(
                              title: const Text('No disponible'),
                              onTap: () => Navigator.pop(context, 'No disponible'),
                            ),
                            ListTile(
                              title: const Text('Asientos no disponibles'),
                              onTap: () => Navigator.pop(context, 'Asientos no disponibles'),
                            ),
                            ListTile(
                              title: const Text('Sin cupos'),
                              onTap: () => Navigator.pop(context, 'Sin cupos'),
                            ),
                            ListTile(
                              title: const Text('Tengo problemas'),
                              onTap: () => Navigator.pop(context, 'Tengo problemas'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                  if (selectedMessage != null) {
                    await _sendNotification(selectedMessage);
                  }
                },
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text(
                  'Enviar Notificación',
                  style: TextStyle(color: Colors.white),
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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _locationSubscription.cancel();
    super.dispose();
  }
}
