import 'package:flutter/material.dart';

class ThirdTab extends StatefulWidget {
  @override
  _ThirdTabState createState() => _ThirdTabState();
}

class _ThirdTabState extends State<ThirdTab> {
  Map<String, Map<String, dynamic>> routeData = {
    'Parada 1': {
      'description': 'Frente a la bomba\nSan Silvestre Av 52',
      'imagePath': 'Assets/images/paradas/parada_principal.jpg',
    },
    'Parada 2': {
      'description': 'Iglesia Oración\nEspíritu Santo',
      'imagePath': 'Assets/images/paradas/parada_segunda.jpg',
    },
    'Parada 3': {
      'description': 'Yamaha Av 52',
      'imagePath': 'Assets/images/paradas/parada_yamahamotos.jpg',
    },
    'Parada 4': {
      'description': 'Frente al Parque\nCamilo Torres',
      'imagePath': 'Assets/images/paradas/parada_frentedescabezado.jpg',
    },
    'Parada 5': {
      'description': 'Cajero Servibanca\nde la 28',
      'imagePath': 'Assets/images/paradas/muypronto.jpg',
    },
    'Parada 6': {
      'description': 'Restaurante Pollo\nArabe',
      'imagePath': 'Assets/images/paradas/muypronto.jpg',
    },
    'Parada 7': {
      'description': 'Intercambiador',
      'imagePath': 'Assets/images/paradas/muypronto.jpg',
    },
    'Parada 8': {
      'description': 'Entrada Barrio\nYarima',
      'imagePath': 'Assets/images/paradas/muypronto.jpg',
    },
    'Parada 9': {
      'description': 'El Palmar',
      'imagePath': 'Assets/images/paradas/parada_palmar.jpg',
    },
    'Parada 10': {
      'description': 'Bosques de la Cira',
      'imagePath': 'Assets/images/paradas/parada_bosquecira.jpg',
    },
    'Parada 11': {
      'description': 'Frente a Bonanza -\nBavaria',
      'imagePath': 'Assets/images/paradas/muypronto.jpg',
    },
    'Parada 12': {
      'description': 'El Retén',
      'imagePath': 'Assets/images/paradas/muypronto.jpg',
    },
    'Parada 13': {
      'description': 'UNIPAZ',
      'imagePath': 'Assets/images/paradas/muypronto.jpg',
    },
  };

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
                  'RUTAS',
                  style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var route in routeData.keys)
                    GestureDetector(
                      onTap: () => _showRouteDescription(context, route),
                      child: _buildRouteItem(
                        route,
                        routeData[route]?['description'] ?? '',
                        routeData[route]?['imagePath'] ?? '',
                        Icons.gps_fixed,
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
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: Color.fromARGB(247, 0, 51, 122),
            size: 30.0,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 16.0),
          CircleAvatar(
            radius: 30.0,
            backgroundImage: AssetImage(imagePath),
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
        ),
      ),
    );
  }
}

class RouteDescriptionScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  RouteDescriptionScreen({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Cambia el color de la flecha a blanco
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(247, 0, 51, 122),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  imagePath,
                  height: 300.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                description,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(247, 0, 51, 122),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cerrar',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
