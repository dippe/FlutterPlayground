import 'package:flutter/material.dart';
import 'package:todo_flutter_app/BasicChart.dart';
import 'package:todo_flutter_app/todo/TodoStateStore.dart';
import 'package:todo_flutter_app/todo/Domain.dart';

final _todoStateStore = new TodoAppStore();

class TodoAppStore extends State<TodoApp> with TodoStateStore {
  @override
  Widget build(BuildContext context) {
    return _renderTodoApp();
  }
}

class TodoApp extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return _renderTodoApp();
  }

  @override
  State<StatefulWidget> createState() {
    return _todoStateStore;
  }
}

_renderTodoApp() => new Scaffold(
      appBar: AppBar(
        actions: <Widget>[MainBtns()],
      ),
//      bottomNavigationBar: MainBtns(),
      body: TodoBody(),
    );

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
        new IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _todoStateStore.add('Tmptitle' + _todoStateStore.length().toString())),
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
        new SimpleBarChart.withData(_todoStateStore.lengthDone(), _todoStateStore.lengthTodo()),
      ],
    );
  }
}

_TodoListItems() => ListView(
      scrollDirection: Axis.vertical,
      children: _todoStateStore.list().map((i) => _renderTodoItem(i)).toList(),
    );

Widget _renderTodoItem(TodoData d) => (new Row(
      children: <Widget>[
        new Checkbox(
          value: d.done,
          onChanged: (bool state) => _todoStateStore.toggleState(d),
        ),
        new Text(d.title, style: TextStyle(decoration: d.done ? TextDecoration.lineThrough : TextDecoration.none))
      ],
    ));
