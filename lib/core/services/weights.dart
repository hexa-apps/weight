import 'package:hive/hive.dart';

void setWeights(String key, String value) async {
  var box = Hive.box('weights');
  await box.put(key, value);
}

Future<List<List>> getWeights() async {
  var box = Hive.box('weights');
  if (box.isNotEmpty) {
    var keys = box.keys.toList();
    var values = box.values.toList();
    return [keys, values];
  } else {
    return [[], []];
  }
}

void deleteWeight(String key) async {
  var box = Hive.box('weights');
  await box.delete(key);
}
