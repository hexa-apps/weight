import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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

void setWeight(String key, String value) async {
  var box = Hive.box('weights');
  await box.put(key, value);
}

void setGoalWeight(double value) async {
  var box = Hive.box('goal');
  await box.put('goalWeight', value);
}

void clearWeights() {
  var box = Hive.box('weights');
  box.clear();
}

double getGoalWeigth() {
  var box = Hive.box('goal');
  var goal = box.get('goalWeight');
  if (goal is! double) {
    return 95.0;
  }
  return goal;
}

double getWeight(String key) {
  var box = Hive.box('weights');
  return box.get(key);
}

bool weightBoxIsEmpty() {
  var box = Hive.box('weights');
  return box.isEmpty;
}

List<List> getWeightList(int time) {
  var box = Hive.box('weights');
  var values = [];
  if (box.isNotEmpty) {
    var now = DateTime.now();
    var keys = box.keys.toList()
      ..sort((a, b) => DateTime(
              int.parse(b.split('-').first),
              int.parse(b.split('-').elementAt(1)),
              int.parse(b.split('-').last))
          .compareTo(DateTime(
              int.parse(a.split('-').first),
              int.parse(a.split('-').elementAt(1)),
              int.parse(a.split('-').last))));
    if (time == 94) {
      keys.forEach((element) {
        values.add(box.toMap()[element]);
      });
      return [
        keys,
        values,
        ['Annual'],
      ];
    } else if (time == 2) {
      var now_1w = now.subtract(Duration(days: 7));
      var listOfHistory = [];
      listOfHistory.addAll(keys.where((element) {
        final date = DateTime(
            int.parse(element.split('-').first),
            int.parse(element.split('-').elementAt(1)),
            int.parse(element.split('-').last));
        return now_1w.isBefore(date);
      }).toList());
      listOfHistory.forEach((element) {
        values.add(box.toMap()[element]);
      });
      return [
        listOfHistory,
        values,
        ['Weekly'],
      ];
    } else if (time == 1) {
      var now_1m = DateTime(now.year, now.month - 1, now.day);
      var listOfHistory = [];
      listOfHistory.addAll(keys.where((element) {
        final date = DateTime(
            int.parse(element.split('-').first),
            int.parse(element.split('-').elementAt(1)),
            int.parse(element.split('-').last));
        return now_1m.isBefore(date);
      }).toList());
      listOfHistory.forEach((element) {
        values.add(box.toMap()[element]);
      });
      return [
        listOfHistory,
        values,
        ['Monthly'],
      ];
    } else {
      var now_1y = DateTime(now.year - 1, now.month, now.day);
      var listOfHistory = [];
      listOfHistory.addAll(keys.where((element) {
        final date = DateTime(
            int.parse(element.split('-').first),
            int.parse(element.split('-').elementAt(1)),
            int.parse(element.split('-').last));
        return now_1y.isBefore(date);
      }).toList());
      listOfHistory.forEach((element) {
        values.add(box.toMap()[element]);
      });
      return [
        keys,
        values,
        ['Annual'],
      ];
    }
  } else {
    return [
      [],
      values,
      ['null'],
    ];
  }
}

Future<List<List>> getWeights(bool isGoal, int time) async {
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
    var now = DateTime.now();
    var keys = box.keys.toList()
      ..sort((a, b) => DateTime(
              int.parse(b.split('-').first),
              int.parse(b.split('-').elementAt(1)),
              int.parse(b.split('-').last))
          .compareTo(DateTime(
              int.parse(a.split('-').first),
              int.parse(a.split('-').elementAt(1)),
              int.parse(a.split('-').last))));
    if (time == 94) {
      keys.forEach((element) {
        values.add(box.toMap()[element]);
      });
      return [
        keys,
        values,
        ['Annual'],
        [goal]
      ];
    } else if (time == 2) {
      var now_1w = now.subtract(Duration(days: 7));
      var listOfHistory = [];
      listOfHistory.addAll(keys.where((element) {
        final date = DateTime(
            int.parse(element.split('-').first),
            int.parse(element.split('-').elementAt(1)),
            int.parse(element.split('-').last));
        return now_1w.isBefore(date);
      }).toList());
      listOfHistory.forEach((element) {
        values.add(box.toMap()[element]);
      });
      return [
        listOfHistory,
        values,
        ['Weekly'],
        [goal]
      ];
    } else if (time == 1) {
      var now_1m = DateTime(now.year, now.month - 1, now.day);
      var listOfHistory = [];
      listOfHistory.addAll(keys.where((element) {
        final date = DateTime(
            int.parse(element.split('-').first),
            int.parse(element.split('-').elementAt(1)),
            int.parse(element.split('-').last));
        return now_1m.isBefore(date);
      }).toList());
      listOfHistory.forEach((element) {
        values.add(box.toMap()[element]);
      });
      return [
        listOfHistory,
        values,
        ['Monthly'],
        [goal]
      ];
    } else {
      var now_1y = DateTime(now.year - 1, now.month, now.day);
      var listOfHistory = [];
      listOfHistory.addAll(keys.where((element) {
        final date = DateTime(
            int.parse(element.split('-').first),
            int.parse(element.split('-').elementAt(1)),
            int.parse(element.split('-').last));
        return now_1y.isBefore(date);
      }).toList());
      listOfHistory.forEach((element) {
        values.add(box.toMap()[element]);
      });
      return [
        keys,
        values,
        ['Annual'],
        [goal]
      ];
    }
  } else {
    return [
      [],
      values,
      ['null'],
      [goal]
    ];
  }
}
