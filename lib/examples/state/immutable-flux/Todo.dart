import 'package:flutter/material.dart';
import 'package:flutter_immutable_state/flutter_immutable_state.dart';
import 'package:todo_flutter_app/BasicChart.dart';
import 'package:todo_flutter_app/examples/state/immutable/TodoItem.dart';
import 'package:todo_flutter_app/examples/state/immutable/state/domain.dart';
import 'package:todo_flutter_app/examples/state/immutable/state/state.dart';

const DEFAULT_ITEM_NAME = 'Unnamed';

// This Stateful widget creates connection between the app state and the rendering
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Details about rendering+immutable classes here: https://pub.dartlang.org/packages/flutter_immutable_state
    return ImmutableManager<TodoAppState>(
      immutable: immutableAppState,
//      initialValue: INIT_STATE,
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

Widget _renderMainRoot() => ImmutableView<TodoAppState>.readOnly(
      builder: (context, state) => Scaffold(
            appBar: _renderHeaderAppBar(),
            body: _renderTodoListItems(),
          ),
    );

Widget _renderHeaderAppBar() {
  return AppBar(
    actions: <Widget>[
      ImmutableView<TodoAppState>.readOnly(builder: (context, state) {
        return SimpleBarChart.renderProgressChart(state.todos.lengthDone(), state.todos.lengthTodo());
      }),
      ViewState.todos(_renderMainBtns()),
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

Widget _renderTodoListItems() => ImmutableView<TodoAppState>(
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
              ViewState.todo(renderTodoItem(onDelete(d), onTap, onDoubleTap, onItemDrop), d.id)).toList(),
        );
      },
    );

void _debug(BuildContext context, String msg) {
  print('**** ' + msg);
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
