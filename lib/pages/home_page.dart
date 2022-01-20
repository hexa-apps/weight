import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight/core/class/time_series_weight.dart';
import 'package:weight/core/services/weights.dart';
import 'package:weight/widgets/chart_card.dart';

import 'weight_edit_page.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xFFF0F9FF),
          appBar: AppBar(
            backgroundColor: Color(0xFFF0F9FF),
            title: Text(
              'Summary',
              style: TextStyle(
                  color: Color(0xFF263359).withOpacity(0.75),
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            ),
            elevation: 0,
          ),
          body: weightBoxIsEmpty()
              ? addNewWeightWidget(context)
              : summaryWidget(context)),
    );
  }

  Container summaryWidget(BuildContext context) {
    var weightSet = getWeightList(94);
    var dates = weightSet.first;
    var goal = getGoalWeigth();
    var weightData = weightSet
        .elementAt(1)
        .map<double>((weight) => double.parse(weight))
        .toList();
    var initial = weightData.last.toStringAsFixed(1);
    var current = weightData.first.toStringAsFixed(1);
    var difference = (weightData.first - weightData.last).toStringAsFixed(1);
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: ListView(
        children: [
          Card(
            elevation: 0,
            // shadowColor: Colors.grey.withOpacity(0.25),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        'Initial',
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        initial != null ? initial + ' kg' : '- kg',
                        style: TextStyle(color: Colors.grey[900], fontSize: 18),
                      )
                    ],
                  )),
                  Container(
                    width: 1,
                    height: 45,
                    color: Colors.grey.withOpacity(0.25),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        'Last',
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        current != null ? current + ' kg' : '- kg',
                        style: TextStyle(color: Colors.grey[900], fontSize: 18),
                      )
                    ],
                  )),
                  Container(
                    width: 1,
                    height: 45,
                    color: Colors.grey.withOpacity(0.25),
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        'Difference',
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        difference != null ? difference + ' kg' : '- kg',
                        style: TextStyle(
                            color: double.parse(difference) == 0
                                ? Colors.grey[900]
                                : double.parse(difference) > 0
                                    ? Colors.red
                                    : Colors.green,
                            fontSize: 18),
                      )
                    ],
                  )),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Card(
            color: Color(0xFF2F68FF).withOpacity(0.75),
            elevation: 0,
            // shadowColor: Colors.grey.withOpacity(0.25),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ListTile(
              leading: Text(
                'Add current weight',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        WeightEditPage(fromEdit: false, goalWeight: goal),
                  ))
                  .then((value) => setState(() {})),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          ChartCard(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.55,
            sampleData: _createSampleData(dates, weightData, goal),
          )
        ],
      ),
    );
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

  Center addNewWeightWidget(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Card(
          color: Color(0xFF2F68FF).withOpacity(0.75),
          elevation: 0,
          // shadowColor: Colors.grey.withOpacity(0.25),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: ListTile(
            leading: Text(
              'Add current weight',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
                  builder: (BuildContext context) => WeightEditPage(
                      fromEdit: false, goalWeight: getGoalWeigth()),
                ))
                .then((value) => setState(() {})),
          ),
        ),
      ),
    );
  }
}
