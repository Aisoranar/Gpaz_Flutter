import 'package:flutter/material.dart';
import 'package:unipaz/pages/login_page.dart';
import 'package:unipaz/tabs/firts_tab.dart';
import 'package:unipaz/tabs/fourth_tab.dart';
import 'package:unipaz/tabs/second_tab.dart';
import 'package:unipaz/tabs/third_tab.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController();
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _pageController.jumpToPage(_tabController.index);
      }
    });
  }

  Widget _buildTab(IconData icon) {
    return Tab(
      icon: Icon(
        icon,
        color: Color.fromARGB(247, 0, 51, 122),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPAZ - ALPHA'),
        actions: <Widget>[
          _buildPopupMenuButton(),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            _buildTab(Icons.home),
            _buildTab(Icons.map),
            _buildTab(Icons.location_on),
            _buildTab(Icons.group),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _tabController.index = index;
        },
        physics: NeverScrollableScrollPhysics(), // No swipe between tabs
        children: [
          FirstTab(),
          GestureDetector(
            // Disable swipe gestures in the map tab
            onHorizontalDragStart: (_) {},
            child: SecondTab(),
          ),
          ThirdTab(),
          FourthTab(),
        ],
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
    _pageController.dispose();
    super.dispose();
  }
}
