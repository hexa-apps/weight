import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:weight/pages/weight_edit_page.dart';
import 'package:weight/widgets/history_card.dart';
import 'package:weight/widgets/number_picker.dart';
import 'package:weight/widgets/pace_card.dart';
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
      // appBar: AppBar(
      //   // centerTitle: true,
      //   title: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'Overview',
      //         style: TextStyle(fontSize: 10,color: Colors.grey[600]),
      //       ),
      //       Text(
      //         'History',
      //         style: TextStyle(color: Colors.grey[900]),
      //       ),
      //     ],
      //   ),
      //   backgroundColor: Color(0xff010D33),
      //   elevation: 0,
      // ),
      body: Center(
        child: Container(
            color: Color(0xff010D33),
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: FutureBuilder(
              future: getWeights(true, 3),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Padding(
                              padding: EdgeInsets.only(top: 24),
                              child: Text('Yükleniyor...'))
                        ],
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    } else {
                      if (snapshot.data.first.length > 0) {
                        goalWeight = snapshot.data.last.first;
                        List<double> weightData = snapshot.data
                            .elementAt(1)
                            .map<double>((weight) => double.parse(weight))
                            .toList();
                        var bmiList = getBMI(1.88, weightData.first);
                        var initialValue = getInitialValue(
                            weightData.last, weightData.first, goalWeight);
                        var isThereToday = snapshot.data.first.contains(
                            DateTime.now()
                                .toLocal()
                                .toString()
                                .split(' ')
                                .first);
                        var isThereWeek = snapshot.data.first.contains(
                            DateTime.now()
                                .subtract(Duration(days: 7))
                                .toLocal()
                                .toString()
                                .split(' ')
                                .first);
                        return ListView(children: [
                          SizedBox(height: 8),
                          SleekCircularSlider(
                              min: 0,
                              max: 100,
                              initialValue: initialValue < 0
                                  ? 0
                                  : initialValue > 100
                                      ? 100
                                      : initialValue,
                              innerWidget: (double value) {
                                return Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${weightData.first} kg',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                    Text(
                                      'BMI ${bmiList.first} | ${bmiList.elementAt(1)}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white38, fontSize: 12),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                WeightEditPage(
                                                    fromEdit: false,
                                                    goalWeight: goalWeight),
                                          ))
                                          .then((value) => setState(() {})),
                                      child: Text(
                                        '+ Add weight',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.tealAccent),
                                      ),
                                    )
                                  ],
                                ));
                              },
                              appearance: CircularSliderAppearance(
                                  size:
                                      MediaQuery.of(context).size.width * 0.60,
                                  customColors: CustomSliderColors(
                                      dotColor: Colors.tealAccent,
                                      progressBarColors: [
                                        Colors.tealAccent,
                                        Colors.lightBlueAccent,
                                        Colors.deepPurpleAccent[700],
                                      ],
                                      trackColor: Color(0xFF0A1640)),
                                  startAngle: 180,
                                  angleRange: 360,
                                  customWidths: CustomSliderWidths(
                                      shadowWidth: 0,
                                      progressBarWidth: 16,
                                      trackWidth: 16)),
                              onChange: null),
                          HistoryCard(
                            title: 'Your progress',
                            subtitle_first:
                                'Progress today\n${DateTime.now().toLocal().toString().split(' ').first}',
                            subtitle_second: 'Compared with\n1  week ago',
                            content_first: isThereToday
                                ? weightData
                                        .elementAt(snapshot.data.first.indexOf(
                                            DateTime.now()
                                                .toLocal()
                                                .toString()
                                                .split(' ')
                                                .first))
                                        .toString() +
                                    ' kg'
                                : '- kg',
                            content_second: isThereToday && isThereWeek
                                ? (weightData.elementAt(snapshot.data.first
                                                .indexOf(DateTime.now()
                                                    .toLocal()
                                                    .toString()
                                                    .split(' ')
                                                    .first)) -
                                            weightData.elementAt(snapshot
                                                .data.first
                                                .indexOf(DateTime.now()
                                                    .subtract(Duration(days: 7))
                                                    .toLocal()
                                                    .toString()
                                                    .split(' ')
                                                    .first)))
                                        .toString() +
                                    ' kg'
                                : '- kg',
                          ),
                          HistoryCard(
                            title: 'Your goals',
                            subtitle_first: 'I want to weight\n',
                            subtitle_second: 'You need to lose\n',
                            content_first: '${goalWeight.toString()} kg',
                            content_second:
                                '${(goalWeight - weightData.first).toStringAsFixed(1)} kg',
                          ),
                          // PaceCard(
                          //   title: 'Good job John',
                          //   sentence:
                          //       "if you keep such pace you'll hit your goal",
                          //   time: 'by June 20, 2020',
                          // )
                        ]);
                        // ListView.separated(
                        //     itemBuilder: (context, index) {
                        //       var dates = snapshot.data.first;
                        //       var weightData = snapshot.data.elementAt(1);
                        //       var difference = index == dates.length - 1
                        //           ? 0.0
                        //           : double.parse(weightData.elementAt(index)) -
                        //               double.parse(
                        //                   weightData.elementAt(index + 1));
                        //       var differenceColor = difference == 0
                        //           ? Colors.black
                        //           : difference > 0
                        //               ? Colors.red
                        //               : Colors.green;
                        //       return ListTile(
                        //         dense: true,
                        //         onTap: () => Navigator.of(context)
                        //             .push(MaterialPageRoute(
                        //               builder: (BuildContext context) =>
                        //                   WeightEditPage(
                        //                 fromEdit: true,
                        //                 goalWeight: double.parse(
                        //                     weightData.elementAt(index)),
                        //                 date: dates.elementAt(index),
                        //               ),
                        //             ))
                        //             .then((value) => setState(() {})),
                        //         // buildEditDialog(
                        //         //     context,
                        //         //     dates.elementAt(index),
                        //         //     weightData.elementAt(index)),
                        //         tileColor: Colors.deepPurpleAccent.withOpacity(0.1),
                        //         leading: Icon(
                        //           Icons.star,
                        //           color: index == dates.length - 1
                        //               ? Colors.deepPurpleAccent
                        //               : Color(0xffFAFCFE),
                        //           size: 36,
                        //         ),
                        //         title: Text(weightData.elementAt(index)),
                        //         subtitle: Text(dates.elementAt(index)),
                        //         trailing: Text(
                        //           '${difference.toStringAsFixed(1)} kg',
                        //           style: TextStyle(color: differenceColor),
                        //         ),
                        //       );
                        //     },
                        //     separatorBuilder:
                        //         (BuildContext context, int index) => Divider(),
                        //     itemCount: snapshot.data.first.length);
                      } else {
                        return Text('Kilo ekle');
                      }
                    }
                }
              },
            )),
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
