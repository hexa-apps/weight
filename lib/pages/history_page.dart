import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight/pages/history_list_page.dart';
import '../core/services/weights.dart';

import '../widgets/chart_card.dart';
import '../widgets/summary_card.dart';
import '../core/class/time_series_weight.dart';
import 'weight_edit_page.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var isSelected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffFAFCFE),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff010D33),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFF0A1640),
                ),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.85,
                height: 45,
                child: CustomToggleButtons(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width * 0.27,
                      maxWidth: MediaQuery.of(context).size.width * 0.27),
                  splashColor: Color(0xFF0A1640).withOpacity(0.5),
                  // borderWidth: 2,
                  // borderColor: Colors.white,
                  // selectedBorderColor: Color(0xFF0A1640),
                  color: Colors.white,
                  selectedColor: Colors.white,
                  fillColor: Color(0xff010D33),
                  renderBorder: false,
                  // unselectedFillColor: Color(0xFF0A1640),
                  isSelected: isSelected,
                  onPressed: (index) {
                    setState(() {
                      isSelected = [false, false, false];
                      isSelected[index] = !isSelected[index];
                    });
                  },
                  children: <Widget>[
                    Text(
                      'Week',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Month',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Year',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Center(
            child: Container(
                color: Color(0xff010D33),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: FutureBuilder(
                  future: getWeights(true, isSelected.indexOf(true)),
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
                                  child: Text('Loading...'))
                            ],
                          ),
                        );
                      default:
                        if (snapshot.hasError) {
                          return Text('Hata: ${snapshot.error}');
                        } else {
                          if (snapshot.data.first.length > 0) {
                            var dates = snapshot.data.first;
                            var goal = snapshot.data.last.first;
                            List<double> weightData = snapshot.data
                                .elementAt(1)
                                .map<double>((weight) => double.parse(weight))
                                .toList();
                            var storyTitle = snapshot.data.elementAt(2).first;
                            return ListView(children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ChartCard(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  height:
                                      MediaQuery.of(context).size.height * 0.55,
                                  sampleData: _createSampleData(
                                      dates, weightData, goal),
                                ),
                              ),
                              SummaryCard(
                                current: weightData.first.toStringAsFixed(1),
                                initial: weightData.last.toStringAsFixed(1),
                                difference: (weightData.last - weightData.first)
                                    .toStringAsFixed(1),
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  margin: EdgeInsets.fromLTRB(12, 8, 12, 8),
                                  constraints: BoxConstraints(
                                      minHeight:
                                          MediaQuery.of(context).size.height *
                                              0.25),
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      color: Color(0xFF0A1640),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: getStory(
                                                dates.length > 7
                                                    ? dates
                                                        .getRange(0, 7)
                                                        .toList()
                                                    : dates,
                                                storyTitle,
                                                dates.length > 7
                                                    ? weightData
                                                        .getRange(0, 7)
                                                        .toList()
                                                    : weightData)),
                                      )))
                            ]);
                          } else {
                            return Text('Kilo ekle');
                          }
                        }
                    }
                  },
                )
                // ListView(children: [
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(8),
                //           color: Color(0xFF0A1640),
                //         ),
                //         alignment: Alignment.center,
                //         width: MediaQuery.of(context).size.width * 0.85,
                //         height: 45,
                //         child: CustomToggleButtons(
                //           constraints: BoxConstraints(
                //               minWidth: MediaQuery.of(context).size.width * 0.27,
                //               maxWidth: MediaQuery.of(context).size.width * 0.27),
                //           splashColor: Color(0xFF0A1640).withOpacity(0.5),
                //           // borderWidth: 2,
                //           // borderColor: Colors.white,
                //           // selectedBorderColor: Color(0xFF0A1640),
                //           color: Colors.white,
                //           selectedColor: Colors.white,
                //           fillColor: Color(0xff010D33),
                //           renderBorder: false,
                //           // unselectedFillColor: Color(0xFF0A1640),
                //           isSelected: isSelected,
                //           onPressed: (index) {
                //             setState(() {
                //               isSelected = [false, false, false];
                //               isSelected[index] = !isSelected[index];
                //             });
                //           },
                //           children: <Widget>[
                //             Text(
                //               'Week',
                //               textAlign: TextAlign.center,
                //             ),
                //             Text(
                //               'Month',
                //               textAlign: TextAlign.center,
                //             ),
                //             Text(
                //               'Year',
                //               textAlign: TextAlign.center,
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                //   ChartCard(sampleData: [])
                // ]),
                )));
  }

  List<Widget> getStory(dates, title, weights) {
    List<Widget> widgets;
    widgets = [
      Container(
        margin: EdgeInsets.only(top: 16),
        child: Text(
          '$title Story',
          style: TextStyle(color: Colors.white),
        ),
      )
    ];
    dates.forEach((element) {
      widgets.add(ListTile(
        dense: true,
        minVerticalPadding: 1,
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
        subtitle: Text(
          element.toString(),
          style: TextStyle(color: Colors.white30, fontSize: 10),
        ),
        title: Text(
          '${weights.elementAt(dates.indexOf(element)).toStringAsFixed(1)} kg',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        trailing: Icon(
          CupertinoIcons.right_chevron,
          color: Colors.white30,
        ),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(
              builder: (BuildContext context) => WeightEditPage(
                fromEdit: true,
                goalWeight: weights.elementAt(dates.indexOf(element)),
                date: dates.elementAt(dates.indexOf(element)),
              ),
            ))
            .then((value) => setState(() {})),
      ));
    });
    widgets.add(TextButton(
      onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (BuildContext context) => HistoryListPage(
                    title: title,
                  )))
          .then((value) => setState(() {})),
      child: Text(
        'See all history',
        style: TextStyle(color: Colors.tealAccent),
      ),
    ));
    return widgets;
  }

  List<charts.Series<TimeSeriesWeight, DateTime>> _createSampleData(
      dates, weightData, goal) {
    var desktopSalesData = <TimeSeriesWeight>[];
    var monitorSalesData = <TimeSeriesWeight>[];
    var tableSalesData = <TimeSeriesWeight>[];
    var mobileSalesData = <TimeSeriesWeight>[];
    var sum = 0.0;
    weightData.forEach((a) => sum += a);
    var mean = sum / weightData.length;
    for (var i = 0; i < dates.length; i++) {
      desktopSalesData.add(TimeSeriesWeight(
          DateTime(
              int.parse(dates.elementAt(i).split('-').first),
              int.parse(dates.elementAt(i).split('-').elementAt(1)),
              int.parse(dates.elementAt(i).split('-').last)),
          weightData.elementAt(i)));
      monitorSalesData.add(TimeSeriesWeight(
          DateTime(
              int.parse(dates.elementAt(i).split('-').first),
              int.parse(dates.elementAt(i).split('-').elementAt(1)),
              int.parse(dates.elementAt(i).split('-').last)),
          goal));
      tableSalesData.add(TimeSeriesWeight(
          DateTime(
              int.parse(dates.elementAt(i).split('-').first),
              int.parse(dates.elementAt(i).split('-').elementAt(1)),
              int.parse(dates.elementAt(i).split('-').last)),
          mean));
      mobileSalesData.add(TimeSeriesWeight(
          DateTime(
              int.parse(dates.elementAt(i).split('-').first),
              int.parse(dates.elementAt(i).split('-').elementAt(1)),
              int.parse(dates.elementAt(i).split('-').last)),
          weightData.elementAt(i)));
    }
    return [
      charts.Series<TimeSeriesWeight, DateTime>(
        id: 'Monitor',
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Colors.red.withOpacity(0.75)),
        domainFn: (TimeSeriesWeight sales, _) => sales.time,
        measureFn: (TimeSeriesWeight sales, _) => sales.sales,
        data: monitorSalesData,
      ),
      charts.Series<TimeSeriesWeight, DateTime>(
        id: 'Tablet',
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Colors.green.withOpacity(0.75)),
        domainFn: (TimeSeriesWeight sales, _) => sales.time,
        measureFn: (TimeSeriesWeight sales, _) => sales.sales,
        data: tableSalesData,
      ),
      charts.Series<TimeSeriesWeight, DateTime>(
        id: 'Desktop',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.indigoAccent),
        domainFn: (TimeSeriesWeight sales, _) => sales.time,
        measureFn: (TimeSeriesWeight sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      charts.Series<TimeSeriesWeight, DateTime>(
          id: 'Mobile',
          colorFn: (_, __) =>
              charts.ColorUtil.fromDartColor(Colors.indigoAccent),
          domainFn: (TimeSeriesWeight sales, _) => sales.time,
          measureFn: (TimeSeriesWeight sales, _) => sales.sales,
          data: mobileSalesData)
        // Configure our custom point renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customPoint'),
    ];
  }
}
