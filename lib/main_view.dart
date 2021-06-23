import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weight/pages/graphic_page.dart';
import 'package:weight/pages/home_page.dart';
import 'package:weight/pages/settings_page.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentPage = 0;
  final pageOptions = [GraphicPage(), HomePage(), SettingsPage()];

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageOptions.elementAt(currentPage),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        onTap: (int index) => {
          setState(() {
            currentPage = index;
          })
        },
        backgroundColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.blueGrey[200],
        selectedItemColor: Colors.white,
        showSelectedLabels: true,
        currentIndex: currentPage,
        items: [
          BottomNavigationBarItem(
              label: 'Grafik',
              icon: Icon(Icons.insert_chart_outlined),
              activeIcon: Icon(Icons.insert_chart)),
          BottomNavigationBarItem(
              label: 'Liste',
              icon: Icon(Icons.list_alt),
              activeIcon: Icon(Icons.view_list)),
          BottomNavigationBarItem(
              label: 'Profil',
              icon: Icon(Icons.person_pin_outlined),
              activeIcon: Icon(Icons.person_pin_sharp))
        ],
      ),
    );
  }
}
