import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
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
        child: new StoreConnector<AppState, _ViewModel>(
          converter: (store) {
            // fixme: this converter function holds the old name value >> form won't be updated on changes (maybe this not a problem (?))
            final List<JiraFilter> tmpFilters = List<JiraFilter>.from(store.state.jira.predefinedFilters)
              ..addAll(store.state.jira.fetchedFilters ?? []);

            final Map<JiraFilter, String> itemMap = Map.fromIterable(tmpFilters, key: (v) => v, value: (v) => v.name);

            return _ViewModel(
              actListView: store.state.view.issueListViews[store.state.view.actListIdx],
              items: itemMap,
            );
          },
          builder: (context, vm) => new Form(
                key: _formKey,
                autovalidate: false,
                child: new ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: <Widget>[
                    new CommonTextField(
                      labelText: 'Tab Name',
                      initValue: vm.actListView.name,
                      onChange: (txt) => dispatch(SetFilterNameAction(txt)),
                      inputType: FieldInputType.TEXT,
                    ),
                    CommonDropDownField(
                      name: 'JIRA Filter',
                      items: vm.items,
                      onSelect: (filter) => dispatch(SelectFilterAction(filter)),
                      selected: vm.actListView.filter,
                      icon: Icons.filter_none,
                    ),
                    Card(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 16.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Text('Filter name:'),
                              title: Text(vm.actListView.filter.name ?? 'No name ??'),
                            ),
                            ListTile(
                              leading: Text('JQL:'),
                              title: Text(vm.actListView.filter.jql ?? 'No filter ??'),
                            ),
                          ],
                        )),
                    new Container(
                        padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                        child: new RaisedButton(
                          child: const Text('Back to the list'),
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

class _ViewModel {
  IssueListView actListView;
  Map<JiraFilter, String> items;

  _ViewModel({this.actListView, this.items});
}
