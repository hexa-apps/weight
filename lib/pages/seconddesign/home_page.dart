import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        appBar: AppBar(
          backgroundColor: Color(0xFFFAFAFA),
          title: Text(
            'Summary',
            style: TextStyle(
                color: Color(0xFF263359), fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: Center(
          child: Text(
            '96 kg',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
