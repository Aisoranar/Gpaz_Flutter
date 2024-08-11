import 'package:flutter/material.dart';
import 'package:unipaz/tabs/second_tab.dart';

class ThirdTab extends StatefulWidget {
  const ThirdTab({super.key});

  @override
  _ThirdTabState createState() => _ThirdTabState();
}

class _ThirdTabState extends State<ThirdTab> {
  Map<String, Map<String, dynamic>> routeData = {
    'Parada 1': {
      'description': 'Frente a la bomba\nSan Silvestre Av 52',
      'imagePath': 'Assets/images/paradas/parada1.png',
      'markerId': 'parada1',
    },
    'Parada 2': {
      'description': 'Iglesia Oración\nEspíritu Santo',
      'imagePath': 'Assets/images/paradas/parada_segunda.jpg',
      'markerId': 'parada2',
    },
    'Parada 3': {
      'description': 'Yamaha Av 52',
      'imagePath': 'Assets/images/paradas/parada_yamahamotos.jpg',
      'markerId': 'parada3',
    },
    'Parada 4': {
      'description': 'Frente al Parque\nCamilo Torres',
      'imagePath': 'Assets/images/paradas/parada_frentedescabezado.jpg',
      'markerId': 'parada4',
    },
    'Parada 5': {
      'description': 'Cajero Servibanca\nde la 28',
      'imagePath': 'Assets/images/paradas/parada5.png',
      'markerId': 'parada5',
    },
    'Parada 6': {
      'description': 'Restaurante Pollo\nArabe',
      'imagePath': 'Assets/images/paradas/parada6.png',
      'markerId': 'parada6',
    },
    'Parada 7': {
      'description': 'Intercambiador',
      'imagePath': 'Assets/images/paradas/parada7.png',
      'markerId': 'parada7',
    },
    'Parada 8': {
      'description': 'Entrada Barrio\nYarima',
      'imagePath': 'Assets/images/paradas/parada8.png',
      'markerId': 'parada8',
    },
    'Parada 9': {
      'description': 'El Palmar',
      'imagePath': 'Assets/images/paradas/parada9.png',
      'markerId': 'parada9',
    },
    'Parada 10': {
      'description': 'Bosques de la Cira',
      'imagePath': 'Assets/images/paradas/parada10.png',
      'markerId': 'parada10',
    },
    'Parada 11': {
      'description': 'Frente a Bonanza -\nBavaria',
      'imagePath': 'Assets/images/paradas/parada11.png',
      'markerId': 'parada11',
    },
    'Parada 12': {
      'description': 'El Retén',
      'imagePath': 'Assets/images/paradas/parada12.png',
      'markerId': 'parada12',
    },
    'Parada 13': {
      'description': 'UNIPAZ Centro Investigaciones Santa Lucia',
      'imagePath': 'Assets/images/paradas/muypronto.jpg',
      'markerId': 'parada13',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(247, 0, 51, 122),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30.0),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'RUTAS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0), // Espacio entre el encabezado y la lista
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  for (var entry in routeData.entries)
                    GestureDetector(
                      onTap: () => _showRouteDescription(context, entry.key),
                      child: _buildRouteItem(
                        entry.key,
                        entry.value['description'] ?? '',
                        entry.value['imagePath'] ?? '',
                        Icons.location_on,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteItem(String title, String subtitle, String imagePath, IconData iconData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: const Color.fromARGB(247, 0, 51, 122),
            size: 32.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              imagePath,
              height: 60.0,
              width: 60.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  void _showRouteDescription(BuildContext context, String route) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteDescriptionScreen(
          title: route,
          description: routeData[route]?['description'] ?? '',
          imagePath: routeData[route]?['imagePath'] ?? '',
          markerId: routeData[route]?['markerId'] ?? '',
        ),
      ),
    );
  }
}

class RouteDescriptionScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String markerId;

  const RouteDescriptionScreen({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.markerId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(247, 0, 51, 122),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    imagePath,
                    height: 250.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _navigateToMap(context, title),
                child: const Text('Ver en el mapa'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(247, 0, 51, 122),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToMap(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondTab(
          markerId: markerId,
          showBackButton: true, // Mostrar botón de regreso
        ),
      ),
    );
  }
}
