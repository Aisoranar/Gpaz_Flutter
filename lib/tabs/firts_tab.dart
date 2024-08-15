import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unipaz/pages/webview_screen.dart';

class FirstTab extends StatelessWidget {
  const FirstTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Preguntar por los permisos al cargar la pestaña
    _requestNotificationPermission(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 196, 223, 233),
            child: Center(
              child: SizedBox.expand(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.0),
                  child: const Image(
                    image: AssetImage('Assets/images/bus_imagen1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55, // Ajuste vertical para centrar un poco más arriba
            right: 16, // Ajustado para que esté más alineado
            child: ElevatedButton.icon(
              icon: const Icon(Icons.feedback, color: Colors.white, size: 24), // Tamaño del ícono
              label: const Text(
                'Enviar sugerencias',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 38, 52, 140), // Color más sofisticado
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Bordes más redondeados
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Espaciado
                elevation: 8, // Sombra más prominente
                side: const BorderSide(color: Colors.white, width: 2), // Borde del botón
              ),
              onPressed: () {
                _showSuggestionDialog(context);
              },
            ),
          ),
        ],
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
        const SnackBar(
          content: Text('Por favor, concede los permisos de notificación para un mejor funcionamiento de la aplicación.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  void _showSuggestionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Bordes redondeados del diálogo
          ),
          title: const Text(
            'Enviar Sugerencia',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(247, 0, 51, 122),
            ),
          ),
          content: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Tu opinión es muy valiosa para nosotros. ¿Te gustaría enviar una sugerencia para ayudar a mejorar la beta de GPaz?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5, // Mayor interlineado
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(247, 0, 51, 122),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Sí',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16), // Espacio entre los botones
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(247, 122, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'No',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
