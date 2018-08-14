import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter_app/view/common/common_date_field.dart';
import 'package:todo_flutter_app/view/common/common_text_field.dart';
import 'package:todo_flutter_app/view/jql_tab_edit/action.dart' as Actions;

wJqlEditForm() => MyHomePage();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.name}) : super(key: key);
  final String name;
  final String title = 'Jql Filter';

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _colors = <String>[
    '',
    'red',
    'green',
    'blue',
    'orange',
    'gray',
  ];
  String _color = '';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter the name of the Jql filter',
                      labelText: 'Name',
                    ),
                    validator: (s) => s.length > 10 ? 'Max 10 chars' : null,
                  ),
                  new InputDecorator(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.color_lens),
                      labelText: 'Filters',
                    ),
                    isEmpty: _color == '',
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton<String>(
                        value: _color,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _color = newValue;
                          });
                        },
                        items: _colors.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  CommonTextField(
                    labelText: 'Labelka',
                    onChange: (txt) => print('submitted: ' + txt),
                    initValue: 'initTxt',
                    inputType: FieldInputType.TEXT,
                  ),
                  CommonDateField(
                    title: 'Dátumocska',
                    onChange: (res) => print('Choosed Date: ' + res.toIso8601String()),
                  ),
                  new Container(
                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                      child: new RaisedButton(
                        child: const Text('Submit'),
                        onPressed: null,
                      )),
                ],
              ))),
    );
  }
}
