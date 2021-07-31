import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight/core/services/weights.dart';

import '../weight_edit_page.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF0F9FF),
        appBar: AppBar(
          backgroundColor: Color(0xFFF0F9FF),
          title: Text(
            'Weights',
            style: TextStyle(
                color: Color(0xFF263359).withOpacity(0.75),
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF2F68FF),
          foregroundColor: Colors.white,
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    WeightEditPage(fromEdit: false, goalWeight: 50),
              ))
              .then((value) => setState(() {})),
          child: Icon(Icons.add),
        ),
        body: FutureBuilder(
            future: getWeights(true, 94),
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
                          .map<double>((weight) => double.parse(weight))
                          .toList();
                      return Container(
                        margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                        child: ListView.builder(
                            itemCount: dates.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Container(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Card(
                                  elevation: 0,
                                  // shadowColor: Colors.grey.withOpacity(0.25),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: ListTile(
                                      leading: index == dates.length - 1
                                          ? CircleAvatar(
                                              backgroundColor:
                                                  Color(0xFF2F68FF),
                                              foregroundColor: Colors.white,
                                              child: Icon(
                                                Icons.star,
                                              ))
                                          : weightData
                                                      .elementAt(index)
                                                      .toStringAsFixed(1) ==
                                                  (weightData
                                                          .elementAt(index + 1))
                                                      .toStringAsFixed(1)
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      Colors.blueGrey,
                                                  foregroundColor: Colors.white,
                                                  child: Icon(Icons.remove),
                                                )
                                              : weightData.elementAt(index) >
                                                      weightData
                                                          .elementAt(index + 1)
                                                  ? CircleAvatar(
                                                      foregroundColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      child: Icon(
                                                          Icons.arrow_upward))
                                                  : CircleAvatar(
                                                      foregroundColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          Colors.greenAccent,
                                                      child: Icon(Icons
                                                          .arrow_downward)),
                                      trailing: Icon(
                                        CupertinoIcons.right_chevron,
                                        color: Color(0xFF263359),
                                      ),
                                      dense: true,
                                      title: Text(
                                        weightData.elementAt(index).toString(),
                                        style:
                                            TextStyle(color: Color(0xFF263359)),
                                      ),
                                      subtitle: Text(dates.elementAt(index),
                                          style:
                                              TextStyle(color: Colors.black45)),
                                      onTap: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                WeightEditPage(
                                              fromEdit: true,
                                              goalWeight:
                                                  weightData.elementAt(index),
                                              date: dates.elementAt(index),
                                            ),
                                          ))
                                          .then((value) => setState(() {}))),
                                ),
                              );
                            }),
                      );
                    } else {
                      return Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Card(
                            color: Color(0xFF2F68FF).withOpacity(0.75),
                            elevation: 0,
                            // shadowColor: Colors.grey.withOpacity(0.25),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
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
                                    builder: (BuildContext context) =>
                                        WeightEditPage(
                                            fromEdit: false, goalWeight: 50),
                                  ))
                                  .then((value) => setState(() {})),
                            ),
                          ),
                        ),
                      );
                    }
                  }
              }
            }),
      ),
    );
  }
}
