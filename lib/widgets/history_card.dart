import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  final String title;
  final String subtitle_first;
  final String subtitle_second;
  final String content_first;
  final String content_second;

  const HistoryCard(
      {Key key,
      this.title,
      this.subtitle_first,
      this.subtitle_second,
      this.content_first,
      this.content_second})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.fromLTRB(12, 8, 12, 8),
      color: Colors.white10,
      child: Column(children: [
        Text(
          title ?? 'Title',
          style: TextStyle(color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  subtitle_first ?? 'subtitle',
                  style: TextStyle(fontSize: 8, color: Colors.white38),
                ),
                Text(content_first ?? 'subcontent',
                    style: TextStyle(color: Colors.white))
              ],
            ),
            Column(
              children: [
                Text(
                  subtitle_second ?? 'subtitle',
                  style: TextStyle(fontSize: 8, color: Colors.white38),
                ),
                Text(content_second ?? 'subcontent',
                    style: TextStyle(color: Colors.white))
              ],
            ),
          ],
        )
      ]),
    );
  }
}
