import 'package:flutter/material.dart';
import 'package:todo_flutter_app/examples/state/firestore/Todo.dart';

void main() => runApp(new MyApp());

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
