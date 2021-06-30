import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:weight/core/class/time_series_weight.dart';

class ChartCard extends StatelessWidget {
  final List<charts.Series<TimeSeriesWeight, DateTime>> sampleData;
  final double height;
  final double width;

  const ChartCard({Key key, this.sampleData, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(12, 8, 12, 8),
        width: width,
        height: height,
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Color(0xFF0A1640),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.stop,
                        size: 20,
                        color: Colors.green.withOpacity(0.75),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        'Mean',
                        style: TextStyle(color: Colors.white60, fontSize: 10),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Icon(
                        Icons.stop,
                        size: 20,
                        color: Colors.red.withOpacity(0.75),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        'Goal',
                        style: TextStyle(color: Colors.white60, fontSize: 10),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Icon(
                        Icons.stop,
                        size: 20,
                        color: Colors.indigoAccent,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        'Weight',
                        style: TextStyle(color: Colors.white60, fontSize: 10),
                      ),
                    ],
                  )),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: charts.TimeSeriesChart(
                    sampleData,
                    animate: false,
                    primaryMeasureAxis: charts.NumericAxisSpec(
                        renderSpec: charts.GridlineRendererSpec(
                            lineStyle: charts.LineStyleSpec(
                                color: charts.ColorUtil.fromDartColor(
                                    Colors.white12)),
                            labelStyle: charts.TextStyleSpec(
                                fontSize: 12,
                                color: charts.ColorUtil.fromDartColor(
                                    Colors.white30))),
                        showAxisLine: false,
                        tickProviderSpec: charts.BasicNumericTickProviderSpec(
                            desiredTickCount: 5, zeroBound: false)),
                    domainAxis: charts.DateTimeAxisSpec(
                        renderSpec: charts.GridlineRendererSpec(
                            lineStyle: charts.LineStyleSpec(
                                color: charts.ColorUtil.fromDartColor(
                                    Colors.white12)),
                            labelStyle: charts.TextStyleSpec(
                                fontSize: 12,
                                color: charts.ColorUtil.fromDartColor(
                                    Colors.white30))),
                        showAxisLine: false),
                    defaultRenderer: charts.LineRendererConfig(),
                    customSeriesRenderers: [
                      charts.PointRendererConfig(
                          customRendererId: 'customPoint')
                    ],
                    dateTimeFactory: const charts.LocalDateTimeFactory(),
                    behaviors: [charts.PanAndZoomBehavior()],
                  ),
                ),
              ),
            ])));
  }
}
