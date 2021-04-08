import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weight/core/services/weights.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'weight',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: FutureBuilder(
              future: getWeights(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Text('Yükleniyor...'))
                      ],
                    );
                  default:
                    if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    } else {
                      if (snapshot.data.first.length > 0) {
                        return ListView.separated(
                            itemBuilder: (context, index) {
                              var dates = snapshot.data.first;
                              var weightData = snapshot.data.last;
                              var difference = index == dates.length - 1
                                  ? 0.0
                                  : double.parse(weightData.elementAt(index)) -
                                      double.parse(
                                          weightData.elementAt(index + 1));
                              var differenceColor = difference == 0
                                  ? Colors.black
                                  : difference > 0
                                      ? Colors.red
                                      : Colors.green;
                              return ListTile(
                                onTap: () => ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  duration: Duration(seconds: 2),
                                  content: Text(weightData.elementAt(index)),
                                )),
                                minVerticalPadding: 2,
                                tileColor: Colors.white,
                                leading: Icon(
                                  Icons.star,
                                  color: index == dates.length - 1
                                      ? Colors.deepPurpleAccent
                                      : Colors.white,
                                  size: 40,
                                ),
                                title: Text(weightData.elementAt(index)),
                                subtitle: Text(dates.elementAt(index)),
                                trailing: Text(
                                  '${difference.toStringAsFixed(1)} kg',
                                  style: TextStyle(color: differenceColor),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(),
                            itemCount: snapshot.data.first.length);
                      } else {
                        return Text('Kilo ekle');
                      }
                    }
                }
              },
            )),
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
                    setWeight(
                        selectedDate.toLocal().toString().split(' ').first,
                        lastWeight.toString());
                    setState(() {});
                    Navigator.pop(context);
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
