import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  final String title;
  final List<dynamic> dates;
  final List<double> weights;
  final double width;

  const StoryCard({Key key, this.dates, this.weights, this.title, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        margin: EdgeInsets.fromLTRB(12, 8, 12, 8),
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.25),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Color(0xFF0A1640),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: getStory()),
            )));
  }

  List<Widget> getStory() {
    List<Widget> widgets;
    widgets = [
      Container(
        margin: EdgeInsets.only(top: 16),
        child: Text(
          '$title Story',
          style: TextStyle(color: Colors.white),
        ),
      )
    ];
    dates.forEach((element) {
      widgets.add(ListTile(
        minVerticalPadding: 1,
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
        subtitle: Text(
          element.toString(),
          style: TextStyle(color: Colors.white30, fontSize: 10),
        ),
        title: Text(
          '${weights.elementAt(dates.indexOf(element)).toStringAsFixed(1)} kg',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        trailing: Icon(
          CupertinoIcons.right_chevron,
          color: Colors.white30,
        ),
      ));
    });
    widgets.add(TextButton(
      onPressed: () => print('all'),
      child: Text(
        'See all history',
        style: TextStyle(color: Colors.tealAccent),
      ),
    ));
    return widgets;
  }
}
