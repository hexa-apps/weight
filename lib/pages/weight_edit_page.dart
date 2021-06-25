import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight/core/services/weights.dart';
import '../widgets/number_picker.dart';

class WeightEditPage extends StatefulWidget {
  final double goalWeight;
  @required
  final bool fromEdit;
  final String date;
  WeightEditPage({
    Key key,
    this.goalWeight,
    this.fromEdit,
    this.date,
  }) : super(key: key);

  @override
  _WeightEditPageState createState() => _WeightEditPageState();
}

class _WeightEditPageState extends State<WeightEditPage> {
  NumberPicker decimalNumberPicker;
  DateTime selectedDate;
  double widgetWeight;
  // var alala;

  @override
  void initState() {
    // getGoalWeight();
    widgetWeight = widget.goalWeight;
    selectedDate =
        widget.date != null ? DateTime.tryParse(widget.date) : DateTime.now();
    super.initState();
  }

  // Future getGoalWeight() async {
  //   var box = Hive.box('weights');
  //   if (box.isNotEmpty) {
  //     var keys = box.keys.toList()
  //       ..sort((a, b) => DateTime(
  //               int.parse(b.split('-').first),
  //               int.parse(b.split('-').elementAt(1)),
  //               int.parse(b.split('-').last))
  //           .compareTo(DateTime(
  //               int.parse(a.split('-').first),
  //               int.parse(a.split('-').elementAt(1)),
  //               int.parse(a.split('-').last))));
  //     alala = keys;
  //   } else {
  //     alala = [];
  //   }
  //   setState(() {});
  // }

  void _saveButton() {
    if (widget.fromEdit) {
      deleteWeight(widget.date);
    }
    setWeight(selectedDate.toLocal().toString().split(' ').first,
        widgetWeight.toString());
    Navigator.of(context).pop();
  }

  void _deleteButton() {
    deleteWeight(widget.date);
    Navigator.of(context).pop();
  }

  // bool _predicate(DateTime day) {
  //   if (alala.contains(day.toLocal().toString().split(' ').first)) {
  //     return false;
  //   }
  //   return true;
  // }

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
              widget.fromEdit
                  ? Container(
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16)),
                      child: IconButton(
                          icon: Icon(CupertinoIcons.trash_fill),
                          onPressed: () => _deleteButton()),
                    )
                  : Container(),
              Container(
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Colors.lightGreenAccent.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16)),
                child: IconButton(
                    icon: Icon(CupertinoIcons.checkmark_alt),
                    onPressed: () => _saveButton()),
              ),
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
                      lastDate: DateTime.now().add(Duration(days: 7)),
                      // selectableDayPredicate: _predicate
                    );
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
