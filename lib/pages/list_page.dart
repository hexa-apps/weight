import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:weight/core/data/constants.dart';
import 'package:weight/pages/weight_edit_page.dart';
import 'package:weight/widgets/history_card.dart';
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
      body: Center(
        child: Container(
            color: darkColors['secondary'],
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
                                            color: darkColors['textSecondary']),
                                      ),
                                    )
                                  ],
                                ));
                              },
                              appearance: CircularSliderAppearance(
                                  size:
                                      MediaQuery.of(context).size.width * 0.60,
                                  customColors: CustomSliderColors(
                                      dotColor: darkColors['textSecondary'],
                                      progressBarColors: [
                                        darkColors['textSecondary'],
                                        Colors.lightBlueAccent,
                                        Colors.deepPurpleAccent[700],
                                      ],
                                      trackColor: darkColors['primary']),
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
                        ]);
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
}
