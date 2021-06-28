import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../core/class/time_series_weight.dart';
import 'package:weight/pages/weight_edit_page.dart';
import 'package:weight/widgets/number_picker.dart';
import '../core/services/weights.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  double lastWeight = 95.0;
  double goalWeight = 95.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFCFE),
      appBar: AppBar(
        // centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 5),
            child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.deepPurpleAccent.withOpacity(0.5),
                foregroundColor: Colors.white,
                child: Icon(Icons.person)),
          )
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
            Text(
              'Home',
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
                        var dates = snapshot.data.first;
                        var goal = snapshot.data.last.first;
                        List<double> weightData = snapshot.data
                            .elementAt(1)
                            .map<double>((weight) => double.parse(weight))
                            .toList();
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Flexible(
                                  flex: 5,
                                  child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      elevation: 2,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Goal progress',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextButton(
                                                    style: ButtonStyle(
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all(Color(
                                                                    0xFF8E909B)),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Color(
                                                                    0xFFF4F6FA))),
                                                    onPressed: () =>
                                                        print('edit'),
                                                    child: Text('Edit'),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  5,
                                              child: SleekCircularSlider(
                                                  min: 0,
                                                  max: 100,
                                                  innerWidget: (double value) {
                                                    return Center(
                                                        child: Text(
                                                      'now\n${weightData.last} kg\n\nDropped ~ ${(weightData.first - weightData.last).toStringAsFixed(1)} kg',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ));
                                                  },
                                                  initialValue: getInitialValue(
                                                      weightData.first,
                                                      goal,
                                                      weightData.last),
                                                  appearance:
                                                      CircularSliderAppearance(
                                                          customColors:
                                                              CustomSliderColors(
                                                                  dotColor:
                                                                      Colors.deepPurpleAccent[
                                                                          700],
                                                                  progressBarColors: [
                                                                    Colors.deepPurpleAccent[
                                                                        700],
                                                                    Colors.purple[
                                                                        50],
                                                                  ],
                                                                  trackColor:
                                                                      Colors.grey[
                                                                          200]),
                                                          startAngle: 180,
                                                          angleRange: 180,
                                                          customWidths:
                                                              CustomSliderWidths(
                                                                  shadowWidth:
                                                                      0,
                                                                  progressBarWidth:
                                                                      8,
                                                                  trackWidth:
                                                                      8)),
                                                  onChange: null),
                                            ),
                                          ],
                                        ),
                                      ))),
                              SizedBox(
                                height: 8,
                              ),
                              Flexible(
                                  flex: 6,
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    elevation: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Statistics',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              TextButton(
                                                style: ButtonStyle(
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all(Color(
                                                                0xFF8E909B)),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Color(
                                                                0xFFF4F6FA))),
                                                onPressed: () => print('stat'),
                                                child: Text('All'),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    5 +
                                                15,
                                            child: charts.TimeSeriesChart(
                                              _createSampleData(
                                                  dates, weightData, goal),
                                              animate: false,
                                              primaryMeasureAxis: charts.NumericAxisSpec(
                                                  renderSpec: charts.GridlineRendererSpec(
                                                      labelStyle:
                                                          charts.TextStyleSpec(
                                                              fontSize: 12,
                                                              color: charts
                                                                      .ColorUtil
                                                                  .fromDartColor(
                                                                      Color(
                                                                          0xFFBCBDC5)))),
                                                  showAxisLine: false,
                                                  tickProviderSpec: charts
                                                      .BasicNumericTickProviderSpec(
                                                          desiredTickCount: 5,
                                                          zeroBound: false)),
                                              domainAxis: charts.DateTimeAxisSpec(
                                                  renderSpec: charts.SmallTickRendererSpec(
                                                      labelStyle:
                                                          charts.TextStyleSpec(
                                                              fontSize: 12,
                                                              color: charts
                                                                      .ColorUtil
                                                                  .fromDartColor(
                                                                      Color(
                                                                          0xFFBCBDC5)))),
                                                  showAxisLine: false),
                                              defaultRenderer:
                                                  charts.LineRendererConfig(),
                                              customSeriesRenderers: [
                                                charts.PointRendererConfig(
                                                    customRendererId:
                                                        'customPoint')
                                              ],
                                              dateTimeFactory: const charts
                                                  .LocalDateTimeFactory(),
                                              behaviors: [
                                                charts.PanAndZoomBehavior()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                height: 8,
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Color(0xFFF9D67D),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextButton(
                                    onPressed: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              WeightEditPage(
                                                  fromEdit: false,
                                                  goalWeight: goalWeight),
                                        ))
                                        .then((value) => setState(() {})),
                                    child: Text(
                                      'Add Weight',
                                      style: TextStyle(
                                          color: Color(0xFF232013),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                        // return ListView.separated(
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
                        //         tileColor:
                        //             Colors.deepPurpleAccent.withOpacity(0.1),
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

  List<charts.Series<TimeSeriesWeight, DateTime>> _createSampleData(
      dates, weightData, goal) {
    var desktopSalesData = <TimeSeriesWeight>[];
    var mobileSalesData = <TimeSeriesWeight>[];
    var sum = 0.0;
    weightData.forEach((a) => sum += a);
    for (var i = 0; i < dates.length; i++) {
      desktopSalesData.add(TimeSeriesWeight(
          DateTime(
              int.parse(dates.elementAt(i).split('-').first),
              int.parse(dates.elementAt(i).split('-').elementAt(1)),
              int.parse(dates.elementAt(i).split('-').last)),
          weightData.elementAt(i)));
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
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            Colors.deepPurpleAccent.withOpacity(0.8)),
        domainFn: (TimeSeriesWeight sales, _) => sales.time,
        measureFn: (TimeSeriesWeight sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      charts.Series<TimeSeriesWeight, DateTime>(
          id: 'Mobile',
          colorFn: (_, __) =>
              charts.ColorUtil.fromDartColor(Colors.deepPurpleAccent),
          domainFn: (TimeSeriesWeight sales, _) => sales.time,
          measureFn: (TimeSeriesWeight sales, _) => sales.sales,
          data: mobileSalesData)
        // Configure our custom point renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customPoint'),
    ];
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
