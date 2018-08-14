import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/**
 * Example:
 *
 * ReduxDateField(
 *   title: 'Dátumocska',
 *   onChange: (res) => print('Choosed Date: ' + res.toIso8601String()),
 *   ),
 *
 */

typedef void _OnChangeCallBack(DateTime res);

class ReduxDateField extends StatefulWidget {
  final _OnChangeCallBack onChange;
  final String title;

  ReduxDateField({Key key, @required this.onChange, @required this.title}) : super(key: key);

  @override
  _ReduxDateFieldState createState() => new _ReduxDateFieldState();
}

class _ReduxDateFieldState extends State<ReduxDateField> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final _dateFormat = DateFormat.yMd();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: new InputDecoration(
              icon: const Icon(Icons.calendar_today),
              hintText: 'Enter your date of birth',
              labelText: widget.title,
            ),
            controller: _dateFieldController,
            keyboardType: TextInputType.datetime,
            enabled: false,
          ),
        ),
        new IconButton(
          icon: new Icon(Icons.date_range),
          tooltip: 'Choose date',
          onPressed: (() {
            _chooseDate(context, _dateFieldController.text);
          }),
        ),
      ],
    );
  }

  final TextEditingController _dateFieldController = new TextEditingController();

  Future _chooseDate(BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now) ? initialDate : now);

    DateTime result = await showDatePicker(context: context, initialDate: initialDate, firstDate: new DateTime(1900), lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      _dateFieldController.text = _dateFormat.format(result);
      widget.onChange(result);
    });
  }

  DateTime convertToDate(String input) {
    try {
      var d = _dateFormat.parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }
}
