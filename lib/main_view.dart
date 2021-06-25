import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weight/pages/graphic_page.dart';
import 'package:weight/pages/home_page.dart';
import 'package:weight/pages/list_page.dart';
import 'package:weight/pages/settings_page.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentPage = 0;
  final pageOptions = [HomePage(), GraphicPage(), ListPage(), SettingsPage()];

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
        backgroundColor: Color(0xffFAFCFE),
        unselectedItemColor: Colors.blueGrey[200],
        selectedItemColor: Colors.deepPurpleAccent,
        showSelectedLabels: false,
        currentIndex: currentPage,
        items: [
          BottomNavigationBarItem(
              label: 'Anasayfa',
              icon: Icon(CupertinoIcons.house),
              activeIcon: Icon(CupertinoIcons.house_fill)),
          BottomNavigationBarItem(
              label: 'Grafik',
              icon: Icon(CupertinoIcons.chart_bar_square),
              activeIcon: Icon(CupertinoIcons.chart_bar_square_fill)),
          BottomNavigationBarItem(
              label: 'Liste',
              icon: Icon(CupertinoIcons.square_list),
              activeIcon: Icon(CupertinoIcons.square_list_fill)),
          BottomNavigationBarItem(
              label: 'Profil',
              icon: Icon(CupertinoIcons.person),
              activeIcon: Icon(CupertinoIcons.person_fill))
        ],
      ),
    );
  }
}
