import 'package:flutter/material.dart';

class ThirdTab extends StatefulWidget {
  @override
  _ThirdTabState createState() => _ThirdTabState();
}

class _ThirdTabState extends State<ThirdTab> {
  Map<String, Map<String, dynamic>> routeData = {
    'Parada 1': {
      'description': 'CALLE 52 CRA 12',
      'imagePath': 'Assets/images/paradas/parada_principal.jpg',
    },
    'Parada 2': {
      'description': 'CALLE 52 CRA 13',
      'imagePath': 'Assets/images/paradas/parada_segunda.jpg',
    },
    'Parada 3': {
      'description': 'YAMAHA',
      'imagePath': 'Assets/images/paradas/parada_yamahamotos.jpg',
    },
    'Parada 4': {
      'description': 'CALLE 52 CRA 22',
      'imagePath': 'Assets/images/paradas/parada_frentedescabezado.jpg',
    },
    'Parada 5': {
      'description': 'CALLE 52 CRA 26',
      'imagePath': 'Assets/images/paradas/muypronto.jpg',
    },
    'Parada 6': {
      'description': 'POLLO ARABE',
      'imagePath': 'Assets/images/paradas/muypronto.jpg',
    },
    'Parada 7': {
      'description': 'EL INTERCAMBIADOR',
      'imagePath': 'Assets/images/paradas/muypronto.jpg',
    },
    'Parada 8': {
      'description': 'BARRIO YARIMA',
      'imagePath': 'Assets/images/paradas/muypronto.jpg',
    },
    'Parada 9': {
      'description': 'EL PALMAR',
      'imagePath': 'Assets/images/paradas/parada_palmar.jpg',
    },
    'Parada 10': {
      'description': 'BOSQUE DE LA CIRA',
      'imagePath': 'Assets/images/paradas/parada_bosquecira.jpg',
    },
    'Parada 11': {
      'description': 'LA BONANZA',
      'imagePath': 'Assets/images/paradas/muypronto.jpg',
    },
    'Parada 12': {
      'description': 'EL RETEN',
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
              padding: EdgeInsets.symmetric(vertical: 20.0),//aca
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
