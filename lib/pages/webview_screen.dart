import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _canAccessSuggestions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.data!) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Enviar sugerencias',
                style: TextStyle(color: Colors.white), // Texto blanco en la AppBar
              ),
              backgroundColor: const Color.fromARGB(247, 0, 51, 122), // Color de fondo de la AppBar
              iconTheme: const IconThemeData(color: Colors.white), // Color blanco para los íconos de la AppBar
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Título grande
                    const Text(
                      '¡Gracias por tus sugerencias!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24, // Tamaño de fuente grande
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Texto adicional más pequeño
                    const Text(
                      'El equipo de GPaz las está tomando en cuenta y trabajará para mejorar la aplicación. '
                      'Debes esperar 5 minutos para enviar otra sugerencia. ¡Tu opinión es muy valiosa para nosotros!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Tamaño de fuente más pequeño
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      'Assets/images/support.png',
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: const Color.fromARGB(247, 0, 51, 122), // Color de fondo de la pantalla
          );
        }

        // Instanciar el WebViewController
        final WebViewController webViewController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000)) // Fondo transparente
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onHttpError: (HttpResponseError error) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                // Bloquear navegación a ciertos sitios si es necesario
                if (request.url.startsWith('https://www.youtube.com/')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse('https://forms.gle/Xwtcs3QnoafgmvTAA'));

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Enviar sugerencias',
              style: TextStyle(color: Colors.white), // Texto blanco en la AppBar
            ),
            backgroundColor: const Color.fromARGB(247, 0, 51, 122), // Color de fondo de la AppBar
            iconTheme: const IconThemeData(color: Colors.white), // Color blanco para los íconos de la AppBar
          ),
          body: WebViewWidget(controller: webViewController),
          backgroundColor: const Color.fromARGB(247, 0, 51, 122), // Color de fondo de la pantalla
        );
      },
    );
  }

  Future<bool> _canAccessSuggestions() async {
    final prefs = await SharedPreferences.getInstance();
    final currentDate = DateTime.now();
    final lastAccessDateStr = prefs.getString('lastAccessDate');
    final lastAccessDate = lastAccessDateStr != null ? DateTime.parse(lastAccessDateStr) : null;

    if (lastAccessDate == null || currentDate.difference(lastAccessDate).inMinutes >= 5) {
      // Permitir acceso y actualizar la fecha de último acceso
      await prefs.setString('lastAccessDate', currentDate.toIso8601String());
      return true;
    } else {
      // Bloquear acceso y mostrar mensaje
      return false;
    }
  }
}
