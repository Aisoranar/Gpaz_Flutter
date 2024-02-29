import 'package:flutter/material.dart';

class FirstTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 196, 223, 233),
      child: Center(
        child: SizedBox.expand(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0.0), // Ajusta el radio de esquinas según sea necesario
            child: Image(
              image: AssetImage('Assets/images/bus_imagen.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
