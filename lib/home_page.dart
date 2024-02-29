import 'package:flutter/material.dart';

import 'package:unipaz/pages/login_page.dart';

import 'package:unipaz/tabs/firts_tab.dart';
import 'package:unipaz/tabs/fourth_tab.dart';
import 'package:unipaz/tabs/second_tab.dart';
import 'package:unipaz/tabs/third_tab.dart';


class HomePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'G P A Z - A L P H A',
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(247, 0, 51, 122),
                ),
              ),
              _buildPopupMenuButton(context),
            ],
          ),
          bottom: TabBar(
            tabs: [
              _buildTab(Icons.home),
              _buildTab(Icons.map),
              _buildTab(Icons.location_on),
              _buildTab(Icons.group),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FirstTab(),
            SecondTab(),
            ThirdTab(),
            FourthTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(IconData icon) {
    return Tab(
      icon: Icon(
        icon,
        color: Color.fromARGB(247, 0, 51, 122),
      ),
    );
  }

  Widget _buildPopupMenuButton(BuildContext context) {
  return PopupMenuButton(
    icon: Icon(Icons.more_vert, color: Color.fromARGB(247, 0, 51, 122)),
    itemBuilder: (context) => [
      PopupMenuItem(
        child: Text('Iniciar Sesión'),
        value: 'login',
      ),
      // Puedes eliminar esta parte para quitar la opción "Cerrar Sesión"
      // PopupMenuItem(
      //   child: Text('Cerrar Sesión'),
      //   value: 'logout',
      // ),
    ],
    onSelected: (value) {
      if (value == 'login') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
      // Puedes eliminar esta parte para quitar la lógica de "Cerrar Sesión"
      // else if (value == 'logout') {
      //   // Lógica para cerrar sesión
      //   // Puedes implementar la lógica de cierre de sesión aquí
      // }
    },
  );
}

}
