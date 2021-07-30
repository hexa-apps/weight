import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weight/pages/seconddesign/home_page.dart';
import 'package:weight/pages/seconddesign/list_page.dart';
import 'package:weight/pages/settings_page.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentPage = 0;
  final pageOptions = [HomePage(), ListPage(), SettingsPage()];

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
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFF0F9FF),
        unselectedItemColor: Color(0xFFB7B8C1),
        selectedItemColor: Color(0xFF2F68FF),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentPage,
        items: [
          BottomNavigationBarItem(
            label: 'History',
            icon: Icon(Icons.home_filled),
          ),
          BottomNavigationBarItem(
            label: 'Liste',
            icon: Icon(CupertinoIcons.square_list_fill),
          ),
          BottomNavigationBarItem(
              label: 'Profil', icon: Icon(CupertinoIcons.person_fill))
        ],
      ),
    );
  }
}
