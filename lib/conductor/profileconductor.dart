import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileConductor extends StatefulWidget {
  @override
  _ProfileConductorState createState() => _ProfileConductorState();
}

class _ProfileConductorState extends State<ProfileConductor> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final plateController = TextEditingController();
  final surnameController = TextEditingController();
  final phoneController = TextEditingController();

  bool isEditing = false;
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('Conductores')
          .doc(user!.uid)
          .get();

      if (userData.exists) {
        setState(() {
          nameController.text = userData['nombre'];
          emailController.text = userData['correo'];
          plateController.text = userData['placa'];
          surnameController.text = userData['apellido'];
          phoneController.text = userData['telefono'];
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('Conductores').doc(user!.uid).update({
          'nombre': nameController.text,
          'correo': emailController.text,
          'placa': plateController.text,
          'apellido': surnameController.text,
          'telefono': phoneController.text,
        });
        _showSnackBar('Datos guardados correctamente');
      } catch (e) {
        _showSnackBar('Error al guardar los datos: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perfil del Conductor',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 0, 51, 122),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: isEditing ? () async {
              await _updateUserData();
              setState(() {
                isEditing = false;
              });
            } : null,
          ),
        ],
      ),
      body: FutureBuilder(
        future: _loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los datos'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  MyTextField(
                    controller: nameController,
                    hintText: 'Nombre del Conductor',
                    obscureText: false,
                    prefixIcon: Icon(Icons.person),
                    iconColor: Color.fromARGB(247, 0, 51, 122),
                    enabled: isEditing,
                  ),
                  SizedBox(height: 10),
                  MyTextField(
                    controller: surnameController,
                    hintText: 'Apellido del Conductor',
                    obscureText: false,
                    prefixIcon: Icon(Icons.person_outline),
                    iconColor: Color.fromARGB(247, 0, 51, 122),
                    enabled: isEditing,
                  ),
                  SizedBox(height: 10),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Correo Electrónico',
                    obscureText: false,
                    prefixIcon: Icon(Icons.email),
                    iconColor: Color.fromARGB(247, 0, 51, 122),
                    enabled: isEditing,
                  ),
                  SizedBox(height: 10),
                  MyTextField(
                    controller: plateController,
                    hintText: 'Placa del Vehículo',
                    obscureText: false,
                    prefixIcon: Icon(Icons.directions_car),
                    iconColor: Color.fromARGB(247, 0, 51, 122),
                    enabled: isEditing,
                  ),
                  SizedBox(height: 10),
                  MyTextField(
                    controller: phoneController,
                    hintText: 'Teléfono',
                    obscureText: false,
                    prefixIcon: Icon(Icons.phone),
                    iconColor: Color.fromARGB(247, 0, 51, 122),
                    enabled: isEditing,
                  ),
                  SizedBox(height: 20),
                  isEditing
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MyButton(
                              onTap: () {
                                setState(() {
                                  isEditing = false;
                                });
                                _loadUserData(); // Reset data if cancel
                              },
                              buttonColor: Colors.grey,
                              buttonText: 'Cancelar',
                            ),
                            MyButton(
                              onTap: () async {
                                await _updateUserData();
                                setState(() {
                                  isEditing = false;
                                });
                              },
                              buttonColor: Color.fromARGB(247, 0, 51, 122),
                              buttonText: 'Guardar',
                            ),
                          ],
                        )
                      : MyButton(
                          onTap: () {
                            setState(() {
                              isEditing = true;
                            });
                          },
                          buttonColor: Color.fromARGB(247, 0, 51, 122),
                          buttonText: 'Editar',
                        ),
                ],
              ),
            );
          }
        },
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
  final bool enabled;

  MyTextField({
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
    required this.iconColor,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
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

class MyButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color buttonColor;
  final String buttonText;

  MyButton({required this.onTap, required this.buttonColor, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
      ),
      child: Text(
        buttonText,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
