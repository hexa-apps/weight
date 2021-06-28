import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

void setWeight(String key, String value) async {
  var box = Hive.box('weights');
  await box.put(key, value);
}

void setGoalWeight(double value) async {
  var box = Hive.box('goal');
  await box.put('goalWeight', value);
}

Future<List<List>> getWeights(bool isGoal) async {
  var goal = 0.0;
  var box = Hive.box('weights');
  var values = [];
  if (isGoal) {
    var goalBox = Hive.box('goal');
    var goalHive = await goalBox.get('goalWeight');
    if (goalHive is double) {
      goal = goalHive;
    }
  }
  if (box.isNotEmpty) {
    var keys = box.keys.toList()
      ..sort((a, b) => DateTime(
              int.parse(b.split('-').first),
              int.parse(b.split('-').elementAt(1)),
              int.parse(b.split('-').last))
          .compareTo(DateTime(
              int.parse(a.split('-').first),
              int.parse(a.split('-').elementAt(1)),
              int.parse(a.split('-').last))));
    keys.forEach((element) {
      values.add(box.toMap()[element]);
    });
    return [
      keys,
      values,
      [goal]
    ];
  } else {
    return [
      [],
      values,
      [goal]
    ];
  }
}

void deleteWeight(String key) async {
  var box = Hive.box('weights');
  await box.delete(key);
}

double getInitialValue(double first, double last, double goal) {
  return ((first - last) * 100) / (first - goal);
}

List getBMI(double height, double weight) {
  var bmi = weight / (height * height);
  var bmiText = 'Underweight';
  var bmiColor = Colors.blue;
  if (bmi > 35) {
    bmiText = 'Extremely obese';
    bmiColor = Colors.red;
  } else if (bmi > 29.9) {
    bmiText = 'Obese';
    bmiColor = Colors.orange;
  } else if (bmi > 24.9) {
    bmiText = 'Overweight';
    bmiColor = Colors.yellow;
  } else if (bmi > 18.5) {
    bmiText = 'Normal';
    bmiColor = Colors.green;
  }
  return [bmi.toStringAsFixed(1), bmiText, bmiColor];
}
