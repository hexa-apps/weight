import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  double lastWeight = 95.0;
  TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'weight',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Container(
            child: Text(selectedDate.toLocal().toString().split(' ').first)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () => buildShowDialog(context),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future buildShowDialog(BuildContext context) {
    weightController.text = lastWeight.toString();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Kilo',
            ),
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
                fontSize: 24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: weightController,
                  decoration: InputDecoration(
                      labelText: 'Enter your weight',
                      labelStyle: TextStyle(color: Colors.deepPurpleAccent),
                      border: UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.deepPurpleAccent)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.deepPurpleAccent, width: 1.5),
                      )),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                  ], // Only numbers can be entered
                  onChanged: (value) => weightValueChanged(value),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => setDate(),
                  child: Text(
                    selectedDate.toLocal().toString().split(' ').first,
                    style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold),
                  )),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Vazgeç',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    print('tamam');
                    print(weightController.text);
                  },
                  child: Text(
                    'Tamam',
                    style: TextStyle(color: Colors.deepPurpleAccent),
                  )),
            ],
          );
        });
  }

  void weightValueChanged(String value) {
    if (value.isNotEmpty) {
      if (value.split('.').length <= 2) {
        if (value.substring(0, 1) == '.') {
          value = '0$value';
        } else if (value.substring(value.length - 1) == '.') {
          value = '${value}0';
        }
      } else {
        value = lastWeight.toString();
      }
    } else {
      value = '0';
    }
    setState(() => lastWeight = double.parse(value));
    print(lastWeight);
  }

  void setDate() async {
    Navigator.pop(context);
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
    await buildShowDialog(context);
  }
}
