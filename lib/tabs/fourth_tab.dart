import 'package:flutter/material.dart';
import 'tyc.dart'; // Asegúrate de que la ruta de importación sea correcta

class FourthTab extends StatelessWidget {
  const FourthTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(247, 0, 51, 122),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: const Center(
              child: Text(
                'EQUIPO GPAZ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildTeamMember(
            name: 'Aisor Anaya',
            role: 'Desarrollador FullStack',
            icon: Icons.code,
          ),
          _buildTeamMember(
            name: 'Ing. Esp. Jhonis Rios',
            role: 'Director',
            icon: Icons.leaderboard,
          ),
          _buildTeamMember(
            name: 'Ing. Mag. Karen Salom',
            role: 'Directora',
            icon: Icons.star,
          ),
          _buildTeamMember(
            name: 'Sebastian Romero',
            role: 'Diseñador Gráfico',
            icon: Icons.palette,
          ),
          _buildTeamMember(
            name: 'Hadik Chavez',
            role: 'Diseñador UI/UX',
            icon: Icons.design_services,
          ),
          _buildTeamMember(
            name: 'Ronaldo Romero',
            role: 'Beta Tester',
            icon: Icons.bug_report,
          ),
          _buildTeamMember(
            name: 'Samuel Contreras',
            role: 'Evaluador de Software',
            icon: Icons.remove_red_eye,
          ),
          _buildTeamMember(
            name: 'Juan Gómez',
            role: 'Scrum Master',
            icon: Icons.group,
          ),
          _buildTeamMember(
            name: 'Luis Montaña',
            role: 'Documentador',
            icon: Icons.book,
          ),
          const SizedBox(height: 24),
          _buildAgradecimientos(),
          const SizedBox(height: 20),
          _buildTermsAndConditionsLink(context),
          const SizedBox(height: 20), // Espacio adicional para el final de la lista
        ],
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
    required IconData icon,
  }) {
    Color iconColor = const Color.fromARGB(247, 0, 51, 122);

    if (role == 'Director' || role == 'Directora') {
      iconColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 30.0,
          ),
          const SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                role,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgradecimientos() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AGRADECIMIENTOS',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(247, 0, 51, 122),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Queremos expresar nuestro agradecimiento a los estudiantes del 9no semestre 2024-A Diurno, cuya valiosa contribución ha sido fundamental para hacer realidad este proyecto.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditionsLink(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TermsAndConditionsTab()),
          );
        },
        child: const Text(
          'Términos y Condiciones',
          style: TextStyle(
            color: Color.fromARGB(247, 0, 51, 122),
            decoration: TextDecoration.underline,
            fontSize: 16,
            fontWeight: FontWeight.w500, // Peso de fuente moderado
          ),
        ),
      ),
    );
  }
}
