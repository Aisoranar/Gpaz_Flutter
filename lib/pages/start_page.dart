import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unipaz/home_page.dart';
import 'package:unipaz/selectoption.dart';

class StartPage extends StatelessWidget {
  final bool fromHomePage;
  
  const StartPage({Key? key, this.fromHomePage = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(247, 255, 255, 255),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: AssetImage('Assets/icon/white.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: AssetImage('Assets/icon/unipaz.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: IntroductionScreen(
        pages: [
          _buildPageViewModel(
            title: "¡Bienvenido a GPaz!",
            body: "Gracias por probar nuestra aplicación. Ten en cuenta que esta es una versión beta y puede contener errores. Tu feedback es valioso para mejorar la aplicación.",
            imagePath: 'Assets/icon/isologo.png',
          ),
          _buildPageViewModel(
            title: "Geolocalización en Tiempo Real",
            body: "Sigue la ubicación de tu bus en tiempo real, facilitando tu experiencia de viaje.",
            imagePath: 'Assets/icon/geolocalizacion.png',
          ),
          _buildPageViewModel(
            title: "Puntos de Parada",
            body: "Encuentra los puntos de parada exactos del bus y optimiza tu tiempo de espera.",
            imagePath: 'Assets/icon/puntosparada.png',
          ),
          _buildPageViewModel(
            title: "Consulta de Horarios",
            body: "Visualiza los horarios de tu ruta para planificar tus viajes de manera eficiente.",
            imagePath: 'Assets/icon/horarios.png',
          ),
        ],
        onDone: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isFirstLaunch', false);
          if (fromHomePage) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SelectOption()),
            );
          }
        },
        onSkip: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isFirstLaunch', false);
          if (fromHomePage) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SelectOption()),
            );
          }
        },
        showSkipButton: true,
        skip: const Text(
          "Saltar",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        next: const Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
        done: ElevatedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isFirstLaunch', false);
            if (fromHomePage) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SelectOption()),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(247, 0, 51, 122),
            minimumSize: const Size(120, 40),
          ),
          child: const Text(
            "GO",
            style: TextStyle(
              color: Colors.white,
            ),
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
                    fontSize: 16.0,
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
          fontSize: 24.0,
        ),
        bodyTextStyle: TextStyle(
          color: Color.fromARGB(247, 0, 51, 122),
          fontSize: 16.0,
        ),
        imagePadding: EdgeInsets.all(24),
      ),
    );
  }
}
