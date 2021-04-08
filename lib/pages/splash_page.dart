import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:weight/main_view.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future splashScreen() async {
    await Hive.openBox('loginState');
    await Hive.openBox('weights');
    var box = Hive.box('loginState');
    var status = await box.get('loginStatus');
    await box.close();
    Timer(Duration(seconds: 3), () {
      if (status == 1) {
        print('ikinci falan');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
            (route) => false);
      } else {
        print('ilk kez');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
            // MaterialPageRoute(builder: (context) => IntroScreen()),
            (route) => false);
      }
    });
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    splashScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
              image: AssetImage('assets/png/undraw_healthy_options_sdo3.png')),
          // Container(
          //   decoration: null,
          //   margin: EdgeInsets.symmetric(horizontal: 10),
          //   child: Image.asset('assets/images/splash.jpeg'),
          // ),
          SizedBox(height: 20),
          SpinKitChasingDots(color: Colors.deepPurpleAccent),
        ],
      ))),
    );
  }
}
