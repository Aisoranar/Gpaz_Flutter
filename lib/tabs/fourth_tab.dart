import 'package:flutter/material.dart';
import 'tyc.dart'; // Asegúrate de que la ruta de importación sea correcta

class FourthTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(247, 0, 51, 122),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Center(
                child: Text(
                  'EQUIPO GPAZ',
                  style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Aisor Anaya
                  _buildTeamMember(
                    name: 'Aisor Anaya',
                    role: 'Desarrollador FullStack',
                    icon: Icons.person,
                  ),

                  // Jhonis Rios
                  _buildTeamMember(
                    name: 'Ing. Esp. Jhonis Rios',
                    role: 'Director',
                    icon: Icons.person,
                  ),

                  // Karen Salom
                  _buildTeamMember(
                    name: 'Ing. Mag. Karen Salom',
                    role: 'Directora',
                    icon: Icons.person,
                  ),

                  // Sebastian Romero
                  _buildTeamMember(
                    name: 'Sebastian Romero',
                    role: 'Diseñador Gráfico',
                    icon: Icons.person,
                  ),

                  // Hadik Chavez
                  _buildTeamMember(
                    name: 'Hadik Chavez',
                    role: 'Diseñador UI/UX',
                    icon: Icons.person,
                  ),

                  // Agradecimientos
                  _buildAgradecimientos(),

                  // Resto de tu contenido...
                  _buildTermsAndConditionsLink(context), // Agrega el enlace aquí
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
    required IconData icon,
  }) {
    Color iconColor = const Color.fromARGB(247, 0, 51, 122);

    // Verificar si es el director o el co-director y cambiar el color del icono
    if (role == 'Director' || role == 'Directora') {
      iconColor = Colors.green; // Puedes cambiar este color a tu preferencia
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor, // Usar el color determinado según el rol
            size: 30.0,
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                role,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgradecimientos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'AGRADECIMIENTOS',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Queremos expresar nuestro agradecimiento a los estudiantes del 9no semestre 2024-A Diurno, cuya valiosa contribución ha sido fundamental para hacer realidad este proyecto.',
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditionsLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TermsAndConditionsTab()),
            );
          },
          child: Text(
            'Términos y Condiciones',
            style: TextStyle(
              color: const Color.fromARGB(247, 0, 51, 122),
              decoration: TextDecoration.underline,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
