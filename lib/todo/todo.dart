import 'package:flutter/material.dart';
import 'package:todo_flutter_app/BasicChart.dart';

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        actions: <Widget>[MainBtns()],
      ),
//      bottomNavigationBar: MainBtns(),
      body: TodoBody(),
    );
  }
}

enum ConfigMenuItems { About, Config, DisplayFinished }

class MainBtns extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PopupMenuItemBuilder builder = (BuildContext context) => <PopupMenuEntry<ConfigMenuItems>>[
          PopupMenuItem(value: ConfigMenuItems.About, child: const Text('About')),
          PopupMenuItem(value: ConfigMenuItems.Config, child: const Text('Config')),
          PopupMenuItem(value: ConfigMenuItems.DisplayFinished, child: const Text('Show finished')),
        ];

    return new ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        new IconButton(icon: Icon(Icons.add), onPressed: null),
        new PopupMenuButton<ConfigMenuItems>(icon: Icon(Icons.settings), itemBuilder: builder)
      ],
    );
  }
}

class TodoBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new GridView(
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      children: <Widget>[
        _TodoListItems(),
        new SimpleBarChart.withSampleData(),
      ],
    );

    /* another scroll example
    return new SingleChildScrollView(
        child: Column(
      children: <Widget>[
        MainBtns(),
        MainBtns()
      ],
    ));
    */
  }
}

_TodoListItems() => ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        _renderTodoItem(new TodoData(title: 'Title', done: true)),
        _renderTodoItem(new TodoData(title: 'Title2', done: false)),
        _renderTodoItem(new TodoData(title: 'Title2', done: false)),
      ],
    );

_renderTodoItem(TodoData d) => (new Row(
      children: <Widget>[
        new Checkbox(value: d.done),
        new Text(d.title, style: TextStyle(decoration: d.done ? TextDecoration.lineThrough : TextDecoration.none))
      ],
    ));

class TodoData {
  final String title;
  final bool done;

  TodoData({this.title, this.done});
}
