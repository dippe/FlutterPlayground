import 'package:flutter/material.dart';
import 'package:todo_flutter_app/BasicChart.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/examples/state/redux/TodoItem.dart';
import 'package:todo_flutter_app/examples/state/redux/state/domain.dart';

const DEFAULT_ITEM_NAME = 'Unnamed';

// One simple action: Increment
enum Actions { Increment }

// The reducer, which takes the previous count and increments it in response
// to an Increment action.
TodoAppState todoReducer(TodoAppState state, dynamic action) {
  if (action == Actions.Increment) {
    return state;
  }

  return state;
}

class FlutterReduxApp extends StatelessWidget {
  final Store<TodoAppState> store;

  FlutterReduxApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The StoreProvider should wrap your MaterialApp or WidgetsApp. This will
    // ensure all routes have access to the store.
    return StoreProvider<TodoAppState>(
        // Pass the store to the StoreProvider. Any ancestor `StoreConnector`
        // Widgets will find and use this value as the `Store`.
        store: store,
        child: TodoApp());
  }
}

// This Stateful widget creates connection between the app state and the rendering
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _renderMainRoot(),
      title: 'Test title',
      theme: ThemeData.dark(),
    );
  }
}

/*************************************
 *
 * Renderer functions
 *
 *************************************/

Widget _renderMainRoot() => Scaffold(
      appBar: _renderHeaderAppBar(),
      body: _renderTodoListItems(),
    );

Widget _renderHeaderAppBar() {
  return AppBar(
    actions: <Widget>[
      new StoreConnector<TodoAppState, Todos>(
          converter: (store) => store.state.todos,
          builder: (context, todos) {
            return SimpleBarChart.renderProgressChart(todos.lengthDone(), todos.lengthTodo());
          }),
      _renderMainBtns(),
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

Widget _renderAddButton() => new StoreConnector<TodoAppState, Todos>(
      converter: (store) => store.state.todos,
      builder: (context, state) {
        return IconButton(
          tooltip: 'New Todo',
          icon: Icon(Icons.add),
          onPressed: () {
            _debug(context, 'add clicked');
            // FIXME: re-enable
//            state.change((s) => s.withNewItem(DEFAULT_ITEM_NAME));
          },
        );
      },
    );

Widget _renderTodoListItems() => new StoreConnector<TodoAppState, List<TodoData>>(
      converter: (store) => store.state.todos.list(),
      builder: (context, todos) {
        var onDelete = (d) => () {
//          FIXME: re-enable
//              viewModel.cbs.change((t) => t.withTodos(t.todos.withDeleted(d)));
            };
        var onTap = (TodoData d) {
//          FIXME: re-enable
//       viewModel.cbs.change((t) => t.withTodos(t.todos.withAllUnselected().withUpdated(d.withSelected(true))));
        };
        var onDoubleTap = (TodoData d) {
//          FIXME: re-enable
//       viewModel.cbs.change((t) => t.withTodos(t.todos.withAllUnselected().withUpdated(d.withTitle('').withEdit
// (true))));
        };
        var onItemDrop = (TodoData dragged, TodoData target) {
//          FIXME: re-enable
//       viewModel.cbs.change((t) => t.withTodos(t.todos.withAllUnselected().withMoved(dragged, target)));
        };

        return ListView(
          scrollDirection: Axis.vertical,
          children: todos.map((todo) =>
              // map state to the item
              renderTodoItem(todo, onDelete(todo), onTap, onDoubleTap, onItemDrop)).toList(),
        );
      },
    );

void _debug(BuildContext context, String msg) {
  print('**** ' + msg);
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
