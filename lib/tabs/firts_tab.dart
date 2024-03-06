import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class FirstTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Preguntar por los permisos al cargar la pestaña
    _requestNotificationPermission(context);

    return Container(
      color: Color.fromARGB(255, 196, 223, 233),
      child: Center(
        child: SizedBox.expand(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0.0),
            child: Image(
              image: AssetImage('Assets/images/bus_imagen.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _requestNotificationPermission(BuildContext context) async {
    var status = await Permission.notification.status;

    if (!status.isGranted) {
      // Si el permiso no está concedido, solicítalo al usuario
      await Permission.notification.request();

      // Mostrar un SnackBar informando al usuario sobre la necesidad de conceder permisos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, concede los permisos de notificación para un mejor funcionamiento de la aplicación.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }
}
