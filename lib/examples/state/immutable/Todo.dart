import 'package:flutter/material.dart';
import 'package:flutter_immutable_state/flutter_immutable_state.dart';
import 'package:todo_flutter_app/BasicChart.dart';
import 'package:todo_flutter_app/examples/state/immutable/TodoState.dart';

final _INIT_STATE = TodoState(
  todos: Todos(
    items: Map.unmodifiable({0: new TodoData(0, 'Hello world :P', false)}),
    idCounter: 1,
  ),
  listView: TodoListView(),
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

        return Row(
          children: [
            IconButton(
              tooltip: 'New Todo',
              icon: Icon(Icons.add),
              onPressed: () {
                _debug(context, 'add clicked');
                state.change((s) => s.withNewItem('Unnamed ' + s.idCounter.toString()));
              },
            ),
            PopupMenuButton(
              itemBuilder: builder,
            ),
          ],
        );
      },
    );

Widget _renderTodoListItems() => ImmutableView<TodoState>(
      builder: (context, state) {
        var onDelete = (d) => () => state.change((t) => t.withTodos(t.todos.withDeleted(d)));
        var onTap = (TodoData d) {
          state.change((t) => t.withTodos(t.todos.withAllUnselected().withUpdated(d.withSelected(true))));
        };
        var onDoubleTap = (TodoData d) {
          state.change((t) => t.withTodos(t.todos.withAllUnselected().withUpdated(d.withEdit(true))));
        };

        return ListView(
          scrollDirection: Axis.vertical,
          children: state.current.todos
              .list()
              .map((d) =>
                  // map state to the item
                  ImmutablePropertyManager<TodoState, TodoData>(
                    current: (state) => state.todos.items[d.id],
                    child: _renderTodoItem(onDelete(d), onTap, onDoubleTap),
                    change: (state, newTodo) => state.withTodos(state.todos.withUpdated(newTodo)),
                  ))
              .toList(),
        );
      },
    );

Widget _renderTodoItem(Function onDelete, Function onTapCb, Function onDoubleTapCb) => ImmutableView<TodoData>(
      builder: (context, state) {
        // fixme: move "selected" into the todo item from the list view
        final bool isSelected = state.current.isSelected;
        final bool isEdit = state.current.isEdit;

        final deleteBtn = IconButton(
          icon: Icon(Icons.delete),
          onPressed: onDelete,
        );

        final dragIcon = Draggable<TodoData>(
          child: Icon(Icons.drag_handle),
          feedback: Text('Dragged'),
          data: state.current,
          childWhenDragging: Container(
            decoration: new BoxDecoration(color: Colors.green),
            child: Divider(height: 2.0, color: Color.fromARGB(255, 255, 0, 0)),
          ),
          onDragCompleted: () => {},
        );

        return DragTarget<TodoData>(
          onAccept: (a) {
            // returns void
            print('**** onAccept: ' + a.title);
          },
          onLeave: (a) {
            // returns void
            print('**** onLeave: ' + a.title);
          },
          onWillAccept: (a) {
            print('**** onWillAccept: ' + a.title);
            return true;
          },
          builder: (BuildContext context, List<dynamic> candidateData, List<dynamic> rejectedData) {
            // todo: remove these 3 debugging lines later
            TodoData rd = rejectedData.isNotEmpty ? rejectedData.first : null;
            TodoData cd = candidateData.isNotEmpty ? candidateData.first : null;
            print('**** build: ' + rd.toString() + ' ---- ' + cd.toString());

            var decoration = candidateData.isNotEmpty ? new BoxDecoration(color: Colors.green) : null;

            var checkBox =
                Checkbox(value: state.current.done, onChanged: (bool val) => state.change((d) => d.withToggled()));

            var todoName = Expanded(
              child: isEdit
                  ? _renderEditableTitle()
                  : isSelected
                      ? _renderReadOnlyTitle(onDoubleTapCb, onDoubleTapCb) // if selected, one tap is enough to edit
                      : _renderReadOnlyTitle(onTapCb, onDoubleTapCb),
            );

            return isSelected && isEdit
                ? Row(
                    children: [
                      todoName,
                      deleteBtn,
                    ],
                  )
                : isSelected
                    ? Row(
                        children: [
                          dragIcon,
                          checkBox,
                          todoName,
                          deleteBtn,
                        ],
                      )
                    : GestureDetector(
                        onHorizontalDragEnd: (DragEndDetails details) => state.change((d) => d.withToggled()),
                        child: Row(
                          children: [
                            checkBox,
                            todoName,
                          ],
                        ),
                      );
          },
        );
      },
    );

Widget _renderReadOnlyTitle(Function onTapCb, Function onDoubleTapCb) {
  // the actual substate is the proper tododata (see the PropertyManager)
  return ImmutableView.readOnly<TodoData>(builder: (context, state) {
    return InkWell(
      onDoubleTap: () => onDoubleTapCb(state),
      onTap: () => onTapCb(state),
      // todo: kell ez a container?
      child: Container(
        padding: new EdgeInsets.all(10.0),
        // color: new Color(0X9900CCCC),
        child: Text(
          state.title,
          style: TextStyle(decoration: state.done ? TextDecoration.lineThrough : TextDecoration.none),
        ),
      ),
    );
  });
}

Widget _renderEditableTitle() => ImmutableView<TodoData>(
      // the actual substate is the proper tododata (see the PropertyManager)
      builder: (context, state) {
        final d = state.current;
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

          onSubmitted: (String value) {
            state.change((d) {
              var ret = d.withSelected(false).withTitle(value);
              return ret;
            });
          },
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
