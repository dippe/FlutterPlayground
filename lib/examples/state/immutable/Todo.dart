import 'package:flutter/material.dart';
import 'package:flutter_immutable_state/flutter_immutable_state.dart';
import 'package:todo_flutter_app/BasicChart.dart';
import 'package:todo_flutter_app/examples/state/immutable/TodoState.dart';

const DEFAULT_ITEM_NAME = 'Unnamed';

final _INIT_STATE = TodoState(
  todos: Todos(
    items: List.unmodifiable([new TodoData(0, 'Hello world :P', false)]),
    idCounter: 1,
  ),
  listView: TodoListView(),
);

Widget _stateTodos(Widget child) => ImmutablePropertyManager<TodoState, Todos>(
      current: (state) => state.todos,
      child: child,
      change: (state, newElem) => state.withTodos(newElem),
    );

Widget _stateTodo(Widget child, int todoId) => ImmutablePropertyManager<TodoState, TodoData>(
      current: (state) => state.todos.getById(todoId),
      child: child,
      change: (state, newTodo) => state.withTodos(state.todos.withUpdated(newTodo)),
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
            appBar: _renderHeaderAppBar(),
            body: _renderTodoListItems(),
          ),
    );

Widget _renderHeaderAppBar() {
  return AppBar(
    actions: <Widget>[
      SimpleBarChart.renderProgressChart(),
      _stateTodos(_renderMainBtns()),
    ],
  );
}

Widget _renderMainBtns() => Row(
      children: [_renderAddButton(), _renderTopMenu()],
    );

Widget _renderTopMenu() {
  PopupMenuItemBuilder builder = (BuildContext context) => <PopupMenuEntry<ConfigMenuItems>>[
        PopupMenuItem(value: ConfigMenuItems.About, child: const Text('About')),
        PopupMenuItem(value: ConfigMenuItems.Config, child: const Text('Config')),
        PopupMenuItem(value: ConfigMenuItems.DisplayFinished, child: const Text('Show finished')),
      ];
  return PopupMenuButton(
    itemBuilder: builder,
  );
}

Widget _renderAddButton() => ImmutableView<Todos>(
      builder: (context, state) {
        return IconButton(
          tooltip: 'New Todo',
          icon: Icon(Icons.add),
          onPressed: () {
            _debug(context, 'add clicked');
            state.change((s) => s.withNewItem(DEFAULT_ITEM_NAME));
          },
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
          state.change((t) => t.withTodos(t.todos.withAllUnselected().withUpdated(d.withTitle('').withEdit(true))));
        };
        var onItemDrop = (TodoData dragged, TodoData target) {
          state.change((t) => t.withTodos(t.todos.withAllUnselected().withMoved(dragged, target)));
        };

        return ListView(
          scrollDirection: Axis.vertical,
          children: state.current.todos.list().map((d) =>
              // map state to the item
              _stateTodo(_renderTodoItem(onDelete(d), onTap, onDoubleTap, onItemDrop), d.id)).toList(),
        );
      },
    );

Widget _renderTodoItem(Function onDelete, Function onTapCb, Function onDoubleTapCb, Function onItemDrop) =>
    ImmutableView<TodoData>(
      builder: (context, state) {
        // fixme: move "selected" into the todo item from the list view
        final bool isSelected = state.current.isSelected;
        final bool isEdit = state.current.isEdit;

        final deleteBtn = IconButton(
          icon: Icon(Icons.delete),
          onPressed: onDelete,
        );

        final draggableIcon = Draggable<TodoData>(
          child: Icon(Icons.short_text),
          feedback: Text(
            'Dragged',
            style: TextStyle(fontSize: 15.0, color: Colors.white, decoration: TextDecoration.none),
          ),
          data: state.current,
          childWhenDragging: Container(
            decoration: new BoxDecoration(color: Colors.white),
            child: Divider(height: 2.0, color: Color.fromARGB(255, 255, 0, 0)),
          ),
          onDragCompleted: () => {},
        );

        return DragTarget<TodoData>(
          onAccept: (dragged) {
            // returns void
            print('**** onAccept: ' + state.current.title + ' >> ' + dragged.title);
            if (dragged != state.current) {
              onItemDrop(dragged, state.current);
            }
          },
          onLeave: (dragged) {
            // returns void
            print('**** onLeave: ' + state.current.title + ' >> ' + dragged.title);
          },
          onWillAccept: (dragged) {
            print('**** onWillAccept: ' + state.current.title + ' >> ' + dragged.title);
            return true;
          },
          builder: (BuildContext context, List<dynamic> candidateData, List<dynamic> rejectedData) {
            // todo: remove these 3 debugging lines later
            TodoData rd = rejectedData.isNotEmpty ? rejectedData.first : null;
            TodoData cd = candidateData.isNotEmpty ? candidateData.first : null;
            print('**** build: ' + rd.toString() + ' ---- ' + cd.toString());

            final decoration = candidateData.isNotEmpty ? new BoxDecoration(color: Colors.green) : null;
            final _renderHighlight = (Widget row) => Container(decoration: decoration, child: row);

            final checkBox = Checkbox(
              value: state.current.done,
              onChanged: (bool val) => state.change((d) => d.withToggled()),
            );

            final todoName = Expanded(
              child: isEdit
                  ? _renderEditableTitle()
                  : isSelected
                      ? _renderReadOnlyTitle(onDoubleTapCb, onDoubleTapCb) // if selected, one tap is enough to edit
                      : _renderReadOnlyTitle(onTapCb, onDoubleTapCb),
            );

            final renderEditRow = () => Row(
                  children: [
                    todoName,
                    deleteBtn,
                  ],
                );
            final renderSelectedRow = () => Row(
                  children: [
                    draggableIcon,
                    checkBox,
                    todoName,
                    deleteBtn,
                  ],
                );
            final renderUnselectedRow = () => GestureDetector(
                  onHorizontalDragEnd: (DragEndDetails details) => state.change((d) => d.withToggled()),
                  child: Row(
                    children: [
                      checkBox,
                      todoName,
                    ],
                  ),
                );

            final row =
                isSelected && isEdit ? renderEditRow() : (isSelected ? renderSelectedRow() : renderUnselectedRow());

            return _renderHighlight(row);
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
            // icon: const Icon(Icons.short_text),
            hintText: 'What would you like to remember?',
          ),
          keyboardType: TextInputType.text,

          onSubmitted: (String value) {
            state.change((d) => d.withSelected(false).withTitle(value));
          },
          onChanged: (String value) {
            _debug(context, 'onchanged: ' + value);
            // do not change the state here!!! The auto triggered re-rendering will cause serious perf/rendering issues
          },
          autofocus: true,

          // TextInputFormatters are applied in sequence.
          inputFormatters: [],
        );
      },
    );

void _debug(BuildContext context, String msg) {
  print('**** ' + msg);
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
