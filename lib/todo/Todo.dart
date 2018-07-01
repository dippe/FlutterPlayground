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
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
      children: <Widget>[
        _renderTodoListItems(),
        new SimpleBarChart.withData(_todoStateStore.lengthDone(), _todoStateStore.lengthTodo()),
      ],
    );
  }
}

_renderTodoListItems() => ListView(
      scrollDirection: Axis.vertical,
      children: _todoStateStore.list().map(_renderTodoItem).toList(),
    );

var _actTextFieldController = TextEditingController(text: 'Empty');

Widget _renderTodoItem(TodoData d) {
  return (new Row(
    children: <Widget>[
      new Checkbox(
        value: d.done,
        onChanged: (bool state) => _todoStateStore.toggleState(d),
      ),
      new Expanded(
        child: new GestureDetector(
          child: _renderTitle(_todoStateStore.isSelectedForEdit(d), d, _actTextFieldController),
          onLongPress: () {
            _actTextFieldController = TextEditingController(text: d.title);
            return _todoStateStore.selectItemTitleForEdit(d);
          },
          onDoubleTap: () {
            _actTextFieldController = TextEditingController(text: d.title);
            return _todoStateStore.selectItemTitleForEdit(d);
          },
          onTap: () => _todoStateStore.selectItem(d),
          onHorizontalDragEnd: (DragEndDetails details) => _todoStateStore.toggleState(d),
        ),
      ),
      new IconButton(icon: Icon(Icons.delete), onPressed: () => _todoStateStore.delete(d)),
    ],
  ));
}

_renderTitle(bool edit, TodoData d, TextEditingController controller) =>
    edit == false ? _renderReadOnlyTitle(d) : _renderEditableTitle(d, controller);

_renderReadOnlyTitle(TodoData d) => new Text(
      d.title,
      style: TextStyle(decoration: d.done ? TextDecoration.lineThrough : TextDecoration.none),
    );

_renderEditableTitle(TodoData d, TextEditingController c) {
//  _actTextFieldController.text = d.title;
//  _actTextFieldController.value = TextEditingValue(text: d.title);
  return new TextField(
    controller: c,
    enabled: true,
    decoration: const InputDecoration(
      border: const UnderlineInputBorder(),
      filled: true,
      icon: const Icon(Icons.short_text),
      hintText: 'What would you like to remember?',
      //        labelText: 'Title',
      //        prefixText: '+1',
    ),
    keyboardType: TextInputType.text,
    onChanged: (String value) {
      _todoStateStore.update(d.withTitle(value));
    },

    // TextInputFormatters are applied in sequence.
    inputFormatters: [],
    //      controller: _todoStateStore.getTextFieldController(),
  );
}
