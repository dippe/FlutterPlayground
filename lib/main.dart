import 'package:flutter/material.dart';
import 'package:todo_flutter_app/examples/state/redux/Todo.dart';
import 'package:todo_flutter_app/examples/state/redux/state/state.dart';
import 'package:todo_flutter_app/examples/state/redux/jira/jira.dart';

void main() {
  getIssue('TEST-1');

  // redux implementation
  runApp(new FlutterReduxApp(
    store: store,
  ));
  // end of redux implementation

  // enable to use "immutable", "simple" implementations
  // runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo Demo',
      theme: new ThemeData(primarySwatch: Colors.orange),
      home: new TodoApp(),
    );
  }
}
