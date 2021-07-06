import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Color(0xff010D33),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 8),
        color: Color(0xff010D33),
        child: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(0xFF0A1640),
            ),
            child: ListView(
              children: [
                ListTile(
                  dense: true,
                  title: Text('Goal weight',
                      style: TextStyle(color: Colors.white)),
                  trailing: Icon(
                    CupertinoIcons.right_chevron,
                    color: Colors.white30,
                  ),
                  onTap: () => _showDoubleDialog(),
                )
              ],
            ),
          ),
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
