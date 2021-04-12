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
                        var weightData = snapshot.data.last;
                        return charts.TimeSeriesChart(
                          _createSampleData(dates, weightData),
                          animate: false,
                          defaultRenderer: charts.LineRendererConfig(),
                          customSeriesRenderers: [
                            charts.PointRendererConfig(
                                customRendererId: 'customPoint')
                          ],
                          dateTimeFactory: const charts.LocalDateTimeFactory(),
                        );
                      } else {
                        return Text('Kilo ekle');
                      }
                    }
                }
              },
            )));
  }

  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(
      dates, weightData) {
    var desktopSalesData = <TimeSeriesSales>[];
    var tableSalesData = <TimeSeriesSales>[];
    var mobileSalesData = <TimeSeriesSales>[];
    for (var i = 0; i < dates.length; i++) {
      desktopSalesData.add(TimeSeriesSales(
          DateTime(
              int.parse(dates.elementAt(i).split('-').first),
              int.parse(dates.elementAt(i).split('-').elementAt(1)),
              int.parse(dates.elementAt(i).split('-').last)),
          double.parse(weightData.elementAt(i))));
      tableSalesData.add(TimeSeriesSales(
          DateTime(
              int.parse(dates.elementAt(i).split('-').first),
              int.parse(dates.elementAt(i).split('-').elementAt(1)),
              int.parse(dates.elementAt(i).split('-').last)),
          double.parse(weightData.elementAt(i))));
      mobileSalesData.add(TimeSeriesSales(
          DateTime(
              int.parse(dates.elementAt(i).split('-').first),
              int.parse(dates.elementAt(i).split('-').elementAt(1)),
              int.parse(dates.elementAt(i).split('-').last)),
          double.parse(weightData.elementAt(i))));
    }
    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: tableSalesData,
      ),
      charts.Series<TimeSeriesSales, DateTime>(
          id: 'Mobile',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: mobileSalesData)
        // Configure our custom point renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customPoint'),
    ];
  }
}

class TimeSeriesSales {
  final DateTime time;
  final double sales;

  TimeSeriesSales(this.time, this.sales);
}
