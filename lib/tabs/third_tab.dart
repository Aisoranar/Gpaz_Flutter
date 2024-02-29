import 'package:flutter/material.dart';

class ThirdTab extends StatefulWidget {
  @override
  _ThirdTabState createState() => _ThirdTabState();
}

class _ThirdTabState extends State<ThirdTab> {
  Map<String, Map<String, dynamic>> routeData = {
    'Parada 1': {
      'description': 'CALLE 52 CRA 12',
      'imagePath': 'Assets/images/parada_descabezado.jpg',
    },
    'Parada 2': {
      'description': 'CALLE 52 CRA 13',
      'imagePath': 'Assets/images/parada_descabezado.jpg',
    },
    'Parada 3': {
      'description': 'CALLE 52 CRA 22',
      'imagePath': 'Assets/images/parada_descabezado.jpg',
    },
    'Parada 4': {
      'description': 'CALLE 52 CRA 26',
      'imagePath': 'Assets/images/parada_descabezado.jpg',
    },
    'Parada 5': {
      'description': 'CALLE 52 CRA 28',
      'imagePath': 'Assets/images/parada_descabezado.jpg',
    },
    'Parada 6': {
      'description': 'EN POLLO ARABE',
      'imagePath': 'Assets/images/parada_descabezado.jpg',
    },
    'Parada 7': {
      'description': 'INTERCAMBIADOR',
      'imagePath': 'Assets/images/parada_descabezado.jpg',
    },
    'Parada 8': {
      'description': 'BARRIO YARIMA',
      'imagePath': 'Assets/images/parada_descabezado.jpg',
    },
    'Parada 9': {
      'description': 'BARRIO YARIMA',
      'imagePath': 'Assets/images/parada_descabezado.jpg',
    },
    'Parada 10': {
      'description': 'ENTRADA AL PALMAR',
      'imagePath': 'Assets/images/parada_descabezado.jpg',
    },
    'Parada 11': {
      'description': 'BONANZA',
      'imagePath': 'Assets/images/parada_descabezado.jpg',
    },
    'Parada 12': {
      'description': 'RETEN',
      'imagePath': 'Assets/images/parada_descabezado.jpg',
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
              padding: EdgeInsets.symmetric(vertical: 20.0),//aca
              decoration: BoxDecoration(
                color: Color(0xFF00B7FF),
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
            color: Color(0xFF00B7FF),
            size: 30.0,
          ),
          SizedBox(width: 16.0),
          Column(
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
              ),
            ],
          ),
          Spacer(),
          CircleAvatar(
            radius: 50.0, //IMAGEN CIRCULO ANCHO
            backgroundImage: AssetImage(imagePath),
          ),
        ],
      ),
    );
  }

//IMAGEN
  void _showRouteDescription(BuildContext context, String route) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(route),
        content: Container(
          constraints: BoxConstraints(maxHeight: 300.0),
          child: Column(
            children: [
              Image.asset(
                routeData[route]?['imagePath'] ?? '',
                height: 200.0,
                width: 400.0,
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(routeData[route]?['description'] ?? ''),
              ),
            ],
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 0.0), // Ajusta el espacio alrededor del contenido
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cerrar'),
          ),
        ],
      );
    },
  );
}



}
