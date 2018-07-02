import 'package:flutter/material.dart';
import 'package:todo_flutter_app/BasicChart.dart';
import 'package:todo_flutter_app/todo/TodoStateStore.dart';
import 'package:todo_flutter_app/todo/Domain.dart';

class TodoAppStore extends State<TodoApp> with TodoStateStore {
  final _renderer;

  TodoAppStore(this._renderer);

  @override
  Widget build(BuildContext todoAppContext) {
    return this._renderer(this);
  }
}

// This Stateful widget creates connection between the app state and the rendering
class TodoApp extends StatefulWidget {
  final TodoAppStore _todoAppStateStore = TodoAppStore(_renderTodoApp);

  @override
  Widget build(BuildContext context) {
    // Implementing this is unneeded because the state will do the rendering and this build method will be never called
  }

  @override
  TodoAppStore createState() {
    return _todoAppStateStore;
  }
}

/*************************************
 *
 * Renderer functions
 *
 *************************************/

Widget _renderTodoApp(TodoAppStore state) => Scaffold(
      appBar: AppBar(
        actions: <Widget>[_renderMainBtns(state)],
      ),
//      bottomNavigationBar: MainBtns(),
      body: _renderTodoBody(state),
    );

Widget _renderMainBtns(TodoAppStore state) {
  PopupMenuItemBuilder builder = (BuildContext context) => <PopupMenuEntry<ConfigMenuItems>>[
        PopupMenuItem(value: ConfigMenuItems.About, child: const Text('About')),
        PopupMenuItem(value: ConfigMenuItems.Config, child: const Text('Config')),
        PopupMenuItem(value: ConfigMenuItems.DisplayFinished, child: const Text('Show finished')),
      ];

  return ButtonBar(
    alignment: MainAxisAlignment.center,
    children: <Widget>[
      IconButton(icon: Icon(Icons.add), onPressed: () => state.add('Unnamed ' + state.length().toString())),
      PopupMenuButton<ConfigMenuItems>(icon: Icon(Icons.settings), itemBuilder: builder)
    ],
  );
}

Widget _renderTodoBody(TodoAppStore state) {
  return GridView(
    scrollDirection: Axis.vertical,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
    children: <Widget>[
      _renderTodoListItems(state),
      SimpleBarChart.withData(state.lengthDone(), state.lengthTodo()),
    ],
  );
}

Widget _renderTodoListItems(TodoAppStore state) => ListView(
      scrollDirection: Axis.vertical,
      children: state.list().map((i) => _renderTodoItem(i, state)).toList(),
    );

Widget _renderTodoItem(TodoData d, TodoAppStore state) {
  var _actTextFieldController = TextEditingController(text: d.title); //TextEditingController(text: 'Empty');

  return (Row(
    children: <Widget>[
      Checkbox(
        value: d.done,
        onChanged: (bool val) => state.toggleState(d),
      ),
      Expanded(
        child: GestureDetector(
          child: _renderTitle(state.isSelectedForEdit(d), d, _actTextFieldController, state),
          onLongPress: () {
            return state.selectItemTitleForEdit(d);
          },
          onDoubleTap: () {
            if (_actTextFieldController != null) {
              _actTextFieldController.dispose();
            }
            return state.selectItemTitleForEdit(d);
          },
          onTap: () => state.selectItem(d),
          onHorizontalDragEnd: (DragEndDetails details) => state.toggleState(d),
        ),
      ),
      IconButton(icon: Icon(Icons.delete), onPressed: () => state.delete(d)),
    ],
  ));
}

Widget _renderTitle(bool edit, TodoData d, TextEditingController controller, TodoAppStore state) =>
    edit == false ? _renderReadOnlyTitle(d) : _renderEditableTitle(d, controller, state);

Widget _renderReadOnlyTitle(TodoData d) => Text(
      d.title,
      style: TextStyle(decoration: d.done ? TextDecoration.lineThrough : TextDecoration.none),
    );

Widget _renderEditableTitle(TodoData d, TextEditingController c, TodoAppStore state) {
//  _actTextFieldController.text = d.title;
//  _actTextFieldController.value = TextEditingValue(text: d.title);
  return TextField(
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
      state.update(d.withTitle(value));
    },

    // TextInputFormatters are applied in sequence.
    inputFormatters: [],
    //      controller: _todoStateStore.getTextFieldController(),
  );
}
