import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:todo_flutter_app/examples/state/redux/Todo.dart';
import 'package:todo_flutter_app/examples/state/redux/state/domain.dart';
import 'package:todo_flutter_app/examples/state/redux/state/state.dart';

void main() {
  // redux imlementation
  final store = new Store<TodoAppState>(todoReducer, initialState: INIT_STATE);

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
