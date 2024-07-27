import 'package:flutter/material.dart';
import 'package:unipaz/pages/login_page.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.directions_bus, color: Color.fromARGB(247, 0, 51, 122)),
          onPressed: () {},
        ),
        title: Text(
          'UNIPAZ - GPAZ ',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          _buildPopupMenuButton(),
        ],
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
        color: Colors.transparent,
        child: Container(
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
            tabs: [
              _buildTab(Icons.home, 'Inicio'),
              _buildTab(Icons.location_on, 'Paradas'),
              _buildTab(Icons.map, 'Ruta'),
              _buildTab(Icons.group, 'Acerca de'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupMenuButton() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Color.fromARGB(247, 0, 51, 122)),
      onSelected: (String result) {
        if (result == 'login') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'login',
          child: Text('SOY CONDUCTOR'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
