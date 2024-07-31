import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unipaz/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Material App',
    home: isFirstLaunch ? const StartPage() : const HomePage(),
  ));
}

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        _buildPageViewModel(
          title: "¡Bienvenido a GPaz!",
          body: "Gracias por probar nuestra aplicación. Ten en cuenta que esta es una versión beta y puede contener errores. Tu feedback es valioso para mejorar la aplicación.",
          imagePath: 'Assets/icon/isologo.png', // Ruta de la imagen para esta página
        ),
        _buildPageViewModel(
          title: "Geolocalización en Tiempo Real",
          body: "Sigue la ubicación de tu bus en tiempo real, facilitando tu experiencia de viaje.",
          imagePath: 'Assets/icon/geolocalizacion.png', // Ruta de la imagen para esta página
        ),
        _buildPageViewModel(
          title: "Puntos de Parada",
          body: "Encuentra los puntos de parada exactos del bus y optimiza tu tiempo de espera.",
          imagePath: 'Assets/icon/puntosparada.png', // Ruta de la imagen para esta página
        ),
        _buildPageViewModel(
          title: "Consulta de Horarios",
          body: "Visualiza los horarios de tu ruta para planificar tus viajes de manera eficiente.",
          imagePath: 'Assets/icon/horarios.png', // Ruta de la imagen para esta página
        ),
        // Agrega más páginas según sea necesario
      ],
      onDone: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFirstLaunch', false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },
      onSkip: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFirstLaunch', false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },
      showSkipButton: true,
      skip: const Text("Saltar"),
      next: const Icon(Icons.arrow_forward),
      done: ElevatedButton(
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isFirstLaunch', false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(247, 0, 51, 122),
          minimumSize: const Size(120, 40), // Ajusta el tamaño mínimo del botón
        ),
        child: const Text(
          "GO",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  PageViewModel _buildPageViewModel({required String title, required String body, required String imagePath}) {
    return PageViewModel(
      title: title,
      bodyWidget: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Text(
                  body,
                  style: const TextStyle(
                    color: Color.fromARGB(247, 0, 51, 122),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      image: Image.asset(
        imagePath,
        height: 100.0,
      ),
      decoration: const PageDecoration(
        titleTextStyle: TextStyle(
          color: Color.fromARGB(247, 0, 51, 122),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
