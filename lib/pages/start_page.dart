import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:unipaz/home_page.dart';

void main() {
  runApp(StartPage());
}

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: IntroductionScreen(
        pages: [
          _buildPageViewModel(
            title: "¡Bienvenido a Gpaz!",
            body: "Tu compañero de viaje inteligente",
          ),
          _buildPageViewModel(
            title: "Geolocalización en Tiempo Real",
            body: "Sigue la ubicación de tu bus en tiempo real, facilitando tu experiencia de viaje.",
          ),
          _buildPageViewModel(
            title: "Puntos de Parada",
            body: "Encuentra los puntos de parada exactos del bus y optimiza tu tiempo de espera.",
          ),
          _buildPageViewModel(
            title: "Consulta de Horarios",
            body: "Visualiza los horarios de tu ruta para planificar tus viajes de manera eficiente.",
          ),
          // Agrega más páginas según sea necesario
        ],
        onDone: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        onSkip: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        showSkipButton: true,
        skip: const Text("Saltar"),
        next: const Icon(Icons.arrow_forward),
        done: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(247, 0, 51, 122),
          ),
          child: Text(
            "VAMOS",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  PageViewModel _buildPageViewModel({required String title, required String body}) {
    return PageViewModel(
      title: title,
      bodyWidget: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Text(
                  body,
                  style: TextStyle(
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
        'Assets/icon/isologo.jpg',
        height: 100.0,
      ),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          color: Color.fromARGB(247, 0, 51, 122),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
