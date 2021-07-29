import 'package:flutter/material.dart';
import 'package:weight/core/data/constants.dart';

class SummaryCard extends StatelessWidget {
  final String initial;
  final String current;
  final String difference;
  final Color textColor;

  const SummaryCard(
      {Key key, this.initial, this.current, this.difference, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.25),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: darkColors['primary'],
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Summary',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      'Initial',
                      style: TextStyle(color: Colors.blue, fontSize: 10),
                    ),
                    SizedBox(height: 4),
                    Text(
                      initial != null ? initial + ' kg' : '- kg',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )
                  ],
                )),
                Container(
                  width: 1,
                  height: 25,
                  color: Colors.grey.withOpacity(0.25),
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      'Current',
                      style: TextStyle(
                          color: darkColors['textSecondary'], fontSize: 10),
                    ),
                    SizedBox(height: 4),
                    Text(
                      current != null ? current + ' kg' : '- kg',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )
                  ],
                )),
                Container(
                  width: 1,
                  height: 25,
                  color: Colors.grey.withOpacity(0.25),
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      'Difference',
                      style: TextStyle(color: Colors.orange, fontSize: 10),
                    ),
                    SizedBox(height: 4),
                    Text(
                      difference != null ? difference + ' kg' : '- kg',
                      style: TextStyle(color: textColor, fontSize: 18),
                    )
                  ],
                )),
              ],
            )
          ])),
    );
  }
}
