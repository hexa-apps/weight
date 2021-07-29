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

  @override
  Widget build(BuildContext context) {
    decimalNumberPicker = NumberPicker.decimal(
        initialValue: widgetWeight,
        minValue: 0,
        maxValue: 300,
        decimalPlaces: 1,
        onChanged: _handleValueChanged);
    var title = widget.fromEdit ? 'Edit' : 'Add';
    return Container(
      color: Color(0xFFFAFAFA),
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xFF263359)),
          backgroundColor: Color(0xFFFAFAFA),
          elevation: 0,
          centerTitle: true,
          title: Text(
            '$title Weight',
            style: TextStyle(
                color: Color(0xFF263359), fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          color: Color(0xFFFAFAFA),
          child: ListView(
            children: [
              SizedBox(
                height: 8,
              ),
              ListTile(
                leading: Icon(
                  CupertinoIcons.person_circle_fill,
                  color: Color(0xFF263359).withOpacity(0.85),
                  size: 36,
                ),
                title: Text(
                  widgetWeight.toString(),
                  style: TextStyle(color: Color(0xFF263359)),
                ),
                onTap: () => _showDoubleDialog(),
                subtitle: Text(
                  'Weight',
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              ListTile(
                leading: Icon(
                  CupertinoIcons.time_solid,
                  color: Color(0xFF263359).withOpacity(0.85),
                  size: 36,
                ),
                title: Text(
                  selectedDate.toLocal().toString().split(' ').first,
                  style: TextStyle(color: Color(0xFF263359)),
                ),
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
                subtitle: Text(
                  'Date',
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.fromEdit
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(16)),
                          child: TextButton(
                            onPressed: () => _deleteButton(),
                            child: Text(
                              'Delete',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    margin: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16)),
                    child: TextButton(
                      onPressed: () => _saveButton(),
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
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
          initialDoubleValue: widgetWeight,
          title: Text('Weight'),
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
