import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:weight/core/services/my_flutter_app_icons.dart';
import '../core/services/weights.dart';
import '../widgets/number_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double goalWeight;
  int age;
  int height;
  NumberPicker decimalNumberPicker;
  NumberPicker intNumberPickerAge;
  NumberPicker intNumberPickerHeight;
  var isSelected;

  @override
  Widget build(BuildContext context) {
    decimalNumberPicker = NumberPicker.decimal(
        initialValue: getGoalWeigth(),
        minValue: 0,
        maxValue: 300,
        decimalPlaces: 1,
        onChanged: _handleValueChanged);
    intNumberPickerAge = NumberPicker.integer(
        initialValue: getAge(),
        minValue: 0,
        maxValue: 150,
        onChanged: _handleValueChangedAge);
    intNumberPickerHeight = NumberPicker.integer(
        initialValue: getHeight(),
        minValue: 0,
        maxValue: 250,
        onChanged: _handleValueChangedHeight);
    return Scaffold(
      backgroundColor: Color(0xFFF0F9FF),
      appBar: AppBar(
        backgroundColor: Color(0xFFF0F9FF),
        title: Text(
          'Settings',
          style: TextStyle(
              color: Color(0xFF263359).withOpacity(0.75),
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: ListView(
          children: [
            Card(
              color: Color(0xFFF0F9FF),
              elevation: 0,
              child: ListTile(
                title: Text(
                  'Profile',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Gender',
                    style: TextStyle(color: Color(0xFF263359), fontSize: 16)),
                trailing: ToggleButtons(
                  borderColor: Colors.white,
                  selectedBorderColor: Colors.white,
                  isSelected: isSelectedFunction(),
                  onPressed: (int index) {
                    setGender(index);
                    setState(() {
                      isSelected = [false, false];
                      isSelected[index] = !isSelected[index];
                    });
                  },
                  children: [
                    Icon(
                      MyFlutterApp.male,
                      color: Colors.blue,
                    ),
                    Icon(
                      MyFlutterApp.female,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Age',
                    style: TextStyle(color: Color(0xFF263359), fontSize: 16)),
                subtitle: Text(getAge().toString()),
                trailing: Icon(
                  CupertinoIcons.right_chevron,
                  color: Color(0xFF263359),
                ),
                onTap: () => _showDoubleDialogAge(),
              ),
            ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Height',
                    style: TextStyle(color: Color(0xFF263359), fontSize: 16)),
                subtitle: Text(getHeight().toString()),
                trailing: Icon(
                  CupertinoIcons.right_chevron,
                  color: Color(0xFF263359),
                ),
                onTap: () => _showDoubleDialogHeight(),
              ),
            ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Goal weight',
                    style: TextStyle(color: Color(0xFF263359), fontSize: 16)),
                subtitle: Text(getGoalWeigth().toStringAsFixed(1)),
                trailing: Icon(
                  CupertinoIcons.right_chevron,
                  color: Color(0xFF263359),
                ),
                onTap: () => _showDoubleDialog(),
              ),
            ),
            Card(
              color: Color(0xFFF0F9FF),
              elevation: 0,
              child: ListTile(
                title: Text(
                  'Settings',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                enabled: false,
                dense: true,
                title: Text('Reminder',
                    style: TextStyle(
                        color: Colors.grey /*deepOrange*/, fontSize: 16)),
                trailing: Icon(
                  CupertinoIcons.alarm_fill,
                  color: Colors.grey[350] /*deepOrange*/,
                ),
                onTap: () => {},
              ),
            ),
            // Card(
            //   color: Color(0xFFF0F9FF),
            //   elevation: 0,
            //   child: ListTile(
            //     title: Text(
            //       'Restore',
            //       style: TextStyle(fontSize: 14),
            //     ),
            //   ),
            // ),
            // Card(
            //   elevation: 0,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(10))),
            //   child: ListTile(
            //     dense: true,
            //     title: Text('Import CSV',
            //         style: TextStyle(color: Colors.teal, fontSize: 16)),
            //     trailing: RotatedBox(
            //       quarterTurns: 2,
            //       child: Icon(
            //         CupertinoIcons.share_solid,
            //         color: Colors.teal,
            //       ),
            //     ),
            //     onTap: () => {},
            //   ),
            // ),
            // Card(
            //   elevation: 0,
            //   // shadowColor: Colors.grey.withOpacity(0.25),
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.all(Radius.circular(10))),
            //   child: ListTile(
            //     dense: true,
            //     title: Text('Export CSV',
            //         style: TextStyle(color: Color(0xFF2F68FF), fontSize: 16)),
            //     trailing: Icon(
            //       CupertinoIcons.share_solid,
            //       color: Color(0xFF2F68FF),
            //     ),
            //     onTap: () => {},
            //   ),
            // ),
            // Card(
            //   color: Color(0xFFF0F9FF),
            //   elevation: 0,
            //   child: ListTile(
            //     title: Text(
            //       'Delete',
            //       style: TextStyle(fontSize: 14),
            //     ),
            //   ),
            // ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Remove history',
                    style: TextStyle(color: Colors.red, fontSize: 16)),
                trailing: Icon(
                  CupertinoIcons.delete_solid,
                  color: Colors.red,
                ),
                onTap: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text('Clear weights'),
                          content: Text(
                              'All weight entries will be clear. Are you sure?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('No',
                                  style: TextStyle(color: Colors.green)),
                            ),
                            TextButton(
                              onPressed: () =>
                                  {clearWeights(), Navigator.pop(context)},
                              child: Text(
                                'Yes',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                          elevation: 0,
                        )),
              ),
            ),
            Card(
              color: Color(0xFFF0F9FF),
              elevation: 0,
              child: ListTile(
                title: Text(
                  'About',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Suggestions',
                    style: TextStyle(color: Color(0xFF263359), fontSize: 16)),
                trailing: Icon(
                  CupertinoIcons.mail_solid,
                  color: Color(0xFF263359),
                ),
                onTap: () {
                  var emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'hexagameapps@gmail.com',
                      queryParameters: {'subject': 'Weight Tracker (0.0.1)'});
                  _launchURL(emailLaunchUri.toString());
                },
              ),
            ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Share with friends',
                    style: TextStyle(color: Color(0xFF263359), fontSize: 16)),
                trailing: Icon(
                  Icons.share,
                  color: Color(0xFF263359),
                ),
                onTap: () => Share.share(
                    'WeightTracker - https://play.google.com/store/apps/details?id=com.hexaapps.weight',
                    subject: 'Kilo takibi ile daha zayıf ol!'),
              ),
            ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Rate/Comment',
                    style: TextStyle(color: Color(0xFF263359), fontSize: 16)),
                trailing: Icon(
                  CupertinoIcons.captions_bubble_fill,
                  color: Color(0xFF263359),
                ),
                onTap: () => _launchURL(
                    'https://play.google.com/store/apps/details?id=com.hexaapps.weight'),
              ),
            ),
            Card(
              elevation: 0,
              // shadowColor: Colors.grey.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                dense: true,
                title: Text('Other apps',
                    style: TextStyle(color: Color(0xFF263359), fontSize: 16)),
                trailing: Icon(
                  CupertinoIcons.app_badge_fill,
                  color: Color(0xFF263359),
                ),
                onTap: () => _launchURL(
                    'https://play.google.com/store/apps/dev?id=6243426129705745004'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Card(
                color: Color(0xFFF0F9FF),
                elevation: 0,
                child: Center(
                  child: Text(
                    'Weight Tracker 0.0.1',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  List isSelectedFunction() {
    var gender = getGender();
    if (gender == 'male') {
      isSelected = [true, false];
    } else if (gender == 'female') {
      isSelected = [false, true];
    }
    setState(() {});
    return isSelected;
  }

  Future _showDoubleDialog() async {
    await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return NumberPickerDialog.decimal(
          confirmLabel: 'OK',
          cancelLabel: 'Cancel',
          minValue: 0,
          maxValue: 300,
          decimalPlaces: 1,
          initialDoubleValue: getGoalWeigth(),
          title: Text('Goal (kg)'),
        );
      },
    ).then(_handleValueChangedExternally);
  }

  void _handleValueChanged(num value) {
    if (value != null) {
      //`setState` will notify the framework that the internal state of this object has changed.
      setState(() => goalWeight = value);
    }
  }

  void _handleValueChangedExternally(num value) {
    if (value != null) {
      print(value);
      setState(() => goalWeight = value);
      setGoalWeight(value);
      decimalNumberPicker.animateDecimalAndInteger(value);
    }
  }

  Future _showDoubleDialogHeight() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return NumberPickerDialog.integer(
          confirmLabel: 'OK',
          cancelLabel: 'Cancel',
          minValue: 0,
          maxValue: 250,
          initialIntegerValue: getHeight(),
          title: Text('Height (cm)'),
        );
      },
    ).then(_handleValueChangedExternallyHeight);
  }

  void _handleValueChangedExternallyHeight(num value) {
    if (value != null) {
      print(value);
      setState(() => height = value);
      setHeight(value);
      intNumberPickerHeight.animateInt(value);
    }
  }

  void _handleValueChangedHeight(num value) {
    if (value != null) {
      //`setState` will notify the framework that the internal state of this object has changed.
      setState(() => height = value);
    }
  }

  Future _showDoubleDialogAge() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return NumberPickerDialog.integer(
          confirmLabel: 'OK',
          cancelLabel: 'Cancel',
          minValue: 0,
          maxValue: 150,
          initialIntegerValue: getAge(),
          title: Text('Age'),
        );
      },
    ).then(_handleValueChangedExternallyAge);
  }

  void _handleValueChangedExternallyAge(num value) {
    if (value != null) {
      print(value);
      setState(() => age = value);
      setAge(value);
      intNumberPickerAge.animateInt(value);
    }
  }

  void _handleValueChangedAge(num value) {
    if (value != null) {
      //`setState` will notify the framework that the internal state of this object has changed.
      setState(() => age = value);
    }
  }
}
