import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight/core/services/weights.dart';
import 'package:weight/pages/home_page.dart';
import '../widgets/number_picker.dart';

class WeightEditPage extends StatefulWidget {
  final double goalWeight;
  WeightEditPage({Key key, this.goalWeight}) : super(key: key);

  @override
  _WeightEditPageState createState() => _WeightEditPageState();
}

class _WeightEditPageState extends State<WeightEditPage> {
  NumberPicker decimalNumberPicker;
  DateTime selectedDate = DateTime.now();
  double widgetWeight;

  @override
  void initState() {
    widgetWeight = widget.goalWeight;
    super.initState();
  }

  void _saveButton() {
    setWeight(selectedDate.toLocal().toString().split(' ').first,
        widgetWeight.toString());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    decimalNumberPicker = NumberPicker.decimal(
        initialValue: widgetWeight,
        minValue: 0,
        maxValue: 300,
        decimalPlaces: 1,
        onChanged: _handleValueChanged);
    return Container(
        color: Colors.deepPurpleAccent,
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            elevation: 0,
            centerTitle: true,
            actions: [
              Container(
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(16)),
                child: IconButton(
                    icon: Icon(CupertinoIcons.checkmark_alt),
                    onPressed: () => _saveButton()),
              )
            ],
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(
                    CupertinoIcons.person_circle_fill,
                    color: Colors.deepPurpleAccent,
                  ),
                  title: Text(widgetWeight.toString()),
                  onTap: () => _showDoubleDialog(),
                  subtitle: Text('Kilo'),
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.time_solid,
                    color: Colors.deepPurpleAccent,
                  ),
                  title:
                      Text(selectedDate.toLocal().toString().split(' ').first),
                  onTap: () async {
                    final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2015),
                        lastDate: DateTime.now());
                    if (![null, DateTime.now()].contains(picked)) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  subtitle: Text('Tarih'),
                ),
              ],
            ),
          ),
        )));
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
          initialDoubleValue: widgetWeight,
          title: Text('Hedef'),
        );
      },
    ).then(_handleValueChangedExternally);
  }

  void _handleValueChangedExternally(num value) {
    if (value != null) {
      print(value);
      setState(() => widgetWeight = value);
      // setGoalWeight(value);
      decimalNumberPicker.animateDecimalAndInteger(value);
    }
  }

  void _handleValueChanged(num value) {
    if (value != null) {
      //`setState` will notify the framework that the internal state of this object has changed.
      setState(() => widgetWeight = value);
    }
  }
}
