import 'package:flutter/material.dart';
import 'package:todo_flutter_app/todo/Todo.dart';

typedef void Cb2();

typedef Widget StateCb(int _counter, BuildContext context, Cb2 onButtonClick, String title);

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(primarySwatch: Colors.orange),
      home: new TodoApp(),
//      home: new MyHomePage(title: 'Butter Demo Home Page'),
    );
  }
}
