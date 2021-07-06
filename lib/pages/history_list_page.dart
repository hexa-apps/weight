import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight/core/services/weights.dart';

import 'weight_edit_page.dart';

class HistoryListPage extends StatefulWidget {
  final String title;

  HistoryListPage({Key key, this.title}) : super(key: key);

  @override
  _HistoryListPageState createState() => _HistoryListPageState();
}

class _HistoryListPageState extends State<HistoryListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff010D33),
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff010D33),
              elevation: 0,
              centerTitle: true,
              title: Text('All Weights'),
            ),
            body: Center(
              child: Container(
                  color: Color(0xff010D33),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: FutureBuilder(
                      future: getWeights(true, 2),
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
                                // var goal = snapshot.data.last.first;
                                List<double> weightData = snapshot.data
                                    .elementAt(1)
                                    .map<double>(
                                        (weight) => double.parse(weight))
                                    .toList();
                                return Container(
                                  margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0xFF0A1640),
                                  ),
                                  child: ListView.builder(
                                      itemCount: dates.length,
                                      itemBuilder:
                                          (BuildContext ctxt, int index) {
                                        return ListTile(
                                            trailing: Icon(
                                              CupertinoIcons.right_chevron,
                                              color: Colors.white30,
                                            ),
                                            dense: true,
                                            title: Text(
                                              weightData
                                                  .elementAt(index)
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            subtitle: Text(
                                                dates.elementAt(index),
                                                style: TextStyle(
                                                    color: Colors.white54)),
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          WeightEditPage(
                                                    fromEdit: true,
                                                    goalWeight: weightData
                                                        .elementAt(index),
                                                    date:
                                                        dates.elementAt(index),
                                                  ),
                                                ))
                                                .then((value) =>
                                                    setState(() {})));
                                      }),
                                );
                              } else {
                                return Text('Kilo ekle');
                              }
                            }
                        }
                      })),
            )),
      ),
    );
  }
}
