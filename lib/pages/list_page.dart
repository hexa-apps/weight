import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weight/pages/weight_edit_page.dart';
import 'package:weight/widgets/number_picker.dart';
import '../core/services/weights.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  DateTime selectedDate = DateTime.now();
  double lastWeight = 95.0;
  double goalWeight = 95.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFCFE),
      appBar: AppBar(
        // centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: TextStyle(fontSize: 10,color: Colors.grey[600]),
            ),
            Text(
              'History',
              style: TextStyle(color: Colors.grey[900]),
            ),
          ],
        ),
        backgroundColor: Color(0xffFAFCFE),
        elevation: 0,
      ),
      body: Center(
        child: Container(
            color: Color(0xffFAFCFE),
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: FutureBuilder(
              future: getWeights(true),
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
                        goalWeight = snapshot.data.last.first;
                        return ListView.separated(
                            itemBuilder: (context, index) {
                              var dates = snapshot.data.first;
                              var weightData = snapshot.data.elementAt(1);
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
                                dense: true,
                                onTap: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          WeightEditPage(
                                        fromEdit: true,
                                        goalWeight: double.parse(
                                            weightData.elementAt(index)),
                                        date: dates.elementAt(index),
                                      ),
                                    ))
                                    .then((value) => setState(() {})),
                                // buildEditDialog(
                                //     context,
                                //     dates.elementAt(index),
                                //     weightData.elementAt(index)),
                                tileColor: Colors.deepPurpleAccent.withOpacity(0.1),
                                leading: Icon(
                                  Icons.star,
                                  color: index == dates.length - 1
                                      ? Colors.deepPurpleAccent
                                      : Color(0xffFAFCFE),
                                  size: 36,
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
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  WeightEditPage(fromEdit: false, goalWeight: goalWeight),
            ))
            .then((value) => setState(() {})),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future buildEditDialog(BuildContext context, String date, String weight) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              date,
            ),
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
                fontSize: 24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    deleteWeight(date);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Sil',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Vazgeç',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    // setWeight(date, weightEditController.text);
                    // setState(() {});
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

  Future buildAddDialog(BuildContext context) {
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
              children: [],
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
    await buildAddDialog(context);
  }
}
