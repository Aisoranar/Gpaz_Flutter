import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unipaz/conductor/mapconductor.dart';  // Asegúrate de ajustar la ruta de importación correctamente.

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
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

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
        'Registrarse',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final plateController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void registerUser() async {
    if (passwordController.text == confirmPasswordController.text) {
      try {
        UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Aquí puedes añadir más lógica para guardar información del usuario si es necesario.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MapConductor()), // Navegar a la página MapConductor.
        );
      } on FirebaseAuthException catch (e) {
        // Manejar errores de autenticación.
        print(e); // Mejor manejo de errores sería mostrando un diálogo o un snackbar.
      }
    } else {
      // Manejar error de confirmación de contraseña.
      print('Las contraseñas no coinciden');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Conductor'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            MyTextField(
              controller: nameController,
              hintText: 'Nombre del Conductor',
              obscureText: false,
              prefixIcon: Icon(Icons.person),
              iconColor: Colors.grey,
            ),
            SizedBox(height: 10),
            MyTextField(
              controller: lastNameController,
              hintText: 'Apellido del Conductor',
              obscureText: false,
              prefixIcon: Icon(Icons.person),
              iconColor: Colors.grey,
            ),
            SizedBox(height: 10),
            MyTextField(
              controller: phoneController,
              hintText: 'Teléfono del Conductor',
              obscureText: false,
              prefixIcon: Icon(Icons.phone),
              iconColor: Colors.grey,
            ),
            SizedBox(height: 10),
            MyTextField(
              controller: emailController,
              hintText: 'Correo del Conductor',
              obscureText: false,
              prefixIcon: Icon(Icons.email),
              iconColor: Colors.grey,
            ),
            SizedBox(height: 10),
            MyTextField(
              controller: plateController,
              hintText: 'Placa del Vehículo',
              obscureText: false,
              prefixIcon: Icon(Icons.directions_car),
              iconColor: Colors.grey,
            ),
            SizedBox(height: 10),
            MyTextField(
              controller: passwordController,
              hintText: 'Contraseña',
              obscureText: true,
              prefixIcon: Icon(Icons.lock),
              iconColor: Colors.grey,
            ),
            SizedBox(height: 10),
            MyTextField(
              controller: confirmPasswordController,
              hintText: 'Confirmar Contraseña',
              obscureText: true,
              prefixIcon: Icon(Icons.lock),
              iconColor: Colors.grey,
            ),
            SizedBox(height: 20),
            MyButton(
              onTap: registerUser,
              buttonColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
