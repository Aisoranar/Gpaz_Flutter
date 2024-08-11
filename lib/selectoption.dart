import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importar FirebaseAuth
import 'home_page.dart';
import 'pages/login_page.dart';
import 'package:unipaz/conductor/mapconductor.dart'; // Importar MapConductor

class SelectOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 51, 122), // Azul oscuro
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'Assets/icon/logounipazblanco.png',
                height: 200, // Ajusta la altura según sea necesario
              ),
              SizedBox(height: 20), // Espacio entre la imagen y el texto
              Text(
                '¡Bienvenido a Gpaz!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50), // Espacio entre el texto y los botones
              Container(
                width: 250, // Fija el ancho de los botones
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 0, 51, 122),
                        backgroundColor: Colors.white, // Texto azul oscuro
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      icon: Icon(Icons.person, size: 24), // Icono de persona
                      label: Text(
                        'Soy Unipaz',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Espacio entre los dos botones
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green, // Texto blanco
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        if (currentUser != null) {
                          // Si el usuario ya está autenticado, redirigir al mapa del conductor
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const MapConductor()),
                          );
                        } else {
                          // Si no está autenticado, redirigir a la página de inicio de sesión
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        }
                      },
                      icon: Icon(Icons.directions_bus, size: 24), // Icono de bus
                      label: Text(
                        'Soy Conductor',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
