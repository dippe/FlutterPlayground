import 'package:flutter/material.dart';
import 'package:todo_flutter_app/todo/todo.dart';

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

/*
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() =>
      new _MyHomePageState(_renderInnerAfterStateChange);

  Widget _renderInnerAfterStateChange(
      _counter, context, Cb2 _incrementCounter, title) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times!!',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.ac_unit),
      ),
    );
  }
}
*/

/*
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final StateCb cb;

  _MyHomePageState(this.cb);

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return cb(_counter, context, _incrementCounter, widget.title);
  }
}
*/
