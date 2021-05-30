import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:weight/widgets/decimal_picker.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var goalWeight = 95.0;
  NumberPicker decimalNumberPicker;

  // void _handleValueChangedExternally(num value) {
  //   if (value != null) {
  //     setState(() => goalWeight = value);
  //     decimalNumberPicker. = value;
  //   }
  // }

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
              onTap: () => _showDoubleDialog(),
            )
          ],
        ),
      ),
    );
  }

  Future _showDoubleDialog() {
    return showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Hedef',
          ),
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
              fontSize: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: DoublePickerFormField(
              value: goalWeight,
              fieldOptions: {'min': 0, 'max': 300},
              onSaved: (val) {
                print(val);
                print('ss');
              }),
          actions: [
            // TextButton(
            //     onPressed: () => setDate(),
            //     child: Text(
            //       selectedDate.toLocal().toString().split(' ').first,
            //       style: TextStyle(
            //           color: Colors.deepPurpleAccent,
            //           fontWeight: FontWeight.bold),
            //     )),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Vazgeç',
                  style: TextStyle(color: Colors.red),
                )),
            TextButton(
                onPressed: () {
                  print('tamam');
                  // print(weightController.text);
                  // setWeight(selectedDate.toLocal().toString().split(' ').first,
                  //     lastWeight.toString());
                  // setState(() {});
                  // Navigator.pop(context);
                },
                child: Text(
                  'Tamam',
                  style: TextStyle(color: Colors.deepPurpleAccent),
                )),
          ],
        );
        // return NumberPickerDialog.decimal(
        //   minValue: 0,
        //   maxValue: 300,
        //   decimalPlaces: 1,
        //   initialDoubleValue: goalWeight,
        //   title: Text('Pick a decimal value'),
        // );
      },
    );
  }
}
