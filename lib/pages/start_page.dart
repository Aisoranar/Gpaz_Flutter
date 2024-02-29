import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:unipaz/home_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "¡Bienvenido a Gpaz!",
            body: "Tu compañero de viaje inteligente",
            image: Image.asset('Assets/icon/isologo.jpg'),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                color: Color.fromARGB(247, 0, 51, 122),
                fontWeight: FontWeight.bold, // Establece la fuente en negrilla
              ),
              bodyTextStyle: TextStyle(color: Color.fromARGB(247, 0, 51, 122)),
            ),
          ),
          PageViewModel(
            title: "Geolocalización en Tiempo Real",
            body: "Sigue la ubicación de tu bus en tiempo real, facilitando tu experiencia de viaje.",
            image: Image.asset('Assets/icon/isologo.jpg'),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                color: Color.fromARGB(247, 0, 51, 122),
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(color: Color.fromARGB(247, 0, 51, 122)),
            ),
          ),
          PageViewModel(
            title: "Puntos de Parada",
            body: "Encuentra los puntos de parada exactos del bus y optimiza tu tiempo de espera.",
            image: Image.asset('Assets/icon/isologo.jpg'),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                color: Color.fromARGB(247, 0, 51, 122),
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(color: Color.fromARGB(247, 0, 51, 122)),
            ),
          ),
          PageViewModel(
            title: "Consulta de Horarios",
            body: "Visualiza los horarios de tu ruta para planificar tus viajes de manera eficiente.",
            image: Image.asset('Assets/icon/isologo.jpg'),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                color: Color.fromARGB(247, 0, 51, 122),
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(color: Color.fromARGB(247, 0, 51, 122)),
            ),
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
        done: const Text("¡Listo para Iniciar!"),
      ),
    );
  }
}
