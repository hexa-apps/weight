import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:weight/core/services/weights.dart';

class GraphicPage extends StatefulWidget {
  @override
  _GraphicPageState createState() => _GraphicPageState();
}

class _GraphicPageState extends State<GraphicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'ŞÜŞKO',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Container(
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
                        var dates = snapshot.data.first;
                        List<double> weightData = snapshot.data.last
                            .map<double>((weight) => double.parse(weight))
                            .toList();
                        return Column(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('First'),
                                        Text(weightData.first.toString()),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Now'),
                                        Text(weightData.last.toString()),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Goal'),
                                        Text('sss'),
                                      ],
                                    ),
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.stop,
                                      size: 20,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text('Weight'),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Icon(
                                      Icons.stop,
                                      size: 20,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text('Mean'),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Icon(
                                      Icons.stop,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text('Goal'),
                                  ],
                                )),
                            Expanded(
                              flex: 7,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: charts.TimeSeriesChart(
                                  _createSampleData(dates, weightData),
                                  animate: false,
                                  primaryMeasureAxis: charts.NumericAxisSpec(
                                      tickProviderSpec:
                                          charts.BasicNumericTickProviderSpec(
                                              zeroBound: false)),
                                  defaultRenderer: charts.LineRendererConfig(),
                                  customSeriesRenderers: [
                                    charts.PointRendererConfig(
                                        customRendererId: 'customPoint')
                                  ],
                                  dateTimeFactory:
                                      const charts.LocalDateTimeFactory(),
                                  behaviors: [charts.PanAndZoomBehavior()],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Text('Kilo ekle');
                      }
                    }
                }
              },
            )));
  }

  List<charts.Series<TimeSeriesWeight, DateTime>> _createSampleData(
      dates, weightData) {
    var desktopSalesData = <TimeSeriesWeight>[];
    // var tableSalesData = <TimeSeriesWeight>[];
    var mobileSalesData = <TimeSeriesWeight>[];
    for (var i = 0; i < dates.length; i++) {
      desktopSalesData.add(TimeSeriesWeight(
          DateTime(
              int.parse(dates.elementAt(i).split('-').first),
              int.parse(dates.elementAt(i).split('-').elementAt(1)),
              int.parse(dates.elementAt(i).split('-').last)),
          weightData.elementAt(i)));
      // tableSalesData.add(TimeSeriesWeight(
      //     DateTime(
      //         int.parse(dates.elementAt(i).split('-').first),
      //         int.parse(dates.elementAt(i).split('-').elementAt(1)),
      //         int.parse(dates.elementAt(i).split('-').last)),
      //     weightData.elementAt(i)));
      mobileSalesData.add(TimeSeriesWeight(
          DateTime(
              int.parse(dates.elementAt(i).split('-').first),
              int.parse(dates.elementAt(i).split('-').elementAt(1)),
              int.parse(dates.elementAt(i).split('-').last)),
          weightData.elementAt(i)));
    }
    return [
      charts.Series<TimeSeriesWeight, DateTime>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesWeight sales, _) => sales.time,
        measureFn: (TimeSeriesWeight sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      // charts.Series<TimeSeriesWeight, DateTime>(
      //   id: 'Tablet',
      //   colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      //   domainFn: (TimeSeriesWeight sales, _) => sales.time,
      //   measureFn: (TimeSeriesWeight sales, _) => sales.sales,
      //   data: tableSalesData,
      // ),
      charts.Series<TimeSeriesWeight, DateTime>(
          id: 'Mobile',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (TimeSeriesWeight sales, _) => sales.time,
          measureFn: (TimeSeriesWeight sales, _) => sales.sales,
          data: mobileSalesData)
        // Configure our custom point renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customPoint'),
    ];
  }
}

class TimeSeriesWeight {
  final DateTime time;
  final double sales;

  TimeSeriesWeight(this.time, this.sales);
}
