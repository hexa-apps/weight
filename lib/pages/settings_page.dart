import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../core/services/weights.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double goalWeight = 95.0;

  @override
  void initState() {
    getGoalWeight();
    super.initState();
  }

  Future getGoalWeight() async {
    var box = Hive.box('goal');
    var goal = await box.get('goalWeight');
    if (goal is double) {
      goalWeight = goal;
    }
    setState(() {});
  }

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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Genel'),
            ListTile(
              title: Text('Hedeflenen kilo'),
              // onTap: () => _showDoubleDialog(),
            )
          ],
        ),
      ),
    );
  }
}
