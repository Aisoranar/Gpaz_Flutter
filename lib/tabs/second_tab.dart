import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SecondTab extends StatefulWidget {
  @override
  _SecondTabState createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> {
  GoogleMapController? mapController;
  List<LatLng> ruta = [
    LatLng(7.0619238, -73.8648762), // 1RA
            LatLng( 7.06223, -73.86169), // hotel vizcaya plaza
            LatLng(7.061706, -73.8595833), // 2da
            LatLng( 7.06121, -73.85583), // estacion del trebol
            LatLng( 7.06151, -73.85373), // 3ra park camilo torres
            LatLng( 7.06176, -73.85193), // esquina tieda D1
            LatLng( 7.06017, -73.85151), //  4ta parada
            LatLng( 7.05411, -73.84963), // Ruta 66
            LatLng( 7.05265, -73.84865), // bosque monastery
            LatLng( 7.05105, -73.84790), // Hotel Rm
            LatLng( 7.05058, -73.84720), //  Cantabra
            LatLng( 7.05065, -73.84661), //  Cantabra parq
            LatLng( 7.05108, -73.84579), //  Diagonal 36
            LatLng( 7.05103, -73.84255), //  Dinastia china
            LatLng( 7.04998, -73.84055), //  Autos Yarima
            LatLng( 7.04898, -73.83968), //  Almacen y taller moto sebas
            LatLng( 7.04740, -73.83869), //  Imperio del marmol
            LatLng( 7.04644, -73.83815), //  Cilcars compraventa
            LatLng( 7.04565, -73.83742), //  Casa marmol
            LatLng( 7.04440, -73.83723), //  Willi club
            LatLng( 7.04179, -73.83405), //  Retorno el vivero
            LatLng( 7.04160, -73.83345), //  Retorno 2
            LatLng( 7.04248, -73.83016), //  Bavaria 1
            LatLng( 7.04238, -73.82951), //  Bavaria 2
            LatLng( 7.04212, -73.82876), //  Bavaria 3
            LatLng( 7.04224, -73.82836), //  Bavaria 4
            LatLng( 7.04425, -73.81378), //  Altoque Bca
            LatLng( 7.04468, -73.81261), //  Altoque Bca 2
            LatLng( 7.04736, -73.80610), //  Mina pakistan 1
            LatLng( 7.04746, -73.80509), //  Mina p 2
            LatLng( 7.04730, -73.78495), //  Intercambiador la virgen
            LatLng( 7.04694, -73.78296), //  Int 2
            LatLng( 7.04689, -73.78200), //  Int 3
            LatLng( 7.04654, -73.78100), //  Int 4
            LatLng( 7.04602, -73.78041), //  int 5
            LatLng( 7.04572, -73.78020), //  int 6
            LatLng( 7.04350, -73.77793), //  Doble calzada
            LatLng( 7.04312, -73.77706), //  Doble cal 2
            LatLng( 7.04314, -73.77621), //  Doble 3
            LatLng( 7.04506, -73.76549), //  Villa cristal
            LatLng( 7.04509, -73.76450), //  Rest el corral
            LatLng( 7.04493, -73.75456), //  Avenida via 1
            LatLng( 7.04524, -73.75343), //  Avn 2
            LatLng( 7.04587, -73.75261), //  Avn 3
            LatLng( 7.05207, -73.74717), //  Avn f4
            LatLng( 7.05316, -73.74685), //  Avn i5
            LatLng( 7.05470, -73.74708), //  Avn i6
            LatLng( 7.05923, -73.74799), // avn 7
            LatLng( 7.06068, -73.74749), //  Avn quebrada reposo
            LatLng( 7.06556, -73.74502), //  avn estadio unipaz
            LatLng( 7.06636, -73.74396), //  avn est 2
            LatLng( 7.07392, -73.73214), //  avn retorno
            LatLng( 7.07130, -73.73695), //  Avn retorno 2
            LatLng( 7.06863, -73.74062), //  avn ret 3
            LatLng( 7.06606, -73.74476), //  avn ret 4
            LatLng( 7.06690, -73.74550), //  entrada unipaz
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: GoogleMap(
          onMapCreated: (controller) {
            setState(() {
              mapController = controller;
            });
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(7.0652, -73.8545),
            zoom: 15.0,
          ),
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
            Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
          ].toSet(),
          polylines: {
            Polyline(
              polylineId: PolylineId("ruta"),
              points: ruta,
              color: Colors.blue,
              width: 5,
            ),
          },
          markers: _createMarkers(),
        ),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return Set<Marker>.from(
      [
        Marker(
          markerId: MarkerId("parada1"),
          position: LatLng(7.0619238, -73.8648762),
          infoWindow: InfoWindow(
            title: "Parada 1",
            snippet: "Salida Frente de la Bomba San Silvestre",
          ),
        ),
        Marker(
          markerId: MarkerId("parada2"),
          position: LatLng(7.061706, -73.8595833),
          infoWindow: InfoWindow(
            title: "Parada 2",
            snippet: "Iglesia Oración Espiritu Santo",
          ),
        ),
        Marker(
          markerId: MarkerId("parada3"),
          position: LatLng(7.0614351, -73.8533701),
          infoWindow: InfoWindow(
            title: "Parada 3",
            snippet: "Parque Descabezado",
          ),
        ),
        Marker(
          markerId: MarkerId("parada4"),
          position: LatLng(7.042433, -73.826933),
          infoWindow: InfoWindow(
            title: "Parada 4",
            snippet: "Kokorollo",
          ),
        ),
        Marker(
          markerId: MarkerId("parada5"),
          position: LatLng(7.0602549, -73.8515163),
          infoWindow: InfoWindow(
            title: "Parada 5",
            snippet: "Pollo Arabe",
          ),
        ),
        Marker(
          markerId: MarkerId("parada6"),
          position: LatLng(7.0602549, -73.8515163),
          infoWindow: InfoWindow(
            title: "Parada 6",
            snippet: "Kokorollo",
          ),
        ),
        Marker(
          markerId: MarkerId("parada7"),
          position: LatLng(7.0505528, -73.8471392),
          infoWindow: InfoWindow(
            title: "Parada 7",
            snippet: "Intercambiador",
          ),
        ),
        Marker(
          markerId: MarkerId("parada8"),
          position: LatLng(7.0436381, -73.8363577),
          infoWindow: InfoWindow(
            title: "Parada 8",
            snippet: "Palmar",
          ),
        ),
        Marker(
          markerId: MarkerId("parada9"),
          position: LatLng(7.0424402, -73.8268916),
          infoWindow: InfoWindow(
            title: "Parada 9",
            snippet: "Reten",
          ),
        ),
        Marker(
          markerId: MarkerId("parada10"),
          position: LatLng(7.0659946, -73.7448674),
          infoWindow: InfoWindow(
            title: "UNIPAZ Centro Investigaciones Santa Lucia",
            snippet: "Campus Universitario",
          ),
        ),
      ],
    );
  }
}
