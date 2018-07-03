import 'package:flutter/material.dart';
import 'package:todo_flutter_app/BasicChart.dart';
import 'package:todo_flutter_app/todo/TodoStateStore.dart';
import 'package:todo_flutter_app/todo/Domain.dart';
import 'package:todo_flutter_app/util/memoize.dart';

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
    return null;
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
      children: state.list().map((i) => _renderTodoItem(state, i.id)).toList(),
    );

// memoize start
// todo refactor/re-think (too much change can cause memory leak like issue)
/*
final _memoizedTodoRenderers = new Map<String, Widget>();

Widget _renderTodoItem(TodoAppStore state, int id) {
  final isSelectedForEdit = state.isSelectedForEdit(state.getById(id));
  final key = id.toString() + isSelectedForEdit.toString();
  if (!_memoizedTodoRenderers.containsKey(key)) {
    final Widget w = _renderTodoItem1(state, id);
    _memoizedTodoRenderers.putIfAbsent(key, () => w);
  } else if (isSelectedForEdit) {
    // remove read-only cache if the element is edited
    _memoizedTodoRenderers.remove(id.toString() + 'false');
  }
  return _memoizedTodoRenderers[key];
}
*/
// memoize end

Widget _renderTodoItem(TodoAppStore state, int id) {
  final TodoData d = state.getById(id);

  return (Row(
    children: <Widget>[
      Checkbox(
        value: d.done,
        onChanged: (bool val) => state.toggleState(d),
      ),
      Expanded(
        child: state.isSelectedForEdit(d.id)
            ? _renderEditableTitle(state, d.id)
            : _renderReadOnlyTitle(state, d.id, d.title, d.done),
      ),
      IconButton(icon: Icon(Icons.delete), onPressed: () => state.delete(d)),
    ],
  ));
}

// memoize is added to avoid re-rendering and weird background obj re-allocations which causes rendering issues (the GestureDetector is stateful and re-creating on every state chang causes weird behavior)
final _renderReadOnlyTitle = memoize((TodoAppStore state, int id, String title, bool done) {
  final d = state.getById(id);

  return GestureDetector(
    onLongPress: () {
      return state.selectItemTitleForEdit(d);
    },
    onDoubleTap: () {
      return state.selectItemTitleForEdit(d);
    },
    onTap: () => state.selectItem(d),
    onHorizontalDragEnd: (DragEndDetails details) => state.toggleState(d),
    child: Text(
      d.title,
      style: TextStyle(decoration: d.done ? TextDecoration.lineThrough : TextDecoration.none),
    ),
  );
});

// memoize is added to avoid re-rendering and weird background obj re-allocations which causes rendering issues (textfield with controller is stateful and re-rendering is unpleasant)
final _renderEditableTitle = memoize((TodoAppStore state, int id) {
  final d = state.getById(id);
  final ctrl = new TextEditingController();

  ctrl.addListener(() {
    print('ctrl' + ctrl.hashCode.toString() + ' -- ' + d.hashCode.toString());
//    _focusManager.rootScope.requestFocus(focusNode);
  });
  ctrl.text = d.title;
  ctrl.value = TextEditingValue(text: d.title);
  return TextField(
    controller: ctrl,
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
    onSubmitted: (String value) {
      print('SUBMIT');
      state.update(d.withTitle(value));
      state.unSelectTitleForEdit();
    },
//    focusNode: focusNode,
    onChanged: (String value) {
      print('CHANGE');
      state.update(d.withTitle(value));
      state.update(d.withTitle(value));
    },
    autofocus: true,

    // TextInputFormatters are applied in sequence.
    inputFormatters: [],
    //      controller: _todoStateStore.getTextFieldController(),
  );
});
