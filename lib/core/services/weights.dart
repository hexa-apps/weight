import 'package:hive/hive.dart';

void setWeight(String key, String value) async {
  var box = Hive.box('weights');
  await box.put(key, value);
}

Future<List<List>> getWeights() async {
  var box = Hive.box('weights');
  var values = [];
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
    return [keys, values];
  } else {
    return [[], values];
  }
}

void deleteWeight(String key) async {
  var box = Hive.box('weights');
  await box.delete(key);
}
