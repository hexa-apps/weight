import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ŞÜŞKO',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Image(image: AssetImage('assets/png/undraw_profile_6l1l.png')),
      ),
    );
  }
}
