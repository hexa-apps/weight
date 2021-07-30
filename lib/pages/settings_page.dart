import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:weight/core/data/constants.dart';
import '../core/services/weights.dart';
import '../widgets/number_picker.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double goalWeight = 95.0;
  NumberPicker decimalNumberPicker;

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

  void _handleValueChanged(num value) {
    if (value != null) {
      //`setState` will notify the framework that the internal state of this object has changed.
      setState(() => goalWeight = value);
    }
  }

  void _handleValueChangedExternally(num value) {
    if (value != null) {
      print(value);
      setState(() => goalWeight = value);
      setGoalWeight(value);
      decimalNumberPicker.animateDecimalAndInteger(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    decimalNumberPicker = NumberPicker.decimal(
        initialValue: goalWeight,
        minValue: 0,
        maxValue: 300,
        decimalPlaces: 1,
        onChanged: _handleValueChanged);
    return Scaffold(
      backgroundColor: Color(0xFFF0F9FF),
      appBar: AppBar(
        backgroundColor: Color(0xFFF0F9FF),
        title: Text(
          'Settings',
          style: TextStyle(
              color: Color(0xFF263359).withOpacity(0.75),
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: ListView(
          children: [
            Card(
              color: Color(0xFFF0F9FF),
              elevation: 0,
              child: ListTile(
                title: Text(
                  'Profile',
                ),
              ),
            ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Goal weight',
                    style: TextStyle(color: Color(0xFF263359), fontSize: 16)),
                trailing: Icon(
                  CupertinoIcons.right_chevron,
                  color: Color(0xFF263359),
                ),
                onTap: () => _showDoubleDialog(),
              ),
            ),
            Card(
              color: Color(0xFFF0F9FF),
              elevation: 0,
              child: ListTile(
                title: Text('Reminder'),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Reminder',
                    style: TextStyle(color: Colors.deepOrange, fontSize: 16)),
                trailing: Icon(
                  CupertinoIcons.alarm_fill,
                  color: Colors.deepOrange,
                ),
                onTap: () => {},
              ),
            ),
            Card(
              color: Color(0xFFF0F9FF),
              elevation: 0,
              child: ListTile(
                title: Text('Restore'),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Import CSV',
                    style: TextStyle(color: Colors.teal, fontSize: 16)),
                trailing: RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    CupertinoIcons.share_solid,
                    color: Colors.teal,
                  ),
                ),
                onTap: () => {},
              ),
            ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Export CSV',
                    style: TextStyle(color: Color(0xFF2F68FF), fontSize: 16)),
                trailing: Icon(
                  CupertinoIcons.share_solid,
                  color: Color(0xFF2F68FF),
                ),
                onTap: () => {},
              ),
            ),
            Card(
              color: Color(0xFFF0F9FF),
              elevation: 0,
              child: ListTile(
                title: Text('Delete'),
              ),
            ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Remove history',
                    style: TextStyle(color: Colors.red, fontSize: 16)),
                trailing: Icon(
                  CupertinoIcons.delete_solid,
                  color: Colors.red,
                ),
                onTap: () => {},
              ),
            ),
            Card(
              color: Color(0xFFF0F9FF),
              elevation: 0,
              child: ListTile(
                title: Text(
                  'About',
                ),
              ),
            ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Suggestions',
                    style: TextStyle(color: Color(0xFF263359), fontSize: 16)),
                trailing: Icon(
                  CupertinoIcons.mail_solid,
                  color: Color(0xFF263359),
                ),
                onTap: () => {},
              ),
            ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Share with friends',
                    style: TextStyle(color: Color(0xFF263359), fontSize: 16)),
                trailing: Icon(
                  Icons.share,
                  color: Color(0xFF263359),
                ),
                onTap: () => {},
              ),
            ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Rate/Comment',
                    style: TextStyle(color: Color(0xFF263359), fontSize: 16)),
                trailing: Icon(
                  CupertinoIcons.captions_bubble_fill,
                  color: Color(0xFF263359),
                ),
                onTap: () => {},
              ),
            ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Other apps',
                    style: TextStyle(color: Color(0xFF263359), fontSize: 16)),
                trailing: Icon(
                  CupertinoIcons.app_badge_fill,
                  color: Color(0xFF263359),
                ),
                onTap: () => {},
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Card(
                color: Color(0xFFF0F9FF),
                elevation: 0,
                child: Center(
                  child: Text(
                    'Weight Tracker 0.0.1',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _showDoubleDialog() async {
    await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return NumberPickerDialog.decimal(
          confirmLabel: 'OK',
          cancelLabel: 'Cancel',
          minValue: 0,
          maxValue: 300,
          decimalPlaces: 1,
          initialDoubleValue: goalWeight,
          title: Text('Goal'),
        );
      },
    ).then(_handleValueChangedExternally);
  }
}
