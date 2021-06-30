import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import '../core/class/time_series_weight.dart';
import '../core/services/weights.dart';

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
          elevation: 0,
          centerTitle: false,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Overview',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(
                'Home',
                style: TextStyle(color: Colors.grey[900]),
              ),
            ],
          ),
          backgroundColor: Color(0xffFAFCFE),
        ),
        body: Container(
            color: Color(0xffFAFCFE),
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: FutureBuilder(
              future: getWeights(true, 3),
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
                        var goal = snapshot.data.last.first;
                        List<double> weightData = snapshot.data
                            .elementAt(1)
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
                                    Expanded(
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 4),
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          color: Colors.blue[600]
                                              .withOpacity(0.85),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Başlangıç',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                            Text(
                                              weightData.last.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 4),
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          color: Colors.deepPurpleAccent
                                              .withOpacity(0.85),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Şimdiki',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                            Text(
                                              weightData.first.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 4),
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          color:
                                              Colors.red[600].withOpacity(0.85),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Hedef',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                            Text(
                                              goal.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
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
                                    Text('Kilo'),
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
                                    Text('Ortalama'),
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
                                    Text('Hedef'),
                                  ],
                                )),
                            Expanded(
                              flex: 7,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: charts.TimeSeriesChart(
                                  _createSampleData(dates, weightData, goal),
                                  animate: false,
                                  primaryMeasureAxis: charts.NumericAxisSpec(
                                      tickProviderSpec:
                                          charts.BasicNumericTickProviderSpec(
                                              desiredMinTickCount: 5,
                                              desiredMaxTickCount: 15,
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
                            Expanded(
                              flex: 1,
                              child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: TextButton(
                                    onPressed: () => print('ll'),
                                    child: Text('sss'),
                                  )),
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
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesWeight sales, _) => sales.time,
        measureFn: (TimeSeriesWeight sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      charts.Series<TimeSeriesWeight, DateTime>(
        id: 'Monitor',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesWeight sales, _) => sales.time,
        measureFn: (TimeSeriesWeight sales, _) => sales.sales,
        data: monitorSalesData,
      ),
      charts.Series<TimeSeriesWeight, DateTime>(
        id: 'Tablet',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesWeight sales, _) => sales.time,
        measureFn: (TimeSeriesWeight sales, _) => sales.sales,
        data: tableSalesData,
      ),
      charts.Series<TimeSeriesWeight, DateTime>(
          id: 'Mobile',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (TimeSeriesWeight sales, _) => sales.time,
          measureFn: (TimeSeriesWeight sales, _) => sales.sales,
          data: mobileSalesData)
        // Configure our custom point renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customPoint'),
    ];
  }
}
