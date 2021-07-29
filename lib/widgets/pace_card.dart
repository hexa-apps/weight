import 'package:flutter/material.dart';
import 'package:weight/core/data/constants.dart';

class PaceCard extends StatelessWidget {
  final String title;
  final String time;
  final String sentence;
  const PaceCard({Key key, this.title, this.time, this.sentence})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.25),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: EdgeInsets.fromLTRB(12, 8, 12, 8),
            color: darkColors['primary'],
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  title ?? 'Title',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  sentence ?? 'sentence',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white60)),
                child: Text(
                  time ?? 'time',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ])));
  }
}
