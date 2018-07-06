import 'package:flutter/material.dart';
import 'package:flutter_immutable_state/flutter_immutable_state.dart';
import 'package:todo_flutter_app/BasicChart.dart';
import 'package:todo_flutter_app/examples/state/immutable/TodoState.dart';

final _INIT_STATE = TodoState(
  todos: Todos(
    items: Map.unmodifiable({0: new TodoData(0, 'Hello world :P', false)}),
    idCounter: 1,
  ),
  listView: TodoListView(
    selectedItem: null,
    selectedTitleForEdit: null,
  ),
);

// This Stateful widget creates connection between the app state and the rendering
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Details about rendering+immutable classes here: https://pub.dartlang.org/packages/flutter_immutable_state
    return ImmutableManager<TodoState>(
      initialValue: _INIT_STATE,
      child: MaterialApp(
        home: _renderMainRoot(),
        title: 'Test title',
        theme: ThemeData.dark(),
      ),
    );
  }
}

/*************************************
 *
 * Renderer functions
 *
 *************************************/

Widget _renderMainRoot() => ImmutableView<TodoState>.readOnly(
      builder: (context, state) => Scaffold(
            appBar: _renderAppBar(state.todos.lengthDone(), state.todos.lengthTodo()),
            body: _renderTodoListItems(),
          ),
    );

Widget _renderAppBar(int done, int todo) {
  return AppBar(
    actions: <Widget>[
      new SizedBox(height: 100.0, width: 100.0, child: SimpleBarChart.withData(done, todo)),
// map the substate to the child widgets (hide uneeded data)
      ImmutablePropertyManager<TodoState, Todos>(
        current: (state) => state.todos,
        child: _renderMainBtns(),
        change: (state, newElem) => state.withTodos(newElem),
      ),
    ],
  );
}

Widget _renderMainBtns() => ImmutableView<Todos>(
      builder: (context, state) {
        PopupMenuItemBuilder builder = (BuildContext context) => <PopupMenuEntry<ConfigMenuItems>>[
              PopupMenuItem(value: ConfigMenuItems.About, child: const Text('About')),
              PopupMenuItem(value: ConfigMenuItems.Config, child: const Text('Config')),
              PopupMenuItem(value: ConfigMenuItems.DisplayFinished, child: const Text('Show finished')),
            ];

        return ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              tooltip: 'New Todo',
              icon: Icon(Icons.add),
              onPressed: () {
                _debug(context, 'add clicked');
                state.change((s) => s.withNewItem(TodoData(null, 'Unnamed ' + s.idCounter.toString(), false)));
              },
            ),
          ],
        );
      },
    );

Widget _renderTodoListItems() => ImmutableView<TodoState>.readOnly(
      builder: (context, state) => ListView(
            scrollDirection: Axis.vertical,
            children: state.todos.list().map((i) => _renderTodoItem(i.id)).toList(),
          ),
    );

Widget _renderTodoItem(int id) => ImmutableView<TodoState>(
      builder: (context, state) {
        var d = state.current.todos.getById(id);
        return GestureDetector(
          child: Row(
            children: <Widget>[
              Checkbox(
                value: d.done,
                onChanged: (bool val) => state.change((t) => t.withTodos(t.todos.withToggledItem(d))),
              ),
              Expanded(
                // map state to Todos
                child: state.current.listView.isSelectedForEdit(d.id)
                    ? ImmutablePropertyManager<TodoState, Todos>(
                        current: (state) => state.todos,
                        child: _renderEditableTitle(
                          id: d.id,
                          onSubmit: (String value) {
                            state.change((s) {
                              var ret = s
                                  .withListView(s.listView.withUnselect())
                                  .withTodos(s.todos.withUpdated(d.withTitle(value)));
                              return ret;
                            });
                          },
                        ),
                        change: (state, newElem) => state.withTodos(newElem),
                      )
                    : ImmutablePropertyManager<TodoState, TodoListView>(
                        current: (state) => state.listView,
                        child: _renderReadOnlyTitle(d.id, d.title, d.done),
                        change: (state, newElem) => state.withListView(newElem),
                      ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => state.change((t) => t.withTodos(t.todos.withDeleted(d))),
              ),
            ],
          ),
          onHorizontalDragEnd: (DragEndDetails details) => state.change((t) => t.withTodos(t.todos.withToggledItem(d))),
        );
      },
    );

// memoize is added to avoid re-rendering and weird background obj re-allocations which causes rendering issues (the GestureDetector is stateful and re-creating on every state chang causes weird behavior)
Widget _renderReadOnlyTitle(int id, String title, bool done) {
  return ImmutableView<TodoListView>(builder: (context, state) {
    return GestureDetector(
      onLongPress: () {
        state.change((s) => s.withSelectedForEdit(id));
      },
      onDoubleTap: () {
        state.change((s) {
          return s.withSelectedForEdit(id);
        });
      },
      onTap: () {
        state.change((s) => s.withSelected(id));
      },
      child: Text(
        title,
        style: TextStyle(decoration: done ? TextDecoration.lineThrough : TextDecoration.none),
      ),
    );
  });
}

// memoize is added to avoid re-rendering and weird background obj re-allocations which causes rendering issues (textfield with controller is stateful and re-rendering is unpleasant)
Widget _renderEditableTitle({int id, Function onSubmit}) => ImmutableView<Todos>(
      builder: (context, state) {
        final d = state.current.getById(id);
        final ctrl = new TextEditingController();

        // fixme: remove this later
        ctrl.addListener(() {
          print('ctrl' + ctrl.hashCode.toString() + ' -- ' + d.hashCode.toString());
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
          ),
          keyboardType: TextInputType.text,

          onSubmitted: onSubmit,
          onChanged: (String value) {
            _debug(context, 'onchanged');
            // do not change the state here!!! The auto triggered re-rendering will cause serious perf/rendering issues
          },
          autofocus: true,

          // TextInputFormatters are applied in sequence.
          inputFormatters: [],
        );
      },
    );

void _debug(BuildContext context, String msg) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
