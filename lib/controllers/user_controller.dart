import 'package:flutter/material.dart';

class UserController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final TextEditingController verificarEmailController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController confirmarContrasenaController = TextEditingController();

  void disposeControllers() {
    emailController.dispose();
    nombreController.dispose();
    apellidoController.dispose();
    telefonoController.dispose();
    placaController.dispose();
    verificarEmailController.dispose();
    contrasenaController.dispose();
    confirmarContrasenaController.dispose();
  }
}
