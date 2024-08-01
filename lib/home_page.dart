import 'package:flutter/material.dart';
import 'package:unipaz/pages/login_page.dart';
import 'package:unipaz/pages/start_page.dart';
import 'package:unipaz/tabs/firts_tab.dart';
import 'package:unipaz/tabs/second_tab.dart';
import 'package:unipaz/tabs/third_tab.dart';
import 'package:unipaz/tabs/fourth_tab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  Widget _buildTab(IconData icon, String label) {
    return Tab(
      icon: Icon(
        icon,
        color: Color.fromARGB(247, 0, 51, 122),
      ),
      text: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Ajusta la altura según sea necesario
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0, // Elimina la sombra predeterminada del AppBar
            leading: IconButton(
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle, // Forma rectangular
                  image: DecorationImage(
                    image: AssetImage('Assets/icon/unipaz.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onPressed: () {},
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container()), // Expande el espacio a la izquierda del título
                Text(
                  'UNIPAZ - GPAZ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Expanded(child: Container()), // Expande el espacio a la derecha del título
              ],
            ),
            centerTitle: false, // Desactiva la alineación automática al centro
            actions: <Widget>[
              _buildPopupMenuButton(),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FirstTab(),
          ThirdTab(),
          SecondTab(),
          FourthTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          indicatorColor: Color.fromARGB(247, 0, 51, 122),
          labelColor: Color.fromARGB(247, 0, 51, 122),
          unselectedLabelColor: Colors.grey,
          tabs: [
            _buildTab(Icons.home, 'Inicio'),
            _buildTab(Icons.location_on, 'Paradas'),
            _buildTab(Icons.map, 'Mapa'),  // Cambié el icono aquí
            _buildTab(Icons.more_vert, 'Más'),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenuButton() {
    return PopupMenuButton<int>(
      icon: Icon(
        Icons.menu,
        color: Color.fromARGB(247, 0, 51, 122),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                Icons.info,
                color: Color.fromARGB(247, 0, 51, 122),
              ),
              SizedBox(width: 8),
              Text(
                "¿Cómo Funciona?",
                style: TextStyle(
                  color: Color.fromARGB(247, 0, 51, 122),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.close,
                color: Color.fromARGB(247, 0, 51, 122),
              ),
              SizedBox(width: 8),
              Text(
                "Cerrar",
                style: TextStyle(
                  color: Color.fromARGB(247, 0, 51, 122),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StartPage(fromHomePage: true),
            ),
          );
        } else if (value == 2) {
          Navigator.pop(context);  // Cierra el cuadro de diálogo
        }
      },
    );
  }
}
