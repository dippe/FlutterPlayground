import 'package:flutter/material.dart';
import 'package:todo_flutter_app/BasicChart.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/examples/state/redux/TodoItem.dart';
import 'package:todo_flutter_app/examples/state/redux/action.dart' as Actions;
import 'package:todo_flutter_app/examples/state/redux/login.dart';
import 'package:todo_flutter_app/examples/state/redux/state/domain.dart';
import 'package:todo_flutter_app/examples/state/redux/state/state.dart' as State;

const DEFAULT_ITEM_NAME = 'Unnamed';

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
      body: _renderBody(),
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
      children: [_renderAddButton(), _renderTopMenu],
    );

Widget _renderTopMenu = StoreConnector<TodoAppState, Function>(
    converter: State.dispatchConverter,
    builder: (context, dispatchFn) {
      PopupMenuItemBuilder builder = (BuildContext context) => <PopupMenuEntry<ConfigMenuItems>>[
            PopupMenuItem(value: ConfigMenuItems.About, child: const Text('About')),
            PopupMenuItem(value: ConfigMenuItems.Config, child: const Text('Config')),
            PopupMenuItem(value: ConfigMenuItems.Login, child: const Text('Login')),
          ];
      return PopupMenuButton(
        onSelected: (i) {
          if (i == ConfigMenuItems.Login) {
            dispatchFn(Actions.ShowLoginDialog(true))();
          }
        },
        itemBuilder: builder,
      );
    });

Widget _renderAddButton() => new StoreConnector<TodoAppState, Function>(
      converter: State.dispatchConverter,
      builder: (context, dispatch) {
        return IconButton(
          tooltip: 'New Todo',
          icon: Icon(Icons.add),
          onPressed: dispatch(Actions.Add(DEFAULT_ITEM_NAME)),
        );
      },
    );

Widget _renderTodoListItems() => new StoreConnector<TodoAppState, Function>(
    converter: State.dispatchConverter,
    builder: (context, dispatch) {
      return new StoreConnector<TodoAppState, Todos>(
        converter: (store) => store.state.todos,
        builder: (context, todos) {
          return ListView(
            scrollDirection: Axis.vertical,
            children: todos.list().map((todo) => renderTodoItem(todo, dispatch)).toList(),
          );
        },
      );
    });

Widget _renderBody() => new StoreConnector<TodoAppState, bool>(
    converter: (store) => store.state.todoView.showLogin,
    builder: (context, showLogin) {
      if (showLogin) {
        return renderLoginForm;
      } else {
        return _renderTodoListItems();
      }
    });

void _debug(BuildContext context, String msg) {
  print('**** ' + msg);
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
