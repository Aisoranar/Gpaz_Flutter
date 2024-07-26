import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unipaz/components/square_tile.dart';
import 'package:unipaz/conductor/mapconductor.dart';
import 'package:unipaz/pages/register_page.dart';  // Asegúrate de ajustar la ruta de importación.

class MyButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color buttonColor;

  MyButton({required this.onTap, required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
      ),
      child: Text(
        'Iniciar sesión',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon prefixIcon;
  final Color iconColor;

  MyTextField({
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          prefixIcon.icon,
          color: iconColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MapConductor()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'Email no encontrado') {
        wrongEmailMessage();
      } else if (e.code == 'Contraseña incorrecta') {
        wrongPasswordMessage();
      }
    }
  }

  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(title: Text('Correo no encontrado')),
    );
  }

  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(title: Text('Contraseña Incorrecta')),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(247, 0, 51, 122),
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image(
                      image: AssetImage('Assets/icon/isologo.jpg'),
                      height: 100,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              const Text(
                '¡Bienvenido de vuelta!',
                style: TextStyle(
                  color: Color.fromARGB(247, 0, 51, 122),
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: emailController,
                hintText: 'Correo electrónico',
                obscureText: false,
                prefixIcon: Icon(Icons.email),
                iconColor: Color.fromARGB(247, 0, 51, 122),
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: 'Contraseña',
                obscureText: true,
                prefixIcon: Icon(Icons.lock),
                iconColor: Color.fromARGB(247, 0, 51, 122),
              ),
              const SizedBox(height: 25),
              MyButton(
                onTap: signUserIn,
                buttonColor: const Color.fromARGB(247, 0, 51, 122),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()), // Navegar a la página de registro.
                  );
                },
                child: Text(
                  '¿No tienes una cuenta? Regístrate',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Continuar con',
                        style: TextStyle(color: Color.fromARGB(247, 0, 51, 122)),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Color.fromARGB(255, 254, 253, 253),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(imagePath: 'lib/images/google.png'),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    ),
  );
}}


void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}
