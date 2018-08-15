import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/action.dart';
import 'package:todo_flutter_app/view/common/common_date_field.dart';
import 'package:todo_flutter_app/view/common/common_drop_down_field.dart';
import 'package:todo_flutter_app/view/common/common_text_field.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/jql_tab_edit/action.dart';

wJqlEditPage() => MyHomePage();

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
        child: new StoreConnector<AppState, ViewState>(
          converter: (store) => store.state.view,
          builder: (context, view) => new Form(
                key: _formKey,
                autovalidate: false,
                child: new ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: <Widget>[
                    new CommonTextField(
                      labelText: 'Name',
                      initValue: view.issueListViews[view.actListIdx].name,
                      onChange: (txt) => dispatch(SetFilterNameAction(txt)),
                      inputType: FieldInputType.TEXT,
                    ),
                    CommonDropDownField(
                      name: 'Filter',
                      items: {1: 'Valami', 2: 'még valamibb'},
                      onSelect: (filter) => dispatch(SelectFilterAction(filter)),
                      selected: 2,
                      icon: Icons.filter_none,
                    ),
                    Card(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 16.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Text('Filter name:'),
                              title: Text(view.issueListViews[view.actListIdx].filter.name ?? 'No name ??'),
                            ),
                            ListTile(
                              leading: Text('JQL:'),
                              title: Text(view.issueListViews[view.actListIdx].filter.jql ?? 'No filter ??'),
                            ),
                          ],
                        )),
                    new Container(
                        padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                        child: new RaisedButton(
                          child: const Text('Submit'),
                          onPressed: () => dispatch(HideConfigPage()),
                        )),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
