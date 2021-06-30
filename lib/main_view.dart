import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weight/pages/graphic_page.dart';
import 'package:weight/pages/history_page.dart';
// import 'package:weight/pages/home_page.dart';
import 'package:weight/pages/list_page.dart';
import 'package:weight/pages/settings_page.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentPage = 0;
  final pageOptions = [
    /*HomePage(), GraphicPage(),*/
    HistoryPage(),
    ListPage(),
    SettingsPage()
  ];

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
        backgroundColor: Color(0xff020826),
        unselectedItemColor: Colors.blueGrey[200].withOpacity(0.35),
        selectedItemColor: currentPage == 0
            ? Colors.greenAccent
            : currentPage == 1
                ? Colors.orangeAccent
                : Colors.deepPurpleAccent,
        showSelectedLabels: true,
        currentIndex: currentPage,
        items: [
          BottomNavigationBarItem(
              label: 'History',
              icon: Icon(CupertinoIcons.gobackward),
              activeIcon: Icon(CupertinoIcons.gobackward)),
          // BottomNavigationBarItem(
          //     label: 'Anasayfa',
          //     icon: Icon(CupertinoIcons.house),
          //     activeIcon: Icon(
          //       CupertinoIcons.house_fill,
          //       color: Colors.greenAccent,
          //     )),
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
