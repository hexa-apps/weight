import 'package:flutter/material.dart';
import 'package:weight/core/data/constants.dart';

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
    return Container(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.25),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.fromLTRB(12, 8, 12, 8),
        color: darkColors['primary'],
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              title ?? 'Title',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      subtitle_first ?? 'subtitle',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 9, color: Colors.white38),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(content_first ?? 'subcontent',
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      subtitle_second ?? 'subtitle',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white38,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(content_second ?? 'subcontent',
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ],
          )
        ]),
      ),
    );
  }
}
