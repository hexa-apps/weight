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
              onTap: () => _showDoubleDialog(),
            )
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
          confirmLabel: 'Tamam',
          cancelLabel: 'Vazgeç',
          minValue: 0,
          maxValue: 300,
          decimalPlaces: 1,
          initialDoubleValue: goalWeight,
          title: Text('Hedef'),
        );
      },
    ).then(_handleValueChangedExternally);
  }
}
