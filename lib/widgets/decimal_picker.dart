import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class DoublePickerFormField extends StatefulWidget {
  const DoublePickerFormField({
    Key key,
    @required this.value,
    @required this.fieldOptions,
    @required this.onSaved,
  }) : super(key: key);

  final Map<String, dynamic> fieldOptions;
  final Function onSaved;
  final double value;

  @override
  DoublePickerFormFieldState createState() {
    return DoublePickerFormFieldState();
  }
}

class DoublePickerFormFieldState extends State<DoublePickerFormField> {
  double _currentValue;

  @override
  void initState() {
    widget.value == null
        ? _currentValue = widget.fieldOptions['min']
        : _currentValue = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: (FormFieldState<double> state) {
        return DecimalNumberPicker(
          value: _currentValue,
          maxValue: widget.fieldOptions['max'],
          minValue: widget.fieldOptions['min'],
          onChanged: (num val) {
            setState(() {
              _currentValue = val;
            });
          },
        );
      },
      onSaved: (double val) {
        return val;
      },
    );
  }
}
